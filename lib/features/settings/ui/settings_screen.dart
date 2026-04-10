import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:omni_for_pyload/core/service_locator.dart';
import 'package:omni_for_pyload/domain/models/app_settings.dart' as app_models;
import 'package:omni_for_pyload/domain/models/server.dart';
import 'package:omni_for_pyload/domain/repositories/i_settings_repository.dart';
import 'package:omni_for_pyload/domain/repositories/i_server_repository.dart';
import 'package:omni_for_pyload/features/click_n_load/ui/click_n_load_bottom_sheet.dart';
import 'package:omni_for_pyload/features/settings/viewmodel/settings_viewmodel.dart';

class SettingsScreen extends StatefulWidget {
  final Server? server;
  final Future<void> Function()? onClickNLoadConfigChanged;

  const SettingsScreen({
    super.key,
    this.server,
    this.onClickNLoadConfigChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SettingsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = SettingsViewModel(
      settingsRepository: getIt<ISettingsRepository>(),
      serverRepository: widget.server != null
          ? getIt<IServerRepository>()
          : null,
      server: widget.server,
      onClickNLoadConfigChanged: widget.onClickNLoadConfigChanged,
    );
    _viewModel.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // App Settings Section
          _buildSectionTitle('App settings'),
          const SizedBox(height: 12),
          _buildThemeOption(),
          const SizedBox(height: 16),
          _buildSkipSelectionOption(),
          const SizedBox(height: 32),

          // Server Settings Section (only show when opened from ServerScreen on Android)
          if (_viewModel.hasServerContext && Platform.isAndroid) ...[
            _buildSectionTitle('Server settings'),
            const SizedBox(height: 12),
            _buildClickNLoadOption(),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildThemeOption() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            SegmentedButton<app_models.ThemeMode>(
              segments: const [
                ButtonSegment<app_models.ThemeMode>(
                  value: app_models.ThemeMode.light,
                  label: Text('Light'),
                  icon: Icon(Icons.light_mode),
                ),
                ButtonSegment<app_models.ThemeMode>(
                  value: app_models.ThemeMode.dark,
                  label: Text('Dark'),
                  icon: Icon(Icons.dark_mode),
                ),
                ButtonSegment<app_models.ThemeMode>(
                  value: app_models.ThemeMode.system,
                  label: Text('Follow System'),
                  icon: Icon(Icons.brightness_auto),
                ),
              ],
              selected: {_viewModel.themeMode},
              onSelectionChanged: (Set<app_models.ThemeMode> newSelection) {
                _viewModel.setThemeMode(newSelection.first);
              },
              showSelectedIcon: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkipSelectionOption() {
    return Card(
      child: ListTile(
        title: const Text(
          'Skip selection screen if only one server is configured',
        ),
        trailing: Switch(
          value: _viewModel.skipSelectionScreenIfOnlyOneServer,
          onChanged: (bool value) {
            _viewModel.setSkipSelectionScreenIfOnlyOneServer(value);
          },
        ),
      ),
    );
  }

  Widget _buildClickNLoadOption() {
    final server = _viewModel.server;
    if (server == null) return const SizedBox.shrink();

    final hasClickNLoad = server.hasClickNLoad;
    final clickNLoadServer = server.clickNLoadServer;

    return Card(
      child: ListTile(
        leading: const Icon(Icons.link),
        title: const Text("Click'N'Load"),
        subtitle: hasClickNLoad && clickNLoadServer != null
            ? Text(
                '${clickNLoadServer.protocol}://${clickNLoadServer.ip}:${clickNLoadServer.port}',
                style: Theme.of(context).textTheme.bodySmall,
              )
            : const Text(
                'Not configured',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
        trailing: hasClickNLoad
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: _showEditClickNLoadBottomSheet,
                    tooltip: 'Edit',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: _confirmRemoveClickNLoad,
                    tooltip: 'Remove',
                  ),
                ],
              )
            : IconButton(
                icon: const Icon(Icons.add),
                onPressed: _showAddClickNLoadBottomSheet,
                tooltip: 'Add',
              ),
      ),
    );
  }

  void _showAddClickNLoadBottomSheet() {
    final server = _viewModel.server;
    if (server == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ClickNLoadBottomSheet.add(
        defaultIp: server.ip,
        onSave: (ip, port, protocol, allowInsecureConnections) async {
          await _viewModel.updateClickNLoadConfig(
            ip,
            port,
            protocol,
            allowInsecureConnections,
          );
          return true;
        },
      ),
    );
  }

  void _showEditClickNLoadBottomSheet() {
    final server = _viewModel.server;
    final clickNLoadServer = server?.clickNLoadServer;
    if (server == null || clickNLoadServer == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ClickNLoadBottomSheet.edit(
        currentIp: clickNLoadServer.ip,
        currentPort: clickNLoadServer.port,
        currentProtocol: clickNLoadServer.protocol,
        currentAllowInsecure: clickNLoadServer.allowInsecureConnections,
        onSave: (ip, port, protocol, allowInsecureConnections) async {
          await _viewModel.updateClickNLoadConfig(
            ip,
            port,
            protocol,
            allowInsecureConnections,
          );
          return true;
        },
      ),
    );
  }

  Future<void> _confirmRemoveClickNLoad() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Remove Click'N'Load?"),
        content: const Text(
          "This will remove the Click'N'Load configuration for this server. "
          "You can add it again later.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _viewModel.removeClickNLoadConfig();
    }
  }
}
