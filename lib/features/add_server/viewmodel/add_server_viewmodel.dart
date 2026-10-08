import 'package:omni_for_pyload/domain/repositories/i_pyload_api_repository.dart';
import 'package:omni_for_pyload/domain/repositories/i_server_repository.dart';
import 'package:omni_for_pyload/domain/models/server.dart';

class AddServerViewModel {
  final IServerRepository _serverRepository;
  final IPyLoadApiRepository _pyLoadApiRepository;

  AddServerViewModel({
    required this._serverRepository,
    required this._pyLoadApiRepository,
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

    // Test the connection to the server and verify authentication
    await _pyLoadApiRepository.getServerStatus(server);

    await _serverRepository.addServer(server);

    return server;
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

    // Test the connection to the server and verify authentication
    await _pyLoadApiRepository.getServerStatus(server);

    await _serverRepository.replaceServer(original, server);

    return server;
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
