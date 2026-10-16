import 'package:omni_for_pyload/domain/models/server.dart';
import 'package:omni_for_pyload/domain/models/server_id.dart';

/// Interface for server storage and retrieval
abstract class IServerRepository {
  /// Get all servers from local storage
  Future<List<Server>> getAllServers();

  /// Get the server with [id], or null if it does not exist
  Future<Server?> getServer(ServerId id);

  /// Add a new server
  Future<void> addServer(Server server);

  /// Check if a server with [id] already exists
  Future<bool> serverExists(ServerId id);

  /// Remove the server with [id]
  Future<void> removeServer(ServerId id);

  /// Update the existing server with the same [Server.id]
  Future<void> updateServer(Server server);

  /// Replace the server with [originalId] with [updated], keeping its
  /// position in the list
  ///
  /// [updated] may have a different IP or port. The stored API key is moved
  /// accordingly. Throws a [StateError] if [originalId] does not exist.
  Future<void> replaceServer(ServerId originalId, Server updated);

  /// Clear all servers
  Future<void> clearAllServers();
}
