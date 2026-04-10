import 'dart:async';

import 'package:flutter/material.dart';
import 'package:openapi_client/api.dart';
import 'package:omni_for_pyload/data/repositories/click_n_load_repository.dart';
import 'package:omni_for_pyload/domain/models/server.dart';
import 'package:omni_for_pyload/domain/repositories/i_pyload_api_repository.dart';
import 'package:omni_for_pyload/domain/repositories/i_server_repository.dart';
import 'package:omni_for_pyload/features/server/services/click_n_load_service.dart';

/// Result of attempting to start Click'n'Load service
enum ClickNLoadStartResult { started, alreadyRunning, failed, notConfigured }

class ServerViewModel extends ChangeNotifier {
  final IPyLoadApiRepository _pyLoadApiRepository;
  final IServerRepository _serverRepository;
  Server _server;
  ClickNLoadService? _clickNLoadService;
  int _selectedTabIndex = 0;
  List<DownloadInfo> _downloads = [];
  List<PackageData> _queueData = [];
  List<PackageData> _collectorData = [];
  final Set<int> _selectedPackageIds = {};
  String? _error;
  Timer? _pollTimer;
  Timer? _serverStatusTimer;
  ServerStatus? _serverStatus;
  bool _isDisposed = false;
  bool _isPaused = false;

  ServerViewModel({
    required Server server,
    required IPyLoadApiRepository pyLoadApiRepository,
    required IServerRepository serverRepository,
  }) : _server = server,
       _pyLoadApiRepository = pyLoadApiRepository,
       _serverRepository = serverRepository {
    _startPollingServerStatus();
  }

  Server get server => _server;
  bool get hasClickNLoadConfigured => _server.hasClickNLoad;
  int get selectedTabIndex => _selectedTabIndex;
  List<DownloadInfo> get downloads => _downloads;
  List<PackageData> get queueData => _queueData;
  List<PackageData> get collectorData => _collectorData;
  Set<int> get selectedPackageIds => _selectedPackageIds;
  bool get isSelectionMode => _selectedPackageIds.isNotEmpty;
  String? get error => _error;
  ServerStatus? get serverStatus => _serverStatus;

  void setSelectedTab(int index) {
    if (_isDisposed) return;
    if (_selectedTabIndex != index) {
      clearSelection();
    }
    _selectedTabIndex = index;
    if (index == 0) {
      // Start polling when Overview tab is selected
      _startPollingDownloads();
    } else if (index == 1) {
      // Start polling when Queue tab is selected
      _startPollingQueue();
    } else if (index == 2) {
      // Start polling when Collector tab is selected
      _startPollingCollector();
    } else {
      // Stop polling when another tab is selected
      _stopPolling();
    }
    notifyListeners();
  }

  /// Fetch the current download status from the server
  Future<void> _fetchDownloadStatus() async {
    try {
      _downloads = await _pyLoadApiRepository.getDownloadStatus(server);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      notifyListeners();
    }
  }

  /// Fetch the queue data from the server
  Future<void> _fetchQueueData() async {
    try {
      List<PackageData> queue = await _pyLoadApiRepository.getQueue(server);
      _queueData = queue.reversed.toList();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      notifyListeners();
    }
  }

  /// Fetch the collector data from the server
  Future<void> _fetchCollectorData() async {
    try {
      List<PackageData> collector = await _pyLoadApiRepository.getCollector(
        server,
      );
      _collectorData = collector.reversed.toList();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      notifyListeners();
    }
  }

  /// Start polling server status
  void _startPollingServerStatus() {
    if (_isPaused) return;

    // Fetch immediately
    _fetchServerStatus();

    // Then poll
    _serverStatusTimer = Timer.periodic(
      const Duration(seconds: 2),
      (_) => _fetchServerStatus(),
    );
  }

  /// Fetch the server status
  Future<void> _fetchServerStatus() async {
    try {
      _serverStatus = await _pyLoadApiRepository.getServerStatus(server);
      notifyListeners();
    } catch (e) {
      // Ignore errors during polling
    }
  }

  /// Start polling downloads
  void _startPollingDownloads() {
    if (_isPaused) return;

    // Stop any existing timer
    _stopPolling();

    // Fetch immediately
    _fetchDownloadStatus();

    // Then poll
    _pollTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _fetchDownloadStatus(),
    );
  }

  /// Start polling queue data
  void _startPollingQueue() {
    if (_isPaused) return;

    // Stop any existing timer
    _stopPolling();

    // Fetch immediately
    _fetchQueueData();

    // Then poll
    _pollTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _fetchQueueData(),
    );
  }

  /// Start polling collector data
  void _startPollingCollector() {
    if (_isPaused) return;

    // Stop any existing timer
    _stopPolling();

    // Fetch immediately
    _fetchCollectorData();

    // Then poll
    _pollTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _fetchCollectorData(),
    );
  }

  /// Stop polling downloads / queue / collector
  void _stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

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
      // Refresh the current tab
      setSelectedTab(_selectedTabIndex);
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
      // Refresh the current tab
      setSelectedTab(_selectedTabIndex);
      return result;
    } catch (e) {
      return Result.failure;
    }
  }

  Future<Result> moveSelectedPackages() async {
    Destination? destination;
    if (_selectedTabIndex == 1) {
      destination = Destination.COLLECTOR;
    } else if (_selectedTabIndex == 2) {
      destination = Destination.QUEUE;
    }

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
      // Refresh the current tab
      setSelectedTab(_selectedTabIndex);
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
      // Refresh the current tab - maybe not strictly necessary here
      setSelectedTab(_selectedTabIndex);
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
      _serverStatusTimer?.cancel();
      _startPollingServerStatus();
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
      _serverStatusTimer?.cancel();
      _startPollingServerStatus();
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
      setSelectedTab(_selectedTabIndex);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> restartFailed() async {
    try {
      await _pyLoadApiRepository.restartFailed(server);
      setSelectedTab(_selectedTabIndex);
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
  /// Returns true if configuration was saved successfully, false otherwise
  Future<bool> configureClickNLoad({
    required String ip,
    required int port,
    required String protocol,
    required bool allowInsecureConnections,
  }) async {
    try {
      // Update the server object with Click'N'Load configuration
      _server.configureClickNLoad(
        ip: ip,
        port: port,
        protocol: protocol,
        allowInsecureConnections: allowInsecureConnections,
      );

      // Persist the updated server
      await _serverRepository.updateServer(_server);

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Start the Click'n'Load service
  /// Returns the result indicating if it was started, already running, not configured, or failed
  Future<ClickNLoadStartResult> startClickNLoad() async {
    // (Re-)Initialize the Click'N'Load service in case server config was updated
    await _initializeClickNLoadService();

    if (_clickNLoadService == null) {
      return ClickNLoadStartResult.notConfigured;
    }

    if (await _clickNLoadService!.isRunning()) {
      return ClickNLoadStartResult.alreadyRunning;
    }

    final success = await _clickNLoadService!.start();
    return success
        ? ClickNLoadStartResult.started
        : ClickNLoadStartResult.failed;
  }

  /// Initialize the Click'N'Load service if configured
  Future<void> _initializeClickNLoadService() async {
    _server = (await _serverRepository.getAllServers()).firstWhere(
      (server) => server.ip == _server.ip && server.port == _server.port,
    );
    final clickNLoadServer = _server.clickNLoadServer;
    if (clickNLoadServer != null) {
      print(
        'Initializing ClickNLoad service with remote url ${clickNLoadServer.baseUrl}',
      );
      _clickNLoadService = ClickNLoadService(
        repository: ClickNLoadRepository(clickNLoadServer),
      );
    }
  }

  /// Stop the Click'n'Load service if it's running
  Future<void> stopClickNLoad() async {
    if (_clickNLoadService == null) return;

    if (await _clickNLoadService!.isRunning()) {
      await _clickNLoadService!.stop();
    }
  }

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

      // Refresh the appropriate tab based on destination
      if (destination == Destination.QUEUE && _selectedTabIndex == 1) {
        _fetchQueueData();
      } else if (destination == Destination.COLLECTOR &&
          _selectedTabIndex == 2) {
        _fetchCollectorData();
      }
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

      // Refresh the appropriate tab based on destination
      if (destination == Destination.QUEUE && _selectedTabIndex == 1) {
        _fetchQueueData();
      } else if (destination == Destination.COLLECTOR &&
          _selectedTabIndex == 2) {
        _fetchCollectorData();
      }

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

  /// Pause all polling (server status + current tab)
  void pausePolling() {
    _isPaused = true;
    _stopPolling();
    _serverStatusTimer?.cancel();
  }

  /// Resume polling for server status and the currently active tab
  void resumePolling() {
    if (!_isPaused) return;
    _isPaused = false;

    // Resume server status polling
    _startPollingServerStatus();

    // Resume polling for the currently active tab
    if (_selectedTabIndex == 0) {
      _startPollingDownloads();
    } else if (_selectedTabIndex == 1) {
      _startPollingQueue();
    } else if (_selectedTabIndex == 2) {
      _startPollingCollector();
    }
  }

  @override
  void dispose() {
    // Fire-and-forget, stop clickNLoad async from sync context
    stopClickNLoad();
    _isDisposed = true;
    _stopPolling();
    _serverStatusTimer?.cancel();
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }
}
