import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:omni_for_pyload/domain/models/server.dart';
import 'package:omni_for_pyload/domain/models/server_id.dart';
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
      final apiKey = await _readApiKey(server.id);
      if (apiKey != null) {
        servers[i] = server.copyWith(apiKey: apiKey);
      } else if (server.apiKey.isNotEmpty) {
        // Key only exists in plain text; move it to secure storage
        await _writeApiKey(server.id, server.apiKey);
      }
      if (server.apiKey.isNotEmpty) hasPlaintextApiKeys = true;
    }

    // Earlier versions could persist API keys in shared preferences
    if (hasPlaintextApiKeys) {
      await _saveServers(prefs, servers);
    }

    return servers;
  }

  /// Get the server with [id], or null if it does not exist
  @override
  Future<Server?> getServer(ServerId id) async {
    final servers = await getAllServers();
    return servers.where((server) => server.id == id).firstOrNull;
  }

  /// Add a new server
  @override
  Future<void> addServer(Server server) async {
    final prefs = await SharedPreferences.getInstance();
    final currentServers = await getAllServers();
    // Store API key in secure storage and add server without API key to list
    await _writeApiKey(server.id, server.apiKey);
    currentServers.add(server);
    await _saveServers(prefs, currentServers);
  }

  /// Check if a server with [id] already exists
  @override
  Future<bool> serverExists(ServerId id) async {
    final servers = await getAllServers();
    return servers.any((server) => server.id == id);
  }

  /// Remove the server with [id]
  @override
  Future<void> removeServer(ServerId id) async {
    final prefs = await SharedPreferences.getInstance();
    final currentServers = await getAllServers();
    currentServers.removeWhere((server) => server.id == id);
    await _saveServers(prefs, currentServers);
    // Remove API key stored for this server
    try {
      await _deleteApiKey(id);
    } catch (_) {}
  }

  /// Update an existing server
  @override
  Future<void> updateServer(Server server) async {
    final prefs = await SharedPreferences.getInstance();
    final currentServers = await getAllServers();
    final index = currentServers.indexWhere((s) => s.id == server.id);
    if (index != -1) {
      // Update API key in secure storage and update server in list
      await _writeApiKey(server.id, server.apiKey);
      currentServers[index] = server;
      await _saveServers(prefs, currentServers);
    }
  }

  /// Replace a server, which may change its IP and port
  @override
  Future<void> replaceServer(ServerId originalId, Server updated) async {
    final prefs = await SharedPreferences.getInstance();
    final currentServers = await getAllServers();
    final index = currentServers.indexWhere((s) => s.id == originalId);
    if (index == -1) {
      throw StateError('Server $originalId does not exist');
    }

    // Write the new API key before updating the list, and delete the old one
    // last, so an interrupted update never leaves a server without its key
    await _writeApiKey(updated.id, updated.apiKey);
    currentServers[index] = updated;
    await _saveServers(prefs, currentServers);

    if (originalId != updated.id) {
      await _deleteApiKey(originalId);
    }
  }

  /// Clear all servers
  @override
  Future<void> clearAllServers() async {
    final prefs = await SharedPreferences.getInstance();
    final currentServers = await getAllServers();
    // Delete API keys for all stored servers
    for (final server in currentServers) {
      await _deleteApiKey(server.id);
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
  ///
  /// The key format is spelled out instead of using [ServerId.toString], so
  /// stored keys stay readable if that representation ever changes.
  String _secureKey(ServerId id) => '$_securePrefix${id.ip}:${id.port}';

  Future<void> _writeApiKey(ServerId id, String apiKey) async {
    final key = _secureKey(id);
    await _secureStorage.write(key: key, value: jsonEncode({'apiKey': apiKey}));
  }

  Future<String?> _readApiKey(ServerId id) async {
    final key = _secureKey(id);
    final val = await _secureStorage.read(key: key);
    if (val == null) return null;
    try {
      final decoded = jsonDecode(val) as Map<String, dynamic>;
      return decoded['apiKey'] as String?;
    } catch (_) {
      return null;
    }
  }

  Future<void> _deleteApiKey(ServerId id) async {
    final key = _secureKey(id);
    await _secureStorage.delete(key: key);
  }
}
