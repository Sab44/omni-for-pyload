import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:omni_for_pyload/core/polling/poller.dart';
import 'package:omni_for_pyload/domain/repositories/i_server_repository.dart';
import 'package:omni_for_pyload/domain/repositories/i_pyload_api_repository.dart';
import 'package:omni_for_pyload/domain/models/pyload_api_failure.dart';
import 'package:omni_for_pyload/domain/models/server.dart';
import 'package:omni_for_pyload/domain/models/server_id.dart';
import 'package:omni_for_pyload/features/click_n_load/services/click_n_load_controller.dart';
import 'package:omni_for_pyload/features/server_overview/viewmodel/server_availability.dart';
import 'package:openapi_client/api.dart';

class ServerOverviewViewModel extends ChangeNotifier {
  static final _log = Logger('ServerOverviewViewModel');

  final IServerRepository _serverRepository;
  final IPyLoadApiRepository _pyLoadApiRepository;
  final ClickNLoadController _clickNLoadController;
  List<Server> _servers = [];

  /// Result of the last status check per server
  final Map<ServerId, ServerAvailability> _statuses = {};

  /// Status poller per server, polling the server as it was when created
  final Map<ServerId, Poller<ServerStatus>> _pollers = {};
  bool _isDisposed = false;
  bool _isPaused = false;
  final _serverStatusPollingInterval = const Duration(seconds: 2);

  ServerOverviewViewModel({
    required this._serverRepository,
    required this._pyLoadApiRepository,
    required this._clickNLoadController,
  });

  List<Server> get servers => _servers;

  /// Availability of the server [id]; [ServerAvailability.fetching] until it
  /// has been checked
  ServerAvailability statusOf(ServerId id) =>
      _statuses[id] ?? ServerAvailability.fetching;

  @override
  void dispose() {
    _isDisposed = true;
    for (final poller in _pollers.values) {
      poller.dispose();
    }
    _pollers.clear();
    super.dispose();
  }

  static Server? _findServer(List<Server> servers, ServerId id) =>
      servers.where((server) => server.id == id).firstOrNull;

  /// Load all servers from storage
  Future<void> loadServers() async {
    final previousServers = _servers;
    _servers = await _serverRepository.getAllServers();
    if (_isDisposed) return;
    _updatePollers(previousServers);
    notifyListeners();
  }

  /// Starts polling added and edited servers, stops polling removed ones.
  ///
  /// An edited server loses its status and shows as fetching until it has
  /// been polled with its new settings; results of requests still running
  /// with the old settings are dropped.
  void _updatePollers(List<Server> previousServers) {
    for (final id in _pollers.keys.toList()) {
      final wasRemovedOrEdited =
          _findServer(_servers, id) != _findServer(previousServers, id);
      if (wasRemovedOrEdited) _stopPolling(id);
    }
    for (final server in _servers) {
      if (!_pollers.containsKey(server.id)) _startPolling(server);
    }
  }

  void _startPolling(Server server) {
    final poller = Poller<ServerStatus>(
      interval: _serverStatusPollingInterval,
      fetch: () => _pyLoadApiRepository.getServerStatus(server),
      onData: (_) => _showStatus(server.id, ServerAvailability.online),
      onError: (error, stackTrace) {
        if (error is! PyLoadApiFailure) {
          _log.severe('Unexpected error while polling', error, stackTrace);
        }
        _showStatus(server.id, ServerAvailability.offline);
      },
      // After a timeout, check again right away
      retryNowOn: (error) => error is PyLoadApiTimeout,
    );
    _pollers[server.id] = poller;
    if (_isPaused) poller.pause();
    poller.start();
  }

  void _stopPolling(ServerId id) {
    _pollers.remove(id)?.dispose();
    _statuses.remove(id);
  }

  void _showStatus(ServerId id, ServerAvailability status) {
    _statuses[id] = status;
    notifyListeners();
  }

  /// Remove [server] from storage and the list, stopping Click'N'Load if it
  /// forwards for it
  Future<void> removeServer(Server server) async {
    await _clickNLoadController.stopFor(server.id);
    await _serverRepository.removeServer(server.id);
    _servers.removeWhere((s) => s.id == server.id);
    _stopPolling(server.id);
    notifyListeners();
  }

  /// Pause polling for all servers
  void pausePolling() {
    _isPaused = true;
    for (final poller in _pollers.values) {
      poller.pause();
    }
  }

  /// Resume polling for all servers
  void resumePolling() {
    _isPaused = false;
    for (final poller in _pollers.values) {
      poller.resume();
    }
  }
}
