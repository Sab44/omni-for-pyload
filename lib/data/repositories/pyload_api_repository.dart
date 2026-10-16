import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:omni_for_pyload/core/utils/http_client_factory.dart';
import 'package:openapi_client/api.dart';
import 'package:omni_for_pyload/domain/models/pyload_api_failure.dart';
import 'package:omni_for_pyload/domain/models/server.dart';
import 'package:omni_for_pyload/domain/models/server_id.dart';
import 'package:omni_for_pyload/domain/repositories/i_pyload_api_repository.dart';

class PyLoadApiRepository implements IPyLoadApiRepository {
  static final _log = Logger('PyLoadApiRepository');
  static const Duration _defaultTimeout = Duration(seconds: 2);

  final http.Client Function(bool allowInsecure) _createClient;
  final Duration _timeout;

  /// Open connection per server
  final Map<ServerId, _Connection> _connections = {};

  /// [createClient] builds the HTTP client for a connection, [timeout] limits
  /// every request
  PyLoadApiRepository({
    this._createClient = HttpClientFactory.createClient,
    this._timeout = _defaultTimeout,
  });

  /// Returns the API for [server], reusing its connection while the
  /// connection parameters stay the same
  ///
  /// If they changed, the previous connection is closed once its running
  /// requests finished.
  PyLoadRESTApi _configureApi(Server server) {
    final existing = _connections[server.id];
    if (existing != null &&
        existing.server.areMainConnectionParametersEqualTo(server)) {
      return existing.api;
    }

    existing?.client.retire();
    final connection = _Connection.open(
      server,
      _RetirableClient(_createClient(server.allowInsecure)),
    );
    _connections[server.id] = connection;
    return connection.api;
  }

  /// Runs [request] with the request timeout and maps every error to a
  /// [PyLoadApiFailure]
  Future<T> _execute<T>(Future<T> Function() request) async {
    try {
      return await request().timeout(_timeout);
    } catch (e, stackTrace) {
      final failure = _toFailure(e);
      if (failure is PyLoadApiBadResponse) {
        // Also covers errors of the client itself, which would be hidden
        // behind the failure otherwise
        _log.warning('Unexpected response', e, stackTrace);
      } else {
        _log.fine('Request failed: $failure', e, stackTrace);
      }
      throw failure;
    }
  }

  /// Returns [body], failing with [PyLoadApiBadResponse] if it is missing
  static T _requireBody<T>(T? body) {
    if (body == null) {
      _log.fine('Response body missing, expected $T');
      throw const PyLoadApiBadResponse();
    }
    return body;
  }

  static PyLoadApiFailure _toFailure(Object error) => switch (error) {
    TimeoutException() => const PyLoadApiTimeout(),
    // The client wraps connection problems in an ApiException
    ApiException(innerException: IOException() || http.ClientException()) =>
      const PyLoadApiUnreachable(),
    // Thrown by the client itself if the body does not match the expected type
    ApiException(:final message?) when message.contains('deserialization') =>
      const PyLoadApiBadResponse(),
    ApiException(code: 401) => const PyLoadApiUnauthorized(),
    ApiException(:final code) => PyLoadApiServerError(code),
    _ => const PyLoadApiBadResponse(),
  };

  /// Get the server status
  ///
  /// Returns a ServerStatus object with current server information.
  @override
  Future<ServerStatus> getServerStatus(Server server) async {
    final api = _configureApi(server);
    final status = await _execute(() => api.apiStatusServerGet());
    return _requireBody(status);
  }

  /// Get the status of all currently running downloads
  ///
  /// Returns a list of DownloadInfo objects representing the current downloads.
  /// Returns an empty list if no downloads are active.
  @override
  Future<List<DownloadInfo>> getDownloadStatus(Server server) async {
    final api = _configureApi(server);
    final downloadInfoList = await _execute(() => api.apiStatusDownloadsGet());
    return downloadInfoList ?? [];
  }

  /// Get the queue packages (without file details)
  ///
  /// Returns a list of PackageData objects representing the packages in the queue.
  /// Does not include file details - use getPackageData for full details.
  @override
  Future<List<PackageData>> getQueue(Server server) async {
    final api = _configureApi(server);
    final queueList = await _execute(() => api.apiGetQueueGet());
    return queueList ?? [];
  }

  /// Get the collector packages (without file details)
  ///
  /// Returns a list of PackageData objects representing the packages in the collector.
  /// Does not include file details - use getPackageData for full details.
  @override
  Future<List<PackageData>> getCollector(Server server) async {
    final api = _configureApi(server);
    final collectorList = await _execute(() => api.apiGetCollectorGet());
    return collectorList ?? [];
  }

  /// Get complete information about a package, including files
  ///
  /// Returns PackageData with complete information including all files.
  @override
  Future<PackageData> getPackageData(Server server, int packageId) async {
    final api = _configureApi(server);
    final packageData = await _execute(
      () => api.apiGetPackageDataGet(packageId),
    );
    return _requireBody(packageData);
  }

  /// Deletes packages by their IDs
  @override
  Future<void> deletePackages(Server server, List<int> packageIds) async {
    final api = _configureApi(server);
    await _execute(
      () => api.apiDeletePackagesPost(
        apiDeletePackagesPostRequest: ApiDeletePackagesPostRequest(
          packageIds: packageIds,
        ),
      ),
    );
  }

  /// Restarts packages by their IDs
  @override
  Future<Result> restartPackages(Server server, List<int> packageIds) {
    final api = _configureApi(server);
    return _forEachPackage(packageIds, api.apiRestartPackagePost);
  }

  /// Moves packages to a different destination
  @override
  Future<Result> movePackages(
    Server server,
    List<int> packageIds,
    Destination destination,
  ) {
    final api = _configureApi(server);
    return _forEachPackage(
      packageIds,
      (id) => api.apiMovePackagePost(destination, id),
    );
  }

  /// Triggers archive extraction for given packages
  ///
  /// Extraction is requested per package, so failures can be reported per
  /// package.
  @override
  Future<Result> extractPackages(Server server, List<int> packageIds) {
    final api = _configureApi(server);
    return _forEachPackage(
      packageIds,
      (id) => api.apiServiceCallPost(
        apiServiceCallPostRequest: ApiServiceCallPostRequest(
          serviceName: "ExtractArchive.extract_package",
          arguments: [id],
          parseArguments: false,
        ),
      ),
    );
  }

  /// Runs [action] for every package in parallel and reports how many succeeded
  Future<Result> _forEachPackage(
    List<int> packageIds,
    Future<void> Function(int packageId) action,
  ) async {
    var successCount = 0;

    await Future.wait(
      packageIds.map((id) async {
        try {
          await _execute(() => action(id));
          successCount++;
        } on PyLoadApiFailure {
          // Counted as not successful, already logged
        }
      }),
    );

    if (successCount == packageIds.length) return Result.success;
    if (successCount > 0) return Result.partial;
    return Result.failure;
  }

  /// Pause the PyLoad server
  @override
  Future<void> pauseServer(Server server) async {
    final api = _configureApi(server);
    await _execute(() => api.apiPauseServerPost());
  }

  /// Unpause the PyLoad server
  @override
  Future<void> unpauseServer(Server server) async {
    final api = _configureApi(server);
    await _execute(() => api.apiUnpauseServerPost());
  }

  /// Stop all running downloads on the server
  @override
  Future<void> stopAllDownloads(Server server) async {
    final api = _configureApi(server);
    await _execute(() => api.apiStopAllDownloadsPost());
  }

  /// Delete all finished downloads on the server
  @override
  Future<void> deleteFinished(Server server) async {
    final api = _configureApi(server);
    await _execute(() => api.apiDeleteFinishedPost());
  }

  /// Restart all failed downloads on the server
  @override
  Future<void> restartFailed(Server server) async {
    final api = _configureApi(server);
    await _execute(() => api.apiRestartFailedPost());
  }

  /// Uploads a container file (.dlc) to the server
  @override
  Future<void> uploadContainer(
    Server server,
    String fileName,
    List<int> fileBytes,
    Destination destination,
  ) async {
    final api = _configureApi(server);
    final multipartFile = http.MultipartFile.fromBytes(
      'data',
      fileBytes,
      filename: fileName,
    );
    await _execute(
      () => api.apiUploadContainerPost(
        fileName,
        multipartFile,
        dest: destination,
      ),
    );
  }

  /// Adds a new package with links to the server
  @override
  Future<int> addPackage(
    Server server,
    String name,
    List<String> links,
    Destination destination,
  ) async {
    final api = _configureApi(server);
    final packageId = await _execute(
      () => api.apiAddPackagePost(
        apiAddPackagePostRequest: ApiAddPackagePostRequest(
          name: name,
          links: links,
          dest: destination,
        ),
      ),
    );
    return _requireBody(packageId);
  }

  /// Sets or updates the password for a specific package
  @override
  Future<void> setPackagePassword(
    Server server,
    int packageId,
    String password,
  ) async {
    final api = _configureApi(server);
    await _execute(
      () => api.apiSetPackageDataPost(
        apiSetPackageDataPostRequest: ApiSetPackageDataPostRequest(
          packageId: packageId,
          data: Map.of({'password': password}),
        ),
      ),
    );
  }
}

/// The API of one server, bound to the parameters it was opened with
class _Connection {
  final Server server;
  final _RetirableClient client;
  final PyLoadRESTApi api;

  _Connection._(this.server, this.client, this.api);

  factory _Connection.open(Server server, _RetirableClient client) {
    final apiKeyAuth = ApiKeyAuth('header', 'X-API-Key')
      ..apiKey = server.apiKey;
    final apiClient = ApiClient(
      basePath: server.baseUrl,
      authentication: apiKeyAuth,
    )..client = client;
    return _Connection._(server, client, PyLoadRESTApi(apiClient));
  }
}

/// Delegates to [_inner] and closes it once retired and no request is running
///
/// Closing an `IOClient` right away would abort requests that are still
/// running on the replaced connection.
class _RetirableClient extends http.BaseClient {
  final http.Client _inner;
  int _runningRequests = 0;
  bool _isRetired = false;

  _RetirableClient(this._inner);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    _runningRequests++;
    try {
      final response = await _inner.send(request);
      // The request runs until its body was read
      final body = StreamController<List<int>>();
      response.stream.listen(
        body.add,
        onError: body.addError,
        onDone: () {
          body.close();
          _finishRequest();
        },
        cancelOnError: false,
      );
      return http.StreamedResponse(
        body.stream,
        response.statusCode,
        contentLength: response.contentLength,
        request: response.request,
        headers: response.headers,
        isRedirect: response.isRedirect,
        persistentConnection: response.persistentConnection,
        reasonPhrase: response.reasonPhrase,
      );
    } catch (_) {
      _finishRequest();
      rethrow;
    }
  }

  /// Closes the client as soon as no request is running anymore
  void retire() {
    _isRetired = true;
    _closeIfIdle();
  }

  void _finishRequest() {
    _runningRequests--;
    _closeIfIdle();
  }

  void _closeIfIdle() {
    if (_isRetired && _runningRequests == 0) _inner.close();
  }
}
