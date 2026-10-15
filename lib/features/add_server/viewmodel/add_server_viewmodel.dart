import 'package:omni_for_pyload/domain/repositories/i_local_network_repository.dart';
import 'package:omni_for_pyload/domain/repositories/i_pyload_api_repository.dart';
import 'package:omni_for_pyload/domain/repositories/i_server_repository.dart';
import 'package:omni_for_pyload/domain/models/server.dart';

/// Thrown if iOS denies the app access to the server in the local network
class LocalNetworkAccessDeniedException implements Exception {
  const LocalNetworkAccessDeniedException();

  @override
  String toString() =>
      'Omni is not allowed to access devices in your local network. '
      'Please enable "Local Network" in the app settings and try again.';
}

class AddServerViewModel {
  final IServerRepository _serverRepository;
  final IPyLoadApiRepository _pyLoadApiRepository;
  final ILocalNetworkRepository _localNetworkRepository;

  AddServerViewModel({
    required this._serverRepository,
    required this._pyLoadApiRepository,
    required this._localNetworkRepository,
  });

  /// Validate and add a server
  /// Returns the server if successful, or throws an exception with error message
  Future<Server> validateAndAddServer({
    required String name,
    required String ip,
    required String port,
    required String apiKey,
    required String protocol,
    required bool allowInsecureConnections,
  }) async {
    final server = await _validate(
      name: name,
      ip: ip,
      port: port,
      apiKey: apiKey,
      protocol: protocol,
      allowInsecureConnections: allowInsecureConnections,
    );

    await _testConnection(server);

    await _serverRepository.addServer(server);

    return server;
  }

  /// Parse a server configuration QR code from pyLoad's web UI and add it
  ///
  /// The QR code contains a link like
  /// `http://host:8000/qr-redirector#host=host&port=8000&path=&ssl=false&key=...`.
  /// Runs the same validation and connection test as [validateAndAddServer].
  /// Returns the server if successful, or throws an exception with error message
  Future<Server> addServerFromQrCode(String qrCode) async {
    final config = parseQrCode(qrCode);

    if (config.path.isNotEmpty) {
      throw 'pyLoad instances with a path prefix (/${config.path}) are '
          'currently not supported';
    }

    return validateAndAddServer(
      name: 'pyLoad',
      ip: config.host,
      port: config.port,
      apiKey: config.apiKey,
      protocol: config.ssl ? 'https' : 'http',
      allowInsecureConnections: false,
    );
  }

  /// Extracts the server configuration from a pyLoad QR code link
  ///
  /// Throws an error message if [qrCode] is not a pyLoad server QR code.
  static ({String host, String port, String path, bool ssl, String apiKey})
  parseQrCode(String qrCode) {
    const invalidMessage = 'This is not a valid pyLoad server QR code';

    final uri = Uri.tryParse(qrCode.trim());
    if (uri == null || uri.pathSegments.isEmpty || uri.fragment.isEmpty) {
      throw invalidMessage;
    }

    final Map<String, String> params;
    try {
      params = Uri.splitQueryString(uri.fragment);
    } catch (e) {
      throw invalidMessage;
    }

    final host = params['host'];
    final port = params['port'];
    final apiKey = params['key'];
    if (host == null || host.isEmpty || port == null || apiKey == null) {
      throw invalidMessage;
    }

    final path = (params['path'] ?? '').replaceAll(RegExp(r'^/+|/+$'), '');

    return (
      host: host,
      port: port,
      path: path,
      ssl: params['ssl'] == 'true',
      apiKey: apiKey,
    );
  }

  /// Validate the edited fields and replace [original] with the result
  ///
  /// Uses the same validation as [validateAndAddServer]. Settings that are not
  /// part of the form (Click'N'Load) are kept. If nothing changed, [original]
  /// is returned without saving or contacting the server.
  /// Returns the updated server if successful, or throws an exception with error message
  Future<Server> validateAndUpdateServer({
    required Server original,
    required String name,
    required String ip,
    required String port,
    required String apiKey,
    required String protocol,
    required bool allowInsecureConnections,
  }) async {
    final server = await _validate(
      original: original,
      name: name,
      ip: ip,
      port: port,
      apiKey: apiKey,
      protocol: protocol,
      allowInsecureConnections: allowInsecureConnections,
    );

    if (server == original) return original;

    await _testConnection(server);

    await _serverRepository.replaceServer(original, server);

    return server;
  }

  /// Open the app's page in the system settings, e.g. to allow local network
  /// access after a [LocalNetworkAccessDeniedException]
  Future<void> openAppSettings() => _localNetworkRepository.openAppSettings();

  /// Tests the connection to [server] and verifies authentication
  ///
  /// Throws [LocalNetworkAccessDeniedException] if the platform blocks access,
  /// as the connection test would only fail with a generic error then.
  Future<void> _testConnection(Server server) async {
    if (await _localNetworkRepository.isAccessDenied(server)) {
      throw const LocalNetworkAccessDeniedException();
    }

    await _pyLoadApiRepository.getServerStatus(server);
  }

  /// Validates the form fields and builds the resulting server
  ///
  /// When editing, [original] is the server being edited: its remaining
  /// settings are kept and it is not reported as its own duplicate.
  Future<Server> _validate({
    Server? original,
    required String name,
    required String ip,
    required String port,
    required String apiKey,
    required String protocol,
    required bool allowInsecureConnections,
  }) async {
    // Validate and default server name
    final serverName = name.trim().isEmpty ? 'pyLoad' : name.trim();

    // Validate IP/Hostname
    if (ip.isEmpty) {
      throw 'IP or hostname is required';
    }

    // Validate port
    int? portNumber;
    try {
      portNumber = int.parse(port);
    } catch (e) {
      throw 'Port must be a valid number';
    }

    if (portNumber <= 0 || portNumber > 65535) {
      throw 'Port must be between 1 and 65535';
    }

    // Validate API key
    if (apiKey.isEmpty) {
      throw 'API Key is required';
    }

    // Check if server with same IP and port already exists
    final isSameServer = original?.ip == ip && original?.port == portNumber;
    if (!isSameServer) {
      final exists = await _serverRepository.serverExists(ip, portNumber);
      if (exists) {
        throw 'A server with this IP and port already exists';
      }
    }

    if (original != null) {
      return original.copyWith(
        ip: ip,
        port: portNumber,
        apiKey: apiKey,
        protocol: protocol,
        name: serverName,
        allowInsecure: allowInsecureConnections,
      );
    }

    return Server(
      ip: ip,
      port: portNumber,
      apiKey: apiKey,
      protocol: protocol,
      name: serverName,
      allowInsecure: allowInsecureConnections,
    );
  }
}
