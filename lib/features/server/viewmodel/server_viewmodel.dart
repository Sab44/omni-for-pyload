import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:openapi_client/api.dart';
import 'package:omni_for_pyload/core/polling/poller.dart';
import 'package:omni_for_pyload/domain/models/clicknload_server.dart';
import 'package:omni_for_pyload/domain/models/pyload_api_failure.dart';
import 'package:omni_for_pyload/domain/models/server.dart';
import 'package:omni_for_pyload/domain/repositories/i_pyload_api_repository.dart';
import 'package:omni_for_pyload/domain/repositories/i_server_repository.dart';
import 'package:omni_for_pyload/features/click_n_load/services/click_n_load_controller.dart';
import 'package:omni_for_pyload/features/server/viewmodel/server_tab.dart';

class ServerViewModel extends ChangeNotifier {
  static final _log = Logger('ServerViewModel');

  final IPyLoadApiRepository _pyLoadApiRepository;
  final IServerRepository _serverRepository;
  final ClickNLoadController _clickNLoadController;
  Server _server;
  ServerTab _selectedTab = ServerTab.overview;
  List<DownloadInfo> _downloads = [];
  List<PackageData> _queueData = [];
  List<PackageData> _collectorData = [];
  final Set<int> _selectedPackageIds = {};
  String? _error;
  ServerStatus? _serverStatus;
  bool _isDisposed = false;

  late final _statusPoller = Poller<ServerStatus>(
    interval: const Duration(seconds: 2),
    fetch: () => _pyLoadApiRepository.getServerStatus(_server),
    onData: (status) {
      _serverStatus = status;
      notifyListeners();
    },
    onError: (error, stackTrace) {
      // Failures are ignored, the status row keeps the last known status
      if (error is! PyLoadApiFailure) {
        _log.severe('Unexpected error while polling', error, stackTrace);
      }
    },
  );

  /// Only the poller of the selected tab is started
  late final Map<ServerTab, Poller<Object?>> _tabPollers = {
    for (final tab in ServerTab.values) tab: _createTabPoller(tab),
  };

  ServerViewModel({
    required this._server,
    required this._pyLoadApiRepository,
    required this._serverRepository,
    required this._clickNLoadController,
  }) {
    _clickNLoadController.addListener(notifyListeners);
    _statusPoller.start();
    _tabPollers[_selectedTab]!.start();
  }

  Server get server => _server;
  bool get hasClickNLoadConfigured => _server.hasClickNLoad;
  bool get isClickNLoadSupported => _clickNLoadController.isSupported;

  /// Whether Click'N'Load currently forwards requests for this server
  bool get isClickNLoadRunning =>
      _clickNLoadController.isRunningFor(_server.id);
  ServerTab get selectedTab => _selectedTab;
  List<DownloadInfo> get downloads => _downloads;
  List<PackageData> get queueData => _queueData;
  List<PackageData> get collectorData => _collectorData;
  Set<int> get selectedPackageIds => _selectedPackageIds;
  bool get isSelectionMode => _selectedPackageIds.isNotEmpty;
  String? get error => _error;
  ServerStatus? get serverStatus => _serverStatus;

  /// Re-read the server from the repository, e.g. after its settings were
  /// changed on another screen. Keeps the current server if it was removed.
  Future<void> reloadServer() async {
    final stored = await _serverRepository.getServer(_server.id);
    if (stored == null || stored == _server) return;
    _server = stored;
    notifyListeners();
  }

  void setSelectedTab(ServerTab tab) {
    if (_isDisposed) return;
    if (tab == _selectedTab) {
      _tabPollers[tab]!.refresh();
      return;
    }
    clearSelection();
    _tabPollers[_selectedTab]!.stop();
    _selectedTab = tab;
    _tabPollers[tab]!.start();
    notifyListeners();
  }

  Poller<Object?> _createTabPoller(ServerTab tab) => switch (tab) {
    ServerTab.overview => _tabPoller<List<DownloadInfo>>(
      interval: const Duration(seconds: 1),
      fetch: () => _pyLoadApiRepository.getDownloadStatus(_server),
      show: (downloads) => _downloads = downloads,
    ),
    ServerTab.queue => _tabPoller<List<PackageData>>(
      interval: const Duration(seconds: 10),
      fetch: () => _pyLoadApiRepository.getQueue(_server),
      show: (queue) => _queueData = queue.reversed.toList(),
    ),
    ServerTab.collector => _tabPoller<List<PackageData>>(
      interval: const Duration(seconds: 10),
      fetch: () => _pyLoadApiRepository.getCollector(_server),
      show: (collector) => _collectorData = collector.reversed.toList(),
    ),
  };

  Poller<T> _tabPoller<T>({
    required Duration interval,
    required Future<T> Function() fetch,
    required void Function(T data) show,
  }) => Poller<T>(
    interval: interval,
    fetch: fetch,
    onData: (data) {
      show(data);
      _error = null;
      notifyListeners();
    },
    onError: (error, stackTrace) {
      if (error is! PyLoadApiFailure) {
        _log.severe('Unexpected error while polling', error, stackTrace);
        return;
      }
      _error = error.message;
      notifyListeners();
    },
  );

  /// Fetch the tab listing the packages of [destination] if it is shown
  void _refreshTabOf(Destination destination) =>
      _tabPollers[ServerTab.forDestination(destination)]!.refresh();

  void _refreshSelectedTab() => _tabPollers[_selectedTab]!.refresh();

  void toggleSelection(int packageId) {
    if (_selectedPackageIds.contains(packageId)) {
      _selectedPackageIds.remove(packageId);
    } else {
      _selectedPackageIds.add(packageId);
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedPackageIds.clear();
    notifyListeners();
  }

  Future<bool> deleteSelectedPackages() async {
    try {
      List<int> deletePids = _selectedPackageIds.toList();
      clearSelection();

      await _pyLoadApiRepository.deletePackages(server, deletePids);
      _refreshSelectedTab();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Result> restartSelectedPackages() async {
    try {
      List<int> restartPids = _selectedPackageIds.toList();
      clearSelection();

      final result = await _pyLoadApiRepository.restartPackages(
        server,
        restartPids.toList(),
      );
      _refreshSelectedTab();
      return result;
    } catch (e) {
      return Result.failure;
    }
  }

  Future<Result> moveSelectedPackages() async {
    final destination = _selectedTab.moveTarget?.destination;
    if (destination == null) {
      return Result.failure;
    }

    try {
      List<int> movePids = _selectedPackageIds.toList();
      clearSelection();

      final result = await _pyLoadApiRepository.movePackages(
        server,
        movePids,
        destination,
      );
      _refreshSelectedTab();
      return result;
    } catch (e) {
      return Result.failure;
    }
  }

  Future<bool> extractSelectedPackages() async {
    try {
      List<int> extractPids = _selectedPackageIds.toList();
      clearSelection();

      await _pyLoadApiRepository.extractPackages(server, extractPids);
      _refreshSelectedTab();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> resumeQueue() async {
    try {
      if (_serverStatus?.pause == false) {
        return true;
      }

      await _pyLoadApiRepository.unpauseServer(server);
      // Update server status immediately and continue polling
      _statusPoller.refresh();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> pauseQueue() async {
    try {
      if (_serverStatus?.pause == true) {
        return true;
      }

      await _pyLoadApiRepository.pauseServer(server);
      // Update server status immediately and continue polling
      _statusPoller.refresh();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> stopQueue() async {
    try {
      await _pyLoadApiRepository.stopAllDownloads(server);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> clearFinished() async {
    try {
      await _pyLoadApiRepository.deleteFinished(server);
      _refreshSelectedTab();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> restartFailed() async {
    try {
      await _pyLoadApiRepository.restartFailed(server);
      _refreshSelectedTab();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Configure Click'N'Load for the current server and persist the configuration
  ///
  /// Parameters:
  /// - [ip]: The IP address or hostname of the Click'N'Load server
  /// - [port]: The port number
  /// - [protocol]: The protocol (http or https)
  /// - [allowInsecureConnections]: Whether to allow insecure HTTPS connections
  ///
  /// If Click'N'Load is running for this server, it is restarted against
  /// the new target.
  ///
  /// Returns true if configuration was saved successfully, false otherwise
  Future<bool> configureClickNLoad({
    required String ip,
    required int port,
    required String protocol,
    required bool allowInsecureConnections,
  }) async {
    try {
      final updated = await _clickNLoadController.reconfigure(
        _server.id,
        ClickNLoadServer(
          ip: ip,
          port: port,
          protocol: protocol,
          allowInsecureConnections: allowInsecureConnections,
        ),
      );
      if (updated == null) return false;
      _server = updated;

      notifyListeners();
      return true;
    } catch (e, stackTrace) {
      _log.warning(
        'Could not save Click\'N\'Load configuration',
        e,
        stackTrace,
      );
      return false;
    }
  }

  /// Start Click'N'Load for the latest stored configuration of this server
  Future<ClickNLoadStartResult> startClickNLoad() async {
    await reloadServer();
    return _clickNLoadController.start(_server.id);
  }

  /// Stop Click'N'Load if it's running for this server
  Future<void> stopClickNLoad() => _clickNLoadController.stopFor(_server.id);

  /// Upload a DLC container file to the server
  ///
  /// Parameters:
  /// - [fileName]: The name of the file (with .dlc extension)
  /// - [fileBytes]: The file content as bytes
  ///
  /// Returns true if upload was successful, false otherwise
  Future<bool> uploadDlc(
    String fileName,
    List<int> fileBytes,
    Destination destination,
  ) async {
    try {
      await _pyLoadApiRepository.uploadContainer(
        server,
        fileName,
        fileBytes,
        destination,
      );

      // Wait for pyLoad to process the DLC
      await Future.delayed(const Duration(seconds: 1));

      _refreshTabOf(destination);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Add a new package with links to the server
  ///
  /// Parameters:
  /// - [name]: The name of the new package
  /// - [links]: List of URLs to add to the package
  /// - [destination]: Where to add the package (Queue or Collector)
  ///
  /// Returns true if the package was added successfully, false otherwise
  Future<bool> addPackageWithLinks(
    String name,
    List<String> links,
    String password,
    Destination destination,
  ) async {
    try {
      int packageId = await _pyLoadApiRepository.addPackage(
        server,
        name,
        links,
        destination,
      );

      _refreshTabOf(destination);

      if (password.isNotEmpty) {
        // Set password for the newly added package
        await _pyLoadApiRepository.setPackagePassword(
          server,
          packageId,
          password,
        );
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Iterable<Poller<Object?>> get _pollers => [
    _statusPoller,
    ..._tabPollers.values,
  ];

  /// Pause all polling, e.g. while the screen is not visible
  void pausePolling() {
    for (final poller in _pollers) {
      poller.pause();
    }
  }

  /// Resume polling the server status and the selected tab
  void resumePolling() {
    for (final poller in _pollers) {
      poller.resume();
    }
  }

  @override
  void dispose() {
    // Fire-and-forget, stop clickNLoad async from sync context
    stopClickNLoad();
    _clickNLoadController.removeListener(notifyListeners);
    _isDisposed = true;
    for (final poller in _pollers) {
      poller.dispose();
    }
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }
}
