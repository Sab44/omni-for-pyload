import 'dart:async';

import 'package:flutter/material.dart';
import 'package:omni_for_pyload/domain/repositories/i_server_repository.dart';
import 'package:omni_for_pyload/domain/repositories/i_pyload_api_repository.dart';
import 'package:omni_for_pyload/domain/models/server.dart';

class ServerOverviewViewModel extends ChangeNotifier {
  final IServerRepository _serverRepository;
  final IPyLoadApiRepository _pyLoadApiRepository;
  List<Server> _servers = [];
  final Map<String, String> _statuses = {};
  final Set<String> _pollingServers = {};
  bool _isDisposed = false;
  bool _isPaused = false;
  final _serverStatusPollingInterval = Duration(seconds: 2);

  ServerOverviewViewModel({
    required IServerRepository serverRepository,
    required IPyLoadApiRepository pyLoadApiRepository,
  }) : _serverRepository = serverRepository,
       _pyLoadApiRepository = pyLoadApiRepository;

  List<Server> get servers => _servers;
  Map<String, String> get statuses => _statuses;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  /// Load all servers from storage
  Future<void> loadServers() async {
    _servers = await _serverRepository.getAllServers();
    notifyListeners();
    _startPolling();
  }

  void _startPolling() {
    for (final server in _servers) {
      _pollServer(server);
    }
  }

  Future<void> _pollServer(Server server) async {
    final key = '${server.ip}:${server.port}';
    if (_pollingServers.contains(key)) return;
    _pollingServers.add(key);

    while (!_isDisposed &&
        !_isPaused &&
        _servers.any((s) => s.ip == server.ip && s.port == server.port)) {
      try {
        await _pyLoadApiRepository.getServerStatus(server);

        if (_isDisposed || _isPaused) break;
        _statuses[key] = 'online';
        notifyListeners();

        await Future.delayed(_serverStatusPollingInterval);
      } on TimeoutException {
        if (_isDisposed || _isPaused) break;

        _statuses[key] = 'offline';
        notifyListeners();
        // Poll again immediately
      } catch (e) {
        if (_isDisposed || _isPaused) break;

        _statuses[key] = 'offline';
        notifyListeners();
        await Future.delayed(_serverStatusPollingInterval);
      }
    }
    _pollingServers.remove(key);
  }

  /// Remove a server by its IP and port key
  Future<void> removeServer(Server server) async {
    final key = '${server.ip}:${server.port}';
    await _serverRepository.removeServer(server.ip, server.port);
    _servers.removeWhere((s) => s.ip == server.ip && s.port == server.port);
    _statuses.remove(key);
    notifyListeners();
  }

  /// Pause polling for all servers
  void pausePolling() {
    _isPaused = true;
  }

  /// Resume polling for all servers
  void resumePolling() {
    if (_isPaused) {
      _isPaused = false;
      _startPolling();
    }
  }
}
