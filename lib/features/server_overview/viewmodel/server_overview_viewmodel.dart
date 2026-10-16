import 'dart:async';

import 'package:flutter/material.dart';
import 'package:omni_for_pyload/domain/repositories/i_server_repository.dart';
import 'package:omni_for_pyload/domain/repositories/i_pyload_api_repository.dart';
import 'package:omni_for_pyload/domain/models/pyload_api_failure.dart';
import 'package:omni_for_pyload/domain/models/server.dart';
import 'package:omni_for_pyload/domain/models/server_id.dart';
import 'package:omni_for_pyload/features/click_n_load/services/click_n_load_controller.dart';

/// Outcome of a single status request
enum _StatusCheck { online, offline, timedOut }

class ServerOverviewViewModel extends ChangeNotifier {
  final IServerRepository _serverRepository;
  final IPyLoadApiRepository _pyLoadApiRepository;
  final ClickNLoadController _clickNLoadController;
  List<Server> _servers = [];

  /// Status per server
  final Map<ServerId, String> _statuses = {};

  /// Servers that currently have a polling loop running
  final Set<ServerId> _pollingServers = {};
  bool _isDisposed = false;
  bool _isPaused = false;
  final _serverStatusPollingInterval = Duration(seconds: 2);

  ServerOverviewViewModel({
    required this._serverRepository,
    required this._pyLoadApiRepository,
    required this._clickNLoadController,
  });

  List<Server> get servers => _servers;
  Map<ServerId, String> get statuses => _statuses;

  bool get _shouldPoll => !_isDisposed && !_isPaused;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  static Server? _findServer(List<Server> servers, ServerId id) =>
      servers.where((server) => server.id == id).firstOrNull;

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
    _statuses.removeWhere((id, _) {
      final currentServer = _findServer(_servers, id);
      final previousServer = _findServer(previousServers, id);
      final wasRemoved = currentServer == null;
      final wasEdited = currentServer != previousServer;
      return wasRemoved || wasEdited;
    });
  }

  void _startPolling() {
    for (final server in _servers) {
      _pollServer(server.id);
    }
  }

  /// Polls the status of the server with [id] until polling is paused or the
  /// server is removed. At most one loop runs per server.
  Future<void> _pollServer(ServerId id) async {
    if (_pollingServers.contains(id)) return;
    _pollingServers.add(id);

    while (_shouldPoll) {
      // Look the server up on every iteration, so edits take effect
      final server = _findServer(_servers, id);
      if (server == null) break;

      final result = await _checkStatus(server);
      if (!_shouldPoll) break;

      // If the server was edited while the request was running, the result
      // belongs to the old settings. Discard it and check again right away.
      final serverWasEdited = _findServer(_servers, id) != server;
      if (serverWasEdited) continue;

      _statuses[id] = result == _StatusCheck.online ? 'online' : 'offline';
      notifyListeners();

      // After a timeout, check again right away
      if (result != _StatusCheck.timedOut) {
        await Future.delayed(_serverStatusPollingInterval);
      }
    }

    _pollingServers.remove(id);
  }

  Future<_StatusCheck> _checkStatus(Server server) async {
    try {
      await _pyLoadApiRepository.getServerStatus(server);
      return _StatusCheck.online;
    } on PyLoadApiTimeout {
      return _StatusCheck.timedOut;
    } on PyLoadApiFailure {
      return _StatusCheck.offline;
    }
  }

  /// Remove [server] from storage and the list, stopping Click'N'Load if it
  /// forwards for it
  Future<void> removeServer(Server server) async {
    await _clickNLoadController.stopFor(server.id);
    await _serverRepository.removeServer(server.id);
    _servers.removeWhere((s) => s.id == server.id);
    _statuses.remove(server.id);
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
