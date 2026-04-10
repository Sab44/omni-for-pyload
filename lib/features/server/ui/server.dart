import 'dart:io';
import 'package:flutter/material.dart';
import 'package:omni_for_pyload/core/service_locator.dart';
import 'package:omni_for_pyload/core/utils/format_utils.dart';
import 'package:omni_for_pyload/domain/models/server.dart';
import 'package:omni_for_pyload/domain/repositories/i_pyload_api_repository.dart';
import 'package:omni_for_pyload/domain/repositories/i_server_repository.dart';
import 'package:omni_for_pyload/features/app.dart';
import 'package:omni_for_pyload/features/click_n_load/ui/click_n_load_bottom_sheet.dart';
import 'package:omni_for_pyload/features/server/ui/add_links_bottom_sheet.dart';
import 'package:omni_for_pyload/features/server/ui/overview_tab.dart';
import 'package:omni_for_pyload/features/server/ui/package_list_tab.dart';
import 'package:omni_for_pyload/features/server/ui/upload_dlc_bottom_sheet.dart';
import 'package:omni_for_pyload/features/server/viewmodel/server_viewmodel.dart';
import 'package:permission_handler/permission_handler.dart';

class ServerScreen extends StatefulWidget {
  final Server server;

  const ServerScreen({required this.server, super.key});

  @override
  State<ServerScreen> createState() => _ServerScreenState();
}

class _ServerScreenState extends State<ServerScreen>
    with WidgetsBindingObserver, RouteAware {
  static const String _menuResumeQueue = 'Resume Queue';
  static const String _menuPauseQueue = 'Pause Queue';
  static const String _menuStopQueue = 'Stop Queue';
  static const String _menuClearFinished = 'Clear Finished';
  static const String _menuRestartFailed = 'Restart Failed';
  static const String _menuSettings = 'Settings';

  late ServerViewModel _viewModel;
  bool _isFabExpanded = false;
  bool _isScreenVisible = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _viewModel = ServerViewModel(
      server: widget.server,
      pyLoadApiRepository: getIt<IPyLoadApiRepository>(),
      serverRepository: getIt<IServerRepository>(),
    );
    _viewModel.addListener(_onViewModelChanged);
    // Start polling immediately since the first tab (Overview) is selected by default
    _viewModel.setSelectedTab(0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  void _onViewModelChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      // App went to background
      _viewModel.pausePolling();
    } else if (state == AppLifecycleState.resumed) {
      // App came to foreground - only resume if this screen is visible
      if (_isScreenVisible) {
        _viewModel.resumePolling();
      }
    }
  }

  @override
  void didPushNext() {
    // User navigated away from this screen (e.g. to download detail)
    _isScreenVisible = false;
    _viewModel.pausePolling();
  }

  @override
  void didPopNext() {
    // User came back to this screen
    _isScreenVisible = true;
    _viewModel.resumePolling();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showClickNLoadAlreadyRunningDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Click'n'Load"),
        content: const Text("Click'n'Load service is already running."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _viewModel.isSelectionMode
          ? _buildSelectionAppBar()
          : _buildDefaultAppBar(),
      body: Column(
        children: [
          _buildServerStatusRow(),
          Expanded(
            child: Stack(
              children: [
                _buildTabContent(),
                if (_isFabExpanded)
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () => setState(() => _isFabExpanded = false),
                      child: Container(color: Colors.black26),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_isFabExpanded) ...[
            IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (Platform.isAndroid)
                    FloatingActionButton.extended(
                      heroTag: 'clicknload',
                      onPressed: () async {
                        // Check if Click'N'Load is configured
                        if (!_viewModel.hasClickNLoadConfigured) {
                          setState(() => _isFabExpanded = false);
                          _showAddClickNLoadBottomSheet();
                          return;
                        }

                        await Permission.notification.request();
                        final result = await _viewModel.startClickNLoad();
                        if (mounted) {
                          switch (result) {
                            case ClickNLoadStartResult.started:
                              _showSnackBar('Click\'n\'Load service started');
                              break;
                            case ClickNLoadStartResult.alreadyRunning:
                              _showClickNLoadAlreadyRunningDialog();
                              break;
                            case ClickNLoadStartResult.failed:
                              _showSnackBar(
                                'Failed to start Click\'n\'Load service',
                              );
                              break;
                            case ClickNLoadStartResult.notConfigured:
                              // Should not happen as we check above, but handle it
                              _showAddClickNLoadBottomSheet();
                              break;
                          }
                          setState(() => _isFabExpanded = false);
                        }
                      },
                      label: const Text("Click'n'Load"),
                      icon: const Icon(Icons.touch_app),
                    ),
                  const SizedBox(height: 10),
                  FloatingActionButton.extended(
                    heroTag: 'uploaddlc',
                    onPressed: () {
                      setState(() => _isFabExpanded = false);
                      _showUploadDlcBottomSheet();
                    },
                    label: const Text("Upload DLC"),
                    icon: const Icon(Icons.upload_file),
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton.extended(
                    heroTag: 'addlinks',
                    onPressed: () {
                      setState(() => _isFabExpanded = false);
                      _showAddLinksBottomSheet();
                    },
                    label: const Text("Add links"),
                    icon: const Icon(Icons.add_link),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
          FloatingActionButton(
            heroTag: 'main_fab',
            onPressed: () {
              setState(() {
                _isFabExpanded = !_isFabExpanded;
              });
            },
            child: Icon(_isFabExpanded ? Icons.close : Icons.add),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _viewModel.selectedTabIndex,
        onTap: (index) {
          if (_isFabExpanded) {
            setState(() => _isFabExpanded = false);
          }
          _viewModel.setSelectedTab(index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Overview'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Queue'),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Collector'),
        ],
      ),
    );
  }

  Widget _buildServerStatusRow() {
    final status = _viewModel.serverStatus;
    if (status == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Theme.of(context).appBarTheme.backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                status.pause ? Icons.pause : Icons.play_arrow,
                color: status.pause ? Colors.orange : Colors.green,
              ),
              const SizedBox(width: 8),
              Text(
                status.pause ? "Paused" : "Running",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Text(
            "Speed ${formatBytes(status.speed)}/s",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildDefaultAppBar() {
    return AppBar(
      centerTitle: true,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.server.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${widget.server.protocol}://${widget.server.ip}:${widget.server.port}',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontSize: 12),
          ),
        ],
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) async {
            bool success = false;
            switch (value) {
              case _menuResumeQueue:
                success = await _viewModel.resumeQueue();
                if (mounted) {
                  _showSnackBar(
                    success
                        ? 'Success: Queue resumed'
                        : 'Error: Failed to resume queue',
                  );
                }
                break;
              case _menuPauseQueue:
                success = await _viewModel.pauseQueue();
                if (mounted) {
                  _showSnackBar(
                    success
                        ? 'Success: Queue paused'
                        : 'Error: Failed to pause queue',
                  );
                }
                break;
              case _menuStopQueue:
                success = await _viewModel.stopQueue();
                if (mounted) {
                  _showSnackBar(
                    success
                        ? 'Success: Queue stopped'
                        : 'Error: Failed to stop queue',
                  );
                }
                break;
              case _menuClearFinished:
                success = await _viewModel.clearFinished();
                if (mounted) {
                  _showSnackBar(
                    success
                        ? 'Success: Finished packages cleared'
                        : 'Error: Failed to clear finished packages',
                  );
                }
                break;
              case _menuRestartFailed:
                success = await _viewModel.restartFailed();
                if (mounted) {
                  _showSnackBar(
                    success
                        ? 'Success: Restarted failed packages'
                        : 'Error: Failed to restart failed packages',
                  );
                }
                break;
              case _menuSettings:
                _navigateToSettings();
                break;
            }
          },
          itemBuilder: (BuildContext context) {
            final List<PopupMenuEntry<String>> items = [
              const PopupMenuItem(
                value: _menuResumeQueue,
                child: Row(
                  children: [
                    Icon(Icons.play_arrow, color: Colors.black54),
                    SizedBox(width: 8),
                    Text(_menuResumeQueue),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: _menuPauseQueue,
                child: Row(
                  children: [
                    Icon(Icons.pause, color: Colors.black54),
                    SizedBox(width: 8),
                    Text(_menuPauseQueue),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: _menuStopQueue,
                child: Row(
                  children: [
                    Icon(Icons.stop, color: Colors.black54),
                    SizedBox(width: 8),
                    Text(_menuStopQueue),
                  ],
                ),
              ),
            ];

            if (_viewModel.selectedTabIndex == 1 ||
                _viewModel.selectedTabIndex == 2) {
              items.add(const PopupMenuDivider());
              items.add(
                const PopupMenuItem(
                  value: _menuClearFinished,
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, color: Colors.black54),
                      SizedBox(width: 8),
                      Text(_menuClearFinished),
                    ],
                  ),
                ),
              );
              items.add(
                const PopupMenuItem(
                  value: _menuRestartFailed,
                  child: Row(
                    children: [
                      Icon(Icons.restart_alt, color: Colors.black54),
                      SizedBox(width: 8),
                      Text(_menuRestartFailed),
                    ],
                  ),
                ),
              );
            }

            items.add(const PopupMenuDivider());
            items.add(
              const PopupMenuItem(
                value: _menuSettings,
                child: Row(
                  children: [
                    Icon(Icons.settings, color: Colors.black54),
                    SizedBox(width: 8),
                    Text(_menuSettings),
                  ],
                ),
              ),
            );

            return items;
          },
        ),
      ],
    );
  }

  PreferredSizeWidget _buildSelectionAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => _viewModel.clearSelection(),
      ),
      title: Text('${_viewModel.selectedPackageIds.length}'),
      actions: [
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () async {
            final success = await _viewModel.deleteSelectedPackages();
            if (mounted) {
              _showSnackBar(
                success
                    ? 'Success: Package(s) deleted.'
                    : 'Error: Package deletion failed.',
              );
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.restart_alt),
          onPressed: () async {
            final result = await _viewModel.restartSelectedPackages();
            if (mounted) {
              String message;
              switch (result) {
                case Result.success:
                  message = 'Success: Package(s) restarted.';
                  break;
                case Result.partial:
                  message = 'Error: Some packages failed to restart.';
                  break;
                case Result.failure:
                  message = 'Error: Package(s) failed to restart.';
                  break;
              }
              _showSnackBar(message);
            }
          },
        ),
        PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'Move') {
              final result = await _viewModel.moveSelectedPackages();
              if (mounted) {
                String message;
                switch (result) {
                  case Result.success:
                    message = 'Success: Packages moved';
                    break;
                  case Result.partial:
                    message = 'Some packages failed to move';
                    break;
                  case Result.failure:
                    message = 'Error: Failed to move packages';
                    break;
                }
                _showSnackBar(message);
              }
            }
            if (value == 'Extract') {
              final result = await _viewModel.extractSelectedPackages();
              if (mounted) {
                _showSnackBar(
                  result
                      ? 'Success: Package extraction triggered.'
                      : 'Error: Failed to trigger package extraction.',
                );
              }
            }
          },
          itemBuilder: (BuildContext context) {
            final moveDestination = _viewModel.selectedTabIndex == 1
                ? 'Collector'
                : 'Queue';
            return [
              PopupMenuItem(
                value: 'Move',
                child: Row(
                  children: [
                    const Icon(Icons.drive_file_move, color: Colors.black54),
                    const SizedBox(width: 8),
                    Text('Move to $moveDestination'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'Extract',
                child: Row(
                  children: [
                    Icon(Icons.unarchive, color: Colors.black54),
                    SizedBox(width: 8),
                    Text('Extract'),
                  ],
                ),
              ),
            ];
          },
        ),
      ],
    );
  }

  Widget _buildTabContent() {
    switch (_viewModel.selectedTabIndex) {
      case 0:
        return OverviewTab(
          downloads: _viewModel.downloads,
          error: _viewModel.error,
        );
      case 1:
        return PackageListTab(
          packages: _viewModel.queueData,
          emptyMessage: 'No packages in queue',
          error: _viewModel.error,
          selectedPackageIds: _viewModel.selectedPackageIds,
          isSelectionMode: _viewModel.isSelectionMode,
          server: widget.server,
          onToggleSelection: _viewModel.toggleSelection,
          onPackageTap: (packageId) {
            Navigator.pushNamed(
              context,
              '/download-detail',
              arguments: {'server': widget.server, 'packageId': packageId},
            );
          },
        );
      case 2:
        return PackageListTab(
          packages: _viewModel.collectorData,
          emptyMessage: 'No packages in collector',
          error: _viewModel.error,
          selectedPackageIds: _viewModel.selectedPackageIds,
          isSelectionMode: _viewModel.isSelectionMode,
          server: widget.server,
          onToggleSelection: _viewModel.toggleSelection,
          onPackageTap: (packageId) {
            Navigator.pushNamed(
              context,
              '/download-detail',
              arguments: {'server': widget.server, 'packageId': packageId},
            );
          },
        );
      default:
        return const Center(child: Text('Overview Tab'));
    }
  }

  /// Navigate to settings screen, pass current server
  Future<void> _navigateToSettings() async {
    await Navigator.pushNamed(
          context,
          '/settings',
          arguments: {
            'server': _viewModel.server,
            'onStopClickNLoad': _viewModel.stopClickNLoad,
          },
        )
        as Server?;
  }

  void _showAddClickNLoadBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ClickNLoadBottomSheet.add(
        defaultIp: _viewModel.server.ip,
        onSave: (ip, port, protocol, allowInsecureConnections) async {
          final success = await _viewModel.configureClickNLoad(
            ip: ip,
            port: port,
            protocol: protocol,
            allowInsecureConnections: allowInsecureConnections,
          );

          if (success && mounted) {
            // Start the Click'N'Load service after configuration
            await Permission.notification.request();
            final result = await _viewModel.startClickNLoad();
            if (mounted) {
              switch (result) {
                case ClickNLoadStartResult.started:
                  _showSnackBar('Click\'n\'Load service started');
                  break;
                case ClickNLoadStartResult.alreadyRunning:
                  _showClickNLoadAlreadyRunningDialog();
                  break;
                case ClickNLoadStartResult.failed:
                  _showSnackBar('Failed to start Click\'n\'Load service');
                  break;
                case ClickNLoadStartResult.notConfigured:
                  _showSnackBar('Error: Click\'n\'Load not configured');
                  break;
              }
            }
          } else if (!success && mounted) {
            _showSnackBar('Error: Failed to save Click\'n\'Load configuration');
          }

          return success;
        },
      ),
    );
  }

  void _showUploadDlcBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => UploadDlcBottomSheet(
        onUpload: (fileName, fileBytes, destination) async {
          final success = await _viewModel.uploadDlc(
            fileName,
            fileBytes,
            destination,
          );
          if (mounted) {
            _showSnackBar(
              success ? 'Success: DLC uploaded' : 'Error: Failed to upload DLC',
            );
          }
        },
      ),
    );
  }

  void _showAddLinksBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => AddLinksBottomSheet(
        onAdd: (name, links, password, destination) async {
          final success = await _viewModel.addPackageWithLinks(
            name,
            links,
            password,
            destination,
          );
          if (mounted) {
            _showSnackBar(
              success
                  ? 'Success: Package added'
                  : 'Error: Failed to add package',
            );
          }
          return success;
        },
      ),
    );
  }
}
