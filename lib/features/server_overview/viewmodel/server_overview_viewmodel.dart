import 'dart:async';

import 'package:flutter/material.dart';
import 'package:omni_for_pyload/domain/repositories/i_server_repository.dart';
import 'package:omni_for_pyload/domain/repositories/i_pyload_api_repository.dart';
import 'package:omni_for_pyload/domain/models/server.dart';

/// Outcome of a single status request
enum _StatusCheck { online, offline, timedOut }

class ServerOverviewViewModel extends ChangeNotifier {
  final IServerRepository _serverRepository;
  final IPyLoadApiRepository _pyLoadApiRepository;
  List<Server> _servers = [];

  /// Status per server, keyed by `ip:port` (see [_serverKey])
  final Map<String, String> _statuses = {};

  /// Keys of the servers that currently have a polling loop running
  final Set<String> _pollingServers = {};
  bool _isDisposed = false;
  bool _isPaused = false;
  final _serverStatusPollingInterval = Duration(seconds: 2);

  ServerOverviewViewModel({
    required this._serverRepository,
    required this._pyLoadApiRepository,
  });

  List<Server> get servers => _servers;
  Map<String, String> get statuses => _statuses;

  bool get _shouldPoll => !_isDisposed && !_isPaused;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  /// Servers are identified by IP and port
  static String _serverKey(Server server) => '${server.ip}:${server.port}';

  static Server? _findServer(List<Server> servers, String key) =>
      servers.where((server) => _serverKey(server) == key).firstOrNull;

  /// Load all servers from storage
  Future<void> loadServers() async {
    final previousServers = _servers;
    _servers = await _serverRepository.getAllServers();
    _removeOutdatedStatuses(previousServers);
    notifyListeners();
    _startPolling();
  }

  /// Removes the status of every server that was removed or edited since
  /// [previousServers] was loaded. An edited server then shows as fetching
  /// until it has been polled with its new settings.
  void _removeOutdatedStatuses(List<Server> previousServers) {
    _statuses.removeWhere((key, _) {
      final currentServer = _findServer(_servers, key);
      final previousServer = _findServer(previousServers, key);
      final wasRemoved = currentServer == null;
      final wasEdited = currentServer != previousServer;
      return wasRemoved || wasEdited;
    });
  }

  void _startPolling() {
    for (final server in _servers) {
      _pollServer(_serverKey(server));
    }
  }

  /// Polls the status of the server with [key] until polling is paused or the
  /// server is removed. At most one loop runs per server.
  Future<void> _pollServer(String key) async {
    if (_pollingServers.contains(key)) return;
    _pollingServers.add(key);

    while (_shouldPoll) {
      // Look the server up on every iteration, so edits take effect
      final server = _findServer(_servers, key);
      if (server == null) break;

      final result = await _checkStatus(server);
      if (!_shouldPoll) break;

      // If the server was edited while the request was running, the result
      // belongs to the old settings. Discard it and check again right away.
      final serverWasEdited = _findServer(_servers, key) != server;
      if (serverWasEdited) continue;

      _statuses[key] = result == _StatusCheck.online ? 'online' : 'offline';
      notifyListeners();

      // After a timeout, check again right away
      if (result != _StatusCheck.timedOut) {
        await Future.delayed(_serverStatusPollingInterval);
      }
    }

    _pollingServers.remove(key);
  }

  Future<_StatusCheck> _checkStatus(Server server) async {
    try {
      await _pyLoadApiRepository.getServerStatus(server);
      return _StatusCheck.online;
    } on TimeoutException {
      return _StatusCheck.timedOut;
    } catch (_) {
      return _StatusCheck.offline;
    }
  }

  /// Remove a server by its IP and port key
  Future<void> removeServer(Server server) async {
    await _serverRepository.removeServer(server.ip, server.port);
    _servers.removeWhere((s) => _serverKey(s) == _serverKey(server));
    _statuses.remove(_serverKey(server));
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
