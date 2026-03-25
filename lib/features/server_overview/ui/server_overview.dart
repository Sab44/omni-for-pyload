import 'package:flutter/material.dart';
import 'package:omni_for_pyload/core/service_locator.dart';
import 'package:omni_for_pyload/domain/repositories/i_server_repository.dart';
import 'package:omni_for_pyload/domain/repositories/i_pyload_api_repository.dart';
import 'package:omni_for_pyload/features/server_overview/viewmodel/server_overview_viewmodel.dart';
import 'package:omni_for_pyload/domain/models/server.dart';
import 'package:omni_for_pyload/features/app.dart';

class ServerOverviewScreen extends StatefulWidget {
  final Server? initialAutoOpenServer;

  const ServerOverviewScreen({super.key, this.initialAutoOpenServer});

  @override
  State<ServerOverviewScreen> createState() => _ServerOverviewScreenState();
}

class _ServerOverviewScreenState extends State<ServerOverviewScreen>
    with WidgetsBindingObserver, RouteAware {
  late ServerOverviewViewModel _viewModel;
  bool _isScreenVisible = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _viewModel = ServerOverviewViewModel(
      serverRepository: getIt<IServerRepository>(),
      pyLoadApiRepository: getIt<IPyLoadApiRepository>(),
    );
    _viewModel.addListener(_onViewModelChanged);
    _loadServers();

    if (widget.initialAutoOpenServer != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(
          context,
          '/server',
          arguments: widget.initialAutoOpenServer,
        );
      });
    }
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
    // User navigated away from this screen
    _isScreenVisible = false;
    _viewModel.pausePolling();
  }

  @override
  void didPopNext() {
    // User came back to this screen
    _isScreenVisible = true;
    _viewModel.resumePolling();
  }

  Future<void> _loadServers() async {
    await _viewModel.loadServers();
  }

  void _showServerOptions(BuildContext context, Server server) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove server'),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(context, server);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, Server server) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove server?'),
          content: Text(
            'Are you sure you want to remove ${server.ip}:${server.port}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _viewModel.removeServer(server);
              },
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Omni for pyLoad',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  FloatingActionButton(
                    mini: true,
                    onPressed: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                    shape: const CircleBorder(),
                    child: const Icon(Icons.settings),
                  ),
                ],
              ),
            ),
            // Servers Section Title
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 12.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Servers',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            // Scrollable List
            Expanded(
              child: _viewModel.servers.isEmpty
                  ? Center(
                      child: Text(
                        'No servers added yet',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: _viewModel.servers.length,
                      itemBuilder: (context, index) {
                        final server = _viewModel.servers[index];
                        final key = '${server.ip}:${server.port}';
                        final status =
                            _viewModel.statuses[key] ?? 'fetching...';
                        final Color statusColor = _statusColor(status);
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          clipBehavior: Clip.hardEdge,
                          child: ListTile(
                            tileColor: Theme.of(context).cardTheme.color,
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  server.name,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${server.protocol}://${server.ip}:${server.port}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'API Key: ${server.apiKey.toRedacted()}',
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                  ),
                                ),
                                Text(
                                  'Status: $status',
                                  style: TextStyle(color: statusColor),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.more_vert),
                              onPressed: () =>
                                  _showServerOptions(context, server),
                            ),
                            isThreeLine: true,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/server',
                                arguments: server,
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
            // Add New Server Button
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 28.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      '/add-server',
                    );
                    // Reload servers if a new one was added
                    if (result == true) {
                      setState(() {
                        _loadServers();
                      });
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // Icon with rounded border to the left of the text
                      Container(
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.onPrimary,
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.add,
                          size: 20,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Add new server',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'online':
        return Colors.green;
      case 'offline':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

extension APIKeyRedaction on String {
  /// Redacts the api key showing the first 3 and last 4 characters.
  String toRedacted() {
    if (length <= 7) return this;

    final prefix = substring(0, 3);
    final suffix = substring(length - 4);

    return '$prefix•••$suffix';
  }
}
