import 'package:omni_for_pyload/domain/repositories/i_pyload_api_repository.dart';
import 'package:omni_for_pyload/domain/repositories/i_server_repository.dart';
import 'package:omni_for_pyload/domain/models/server.dart';

class AddServerViewModel {
  final IServerRepository _serverRepository;
  final IPyLoadApiRepository _pyLoadApiRepository;

  AddServerViewModel({
    required IServerRepository serverRepository,
    required IPyLoadApiRepository pyLoadApiRepository,
  }) : _serverRepository = serverRepository,
       _pyLoadApiRepository = pyLoadApiRepository;

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
    final exists = await _serverRepository.serverExists(ip, portNumber);
    if (exists) {
      throw 'A server with this IP and port already exists';
    }

    final server = Server(
      ip: ip,
      port: portNumber,
      apiKey: apiKey,
      protocol: protocol,
      name: serverName,
      allowInsecure: allowInsecureConnections,
    );

    // Test the connection to the server and verify authentication
    await _pyLoadApiRepository.getServerStatus(server);

    await _serverRepository.addServer(server);

    return server;
  }
}
