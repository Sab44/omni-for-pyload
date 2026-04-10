import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:omni_for_pyload/core/utils/http_client_factory.dart';
import 'package:openapi_client/api.dart';
import 'package:omni_for_pyload/domain/models/server.dart';
import 'package:omni_for_pyload/domain/repositories/i_pyload_api_repository.dart';

class PyLoadApiRepository implements IPyLoadApiRepository {
  static const Duration _connectionTimeout = Duration(seconds: 2);

  Server? _currentServer;
  PyLoadRESTApi? _cachedApi;

  /// Configures and returns a PyLoadRESTApi instance with proper authentication
  ///
  /// Uses caching for the same server configuration.
  /// Creates a new instance if the server configuration changes.
  ///
  /// Parameters:
  /// - [server]: The server configuration with IP, port and API key
  ///
  /// Returns a configured PyLoadRESTApi instance
  PyLoadRESTApi _configureApi(Server server) {
    // Return cached API if the server hasn't changed
    if (_currentServer?.areMainConnectionParametersEqualTo(server) == true &&
        _cachedApi != null) {
      return _cachedApi!;
    }

    _currentServer = server;

    // Create API client with the server configuration and authentication
    final basePath = '${server.protocol}://${server.ip}:${server.port}';
    final apiKeyAuth = ApiKeyAuth('header', 'X-API-Key');
    apiKeyAuth.apiKey = server.apiKey;
    final apiClient = ApiClient(basePath: basePath, authentication: apiKeyAuth);

    // Inject custom client without certificate validation if user configured
    if (server.allowInsecure) {
      apiClient.client = HttpClientFactory.createClient(true);
    }

    // Create API instance with the configured client
    _cachedApi = PyLoadRESTApi(apiClient);

    return _cachedApi!;
  }

  /// Executes a network request with timeout and error handling
  ///
  /// Wraps any Future-returning API call with:
  /// - Timeout handling
  /// - API exception handling with user-friendly error messages
  /// - Generic error handling that converts unknown errors to ApiException
  ///
  /// Parameters:
  /// - [request]: A Future that represents the API call
  /// - [timeout]: Optional custom timeout duration
  ///
  /// Throws:
  /// - [TimeoutException]: When the request exceeds the timeout duration
  /// - [ApiException]: For API errors or unknown errors with user-friendly messages
  Future<T> executeNetworkRequest<T>(
    Future<T> Function() request, {
    Duration timeout = _connectionTimeout,
  }) async {
    try {
      return await request().timeout(
        timeout,
        onTimeout: () => throw TimeoutException('Connection timeout'),
      );
    } on TimeoutException {
      rethrow;
    } on ApiException catch (e) {
      if (e.code == 401) {
        throw ApiException(
          401,
          'Authentication failed. Please check your API key.',
        );
      } else if (e.code >= 500) {
        throw ApiException(e.code, 'Server error: ${e.message}');
      } else {
        throw ApiException(e.code, 'Server connection failed: ${e.message}');
      }
    } catch (e) {
      throw ApiException(500, 'Unknown error occurred: $e');
    }
  }

  /// Get the server status
  ///
  /// Returns a ServerStatus object with current server information.
  @override
  Future<ServerStatus> getServerStatus(Server server) async {
    final api = _configureApi(server);
    final status = await executeNetworkRequest(() => api.apiStatusServerGet());
    if (status == null) {
      throw 'Failed to get server status';
    }
    return status;
  }

  /// Get the status of all currently running downloads
  ///
  /// Returns a list of DownloadInfo objects representing the current downloads.
  /// Returns an empty list if no downloads are active.
  @override
  Future<List<DownloadInfo>> getDownloadStatus(Server server) async {
    final api = _configureApi(server);
    final downloadInfoList = await executeNetworkRequest(
      () => api.apiStatusDownloadsGet(),
    );
    return downloadInfoList ?? [];
  }

  /// Get the queue data of all packages
  ///
  /// Returns a list of PackageData objects representing the packages in the queue.
  /// Returns an empty list if no packages are queued.
  @override
  Future<List<PackageData>> getQueueData(Server server) async {
    final api = _configureApi(server);
    final queueDataList = await executeNetworkRequest(
      () => api.apiGetQueueDataGet(),
    );
    return queueDataList ?? [];
  }

  /// Get the collector data of all packages
  ///
  /// Returns a list of PackageData objects representing the packages in the collector.
  /// Returns an empty list if no packages are in the collector.
  @override
  Future<List<PackageData>> getCollectorData(Server server) async {
    final api = _configureApi(server);
    final collectorDataList = await executeNetworkRequest(
      () => api.apiGetCollectorDataGet(),
    );
    return collectorDataList ?? [];
  }

  /// Get the queue packages (without file details)
  ///
  /// Returns a list of PackageData objects representing the packages in the queue.
  /// Does not include file details - use getPackageData for full details.
  @override
  Future<List<PackageData>> getQueue(Server server) async {
    final api = _configureApi(server);
    final queueList = await executeNetworkRequest(() => api.apiGetQueueGet());
    return queueList ?? [];
  }

  /// Get the collector packages (without file details)
  ///
  /// Returns a list of PackageData objects representing the packages in the collector.
  /// Does not include file details - use getPackageData for full details.
  @override
  Future<List<PackageData>> getCollector(Server server) async {
    final api = _configureApi(server);
    final collectorList = await executeNetworkRequest(
      () => api.apiGetCollectorGet(),
    );
    return collectorList ?? [];
  }

  /// Get complete information about a package, including files
  ///
  /// Returns PackageData with complete information including all files.
  @override
  Future<PackageData> getPackageData(Server server, int packageId) async {
    final api = _configureApi(server);
    final packageData = await executeNetworkRequest(
      () => api.apiGetPackageDataGet(packageId),
    );
    if (packageData == null) {
      throw 'Package data not found for package ID: $packageId';
    }
    return packageData;
  }

  /// Deletes packages by their IDs
  @override
  Future<void> deletePackages(Server server, List<int> packageIds) async {
    final api = _configureApi(server);
    await executeNetworkRequest(
      () => api.apiDeletePackagesPost(
        apiDeletePackagesPostRequest: ApiDeletePackagesPostRequest(
          packageIds: packageIds,
        ),
      ),
    );
  }

  /// Restarts packages by their IDs
  @override
  Future<Result> restartPackages(Server server, List<int> packageIds) async {
    final api = _configureApi(server);
    int successCount = 0;

    await Future.wait(
      packageIds.map((id) async {
        try {
          await executeNetworkRequest(() => api.apiRestartPackagePost(id));
          successCount++;
        } catch (e) {
          // Ignore individual failures but track success count
        }
      }),
    );

    if (successCount == packageIds.length) {
      return Result.success;
    } else if (successCount > 0) {
      return Result.partial;
    } else {
      return Result.failure;
    }
  }

  /// Moves packages to a different destination
  @override
  Future<Result> movePackages(
    Server server,
    List<int> packageIds,
    Destination destination,
  ) async {
    final api = _configureApi(server);
    int successCount = 0;

    await Future.wait(
      packageIds.map((id) async {
        try {
          await executeNetworkRequest(
            () => api.apiMovePackagePost(destination, id),
          );
          successCount++;
        } catch (e) {
          // Ignore individual failures but track success count
        }
      }),
    );

    if (successCount == packageIds.length) {
      return Result.success;
    } else if (successCount > 0) {
      return Result.partial;
    } else {
      return Result.failure;
    }
  }

  /// Triggers archive extraction for given packages
  @override
  Future<Result> extractPackages(Server server, List<int> packageIds) async {
    final api = _configureApi(server);

    await executeNetworkRequest(
      () => api.apiServiceCallPost(
        apiServiceCallPostRequest: ApiServiceCallPostRequest(
          serviceName: "ExtractArchive.extract_package",
          arguments: packageIds,
          parseArguments: false,
        ),
      ),
    );

    return Result.success;
  }

  /// Pause the PyLoad server
  @override
  Future<void> pauseServer(Server server) async {
    final api = _configureApi(server);
    await executeNetworkRequest(() => api.apiPauseServerPost());
  }

  /// Unpause the PyLoad server
  @override
  Future<void> unpauseServer(Server server) async {
    final api = _configureApi(server);
    await executeNetworkRequest(() => api.apiUnpauseServerPost());
  }

  /// Stop all running downloads on the server
  @override
  Future<void> stopAllDownloads(Server server) async {
    final api = _configureApi(server);
    await executeNetworkRequest(() => api.apiStopAllDownloadsPost());
  }

  /// Delete all finished downloads on the server
  @override
  Future<void> deleteFinished(Server server) async {
    final api = _configureApi(server);
    await executeNetworkRequest(() => api.apiDeleteFinishedPost());
  }

  /// Restart all failed downloads on the server
  @override
  Future<void> restartFailed(Server server) async {
    final api = _configureApi(server);
    await executeNetworkRequest(() => api.apiRestartFailedPost());
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
    await executeNetworkRequest(
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
    final packageId = await executeNetworkRequest(
      () => api.apiAddPackagePost(
        apiAddPackagePostRequest: ApiAddPackagePostRequest(
          name: name,
          links: links,
          dest: destination,
        ),
      ),
    );
    if (packageId == null) {
      throw 'Failed to create package: No package ID returned';
    }
    return packageId;
  }

  /// Sets or updates the password for a specific package
  @override
  Future<void> setPackagePassword(
    Server server,
    int packageId,
    String password,
  ) async {
    final api = _configureApi(server);
    await executeNetworkRequest(
      () => api.apiSetPackageDataPost(
        apiSetPackageDataPostRequest: ApiSetPackageDataPostRequest(
          packageId: packageId,
          data: Map.of({'password': password}),
        ),
      ),
    );
  }
}
