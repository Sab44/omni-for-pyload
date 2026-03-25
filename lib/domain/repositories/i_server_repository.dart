import 'package:omni_for_pyload/domain/models/server.dart';

/// Interface for server storage and retrieval
abstract class IServerRepository {
  /// Get all servers from local storage
  Future<List<Server>> getAllServers();

  /// Add a new server
  Future<void> addServer(Server server);

  /// Check if a server with the same IP and port already exists
  Future<bool> serverExists(String ip, int port);

  /// Remove a server by key
  Future<void> removeServer(String ip, int port);

  /// Update an existing server
  Future<void> updateServer(Server server);

  /// Clear all servers
  Future<void> clearAllServers();
}
