import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:omni_for_pyload/domain/models/server.dart';
import 'package:omni_for_pyload/domain/repositories/i_server_repository.dart';

class ServerRepository implements IServerRepository {
  static const String _boxName = 'servers';
  static const String _securePrefix = 'server_credentials:';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  Future<void> initialize() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ServerAdapter());
    }
  }

  Future<Box<Server>> _getBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<Server>(_boxName);
    }
    return await Hive.openBox<Server>(_boxName);
  }

  /// Get all servers from local storage
  @override
  Future<List<Server>> getAllServers() async {
    final box = await _getBox();
    final servers = box.values.toList();

    // Reattach API key from secure storage
    for (var i = 0; i < servers.length; i++) {
      final server = servers[i];
      final apiKey = await _readApiKey(server.ip, server.port);
      if (apiKey != null) {
        servers[i] = server.copyWith(apiKey: apiKey);
      }
    }

    return servers;
  }

  /// Add a new server
  @override
  Future<void> addServer(Server server) async {
    final box = await _getBox();
    final key = '${server.ip}:${server.port}';
    // Store API key in secure storage and write server without API key to Hive
    await _writeApiKey(server.ip, server.port, server.apiKey);
    final safeServer = server.copyWith(apiKey: '');
    await box.put(key, safeServer);
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
    final box = await _getBox();
    final key = '$ip:$port';
    // Remove API key stored for this server
    try {
      await _deleteApiKey(ip, port);
    } catch (_) {}

    await box.delete(key);
  }

  /// Update an existing server
  @override
  Future<void> updateServer(Server server) async {
    final box = await _getBox();
    final key = '${server.ip}:${server.port}';
    // Update API key in secure storage and update Hive with safe server
    await _writeApiKey(server.ip, server.port, server.apiKey);
    final safeServer = server.copyWith(apiKey: '');
    await box.put(key, safeServer);
  }

  /// Clear all servers
  @override
  Future<void> clearAllServers() async {
    final box = await _getBox();
    // Delete API keys for all stored servers
    for (final server in box.values) {
      await _deleteApiKey(server.ip, server.port);
    }
    await box.clear();
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
