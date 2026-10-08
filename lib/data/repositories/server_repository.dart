import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:omni_for_pyload/domain/models/server.dart';
import 'package:omni_for_pyload/domain/repositories/i_server_repository.dart';

class ServerRepository implements IServerRepository {
  static const String _serversKey = 'servers';
  static const String _securePrefix = 'server_credentials:';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// Get all servers from local storage
  @override
  Future<List<Server>> getAllServers() async {
    final prefs = await SharedPreferences.getInstance();
    final serversJson = prefs.getString(_serversKey);
    if (serversJson == null) return [];

    final serversData = jsonDecode(serversJson) as List<dynamic>;
    final servers = serversData
        .map((json) => Server.fromJson(json as Map<String, dynamic>))
        .toList();

    // Reattach API key from secure storage
    var hasPlaintextApiKeys = false;
    for (var i = 0; i < servers.length; i++) {
      final server = servers[i];
      final apiKey = await _readApiKey(server.ip, server.port);
      if (apiKey != null) {
        servers[i] = server.copyWith(apiKey: apiKey);
      } else if (server.apiKey.isNotEmpty) {
        // Key only exists in plain text; move it to secure storage
        await _writeApiKey(server.ip, server.port, server.apiKey);
      }
      if (server.apiKey.isNotEmpty) hasPlaintextApiKeys = true;
    }

    // Earlier versions could persist API keys in shared preferences
    if (hasPlaintextApiKeys) {
      await _saveServers(prefs, servers);
    }

    return servers;
  }

  /// Add a new server
  @override
  Future<void> addServer(Server server) async {
    final prefs = await SharedPreferences.getInstance();
    final currentServers = await getAllServers();
    // Store API key in secure storage and add server without API key to list
    await _writeApiKey(server.ip, server.port, server.apiKey);
    currentServers.add(server);
    await _saveServers(prefs, currentServers);
  }

  /// Check if a server with the same IP and port already exists
  @override
  Future<bool> serverExists(String ip, int port) async {
    final servers = await getAllServers();
    return servers.any((server) => server.ip == ip && server.port == port);
  }

  /// Remove a server by IP and port
  @override
  Future<void> removeServer(String ip, int port) async {
    final prefs = await SharedPreferences.getInstance();
    final currentServers = await getAllServers();
    currentServers.removeWhere(
      (server) => server.ip == ip && server.port == port,
    );
    await _saveServers(prefs, currentServers);
    // Remove API key stored for this server
    try {
      await _deleteApiKey(ip, port);
    } catch (_) {}
  }

  /// Update an existing server
  @override
  Future<void> updateServer(Server server) async {
    final prefs = await SharedPreferences.getInstance();
    final currentServers = await getAllServers();
    final index = currentServers.indexWhere(
      (s) => s.ip == server.ip && s.port == server.port,
    );
    if (index != -1) {
      // Update API key in secure storage and update server in list
      await _writeApiKey(server.ip, server.port, server.apiKey);
      currentServers[index] = server;
      await _saveServers(prefs, currentServers);
    }
  }

  /// Replace a server, which may change its IP and port
  @override
  Future<void> replaceServer(Server original, Server updated) async {
    final prefs = await SharedPreferences.getInstance();
    final currentServers = await getAllServers();
    final index = currentServers.indexWhere(
      (s) => s.ip == original.ip && s.port == original.port,
    );
    if (index == -1) {
      throw StateError('Server ${original.ip}:${original.port} does not exist');
    }

    // Write the new API key before updating the list, and delete the old one
    // last, so an interrupted update never leaves a server without its key
    await _writeApiKey(updated.ip, updated.port, updated.apiKey);
    currentServers[index] = updated;
    await _saveServers(prefs, currentServers);

    final keyChanged =
        original.ip != updated.ip || original.port != updated.port;
    if (keyChanged) {
      await _deleteApiKey(original.ip, original.port);
    }
  }

  /// Clear all servers
  @override
  Future<void> clearAllServers() async {
    final prefs = await SharedPreferences.getInstance();
    final currentServers = await getAllServers();
    // Delete API keys for all stored servers
    for (final server in currentServers) {
      await _deleteApiKey(server.ip, server.port);
    }
    await prefs.remove(_serversKey);
  }

  /// Persist the server list. API keys are never written to shared
  /// preferences; they live in secure storage only.
  Future<void> _saveServers(
    SharedPreferences prefs,
    List<Server> servers,
  ) async {
    final serversJson = jsonEncode(
      servers.map((s) => s.copyWith(apiKey: '').toJson()).toList(),
    );
    await prefs.setString(_serversKey, serversJson);
  }

  /// Secure storage helpers
  String _secureKey(String ip, int port) => '$_securePrefix$ip:$port';

  Future<void> _writeApiKey(String ip, int port, String apiKey) async {
    final key = _secureKey(ip, port);
    await _secureStorage.write(key: key, value: jsonEncode({'apiKey': apiKey}));
  }

  Future<String?> _readApiKey(String ip, int port) async {
    final key = _secureKey(ip, port);
    final val = await _secureStorage.read(key: key);
    if (val == null) return null;
    try {
      final decoded = jsonDecode(val) as Map<String, dynamic>;
      return decoded['apiKey'] as String?;
    } catch (_) {
      return null;
    }
  }

  Future<void> _deleteApiKey(String ip, int port) async {
    final key = _secureKey(ip, port);
    await _secureStorage.delete(key: key);
  }
}
