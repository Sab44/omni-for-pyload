import 'package:flutter/material.dart';
import 'package:omni_for_pyload/core/service_locator.dart';
import 'package:omni_for_pyload/domain/models/server.dart';
import 'package:omni_for_pyload/domain/repositories/i_local_network_repository.dart';
import 'package:omni_for_pyload/domain/repositories/i_pyload_api_repository.dart';
import 'package:omni_for_pyload/domain/repositories/i_server_repository.dart';
import 'package:omni_for_pyload/features/add_server/viewmodel/add_server_viewmodel.dart';
import 'package:omni_for_pyload/features/error_dialog/ui/error_dialog.dart';

/// Form to add a new server, or to edit [server] if given
class AddServerScreen extends StatefulWidget {
  final Server? server;

  const AddServerScreen({super.key, this.server});

  @override
  State<AddServerScreen> createState() => _AddServerScreenState();
}

class _AddServerScreenState extends State<AddServerScreen> {
  final TextEditingController _nameController = TextEditingController(
    text: 'pyLoad',
  );
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _portController = TextEditingController(
    text: '8000',
  );
  final TextEditingController _apiKeyController = TextEditingController();
  late AddServerViewModel _viewModel;
  bool _isHttp = true;
  bool _allowInsecureConnections = false;
  bool _isLoading = false;

  bool get _isEditing => widget.server != null;

  @override
  void initState() {
    super.initState();
    _viewModel = AddServerViewModel(
      serverRepository: getIt<IServerRepository>(),
      pyLoadApiRepository: getIt<IPyLoadApiRepository>(),
      localNetworkRepository: getIt<ILocalNetworkRepository>(),
    );

    final server = widget.server;
    if (server != null) {
      _nameController.text = server.name;
      _ipController.text = server.ip;
      _portController.text = server.port.toString();
      _apiKeyController.text = server.apiKey;
      _isHttp = server.protocol == 'http';
      _allowInsecureConnections = server.allowInsecure;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ipController.dispose();
    _portController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleSubmit() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final original = widget.server;
      if (original != null) {
        await _viewModel.validateAndUpdateServer(
          original: original,
          name: _nameController.text.trim(),
          ip: _ipController.text.trim(),
          port: _portController.text.trim(),
          apiKey: _apiKeyController.text.trim(),
          protocol: _isHttp ? "http" : "https",
          allowInsecureConnections: _allowInsecureConnections,
        );
      } else {
        await _viewModel.validateAndAddServer(
          name: _nameController.text.trim(),
          ip: _ipController.text.trim(),
          port: _portController.text.trim(),
          apiKey: _apiKeyController.text.trim(),
          protocol: _isHttp ? "http" : "https",
          allowInsecureConnections: _allowInsecureConnections,
        );
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        if (e is LocalNetworkAccessDeniedException) {
          showErrorDialog(
            context,
            e.toString(),
            actionLabel: 'Open Settings',
            onAction: _viewModel.openAppSettings,
          );
        } else {
          _showErrorDialog(e.toString());
        }
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(_isEditing ? 'Edit server' : 'Add new server'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Server Name
                TextFormField(
                  controller: _nameController,
                  enabled: !_isLoading,
                  decoration: const InputDecoration(labelText: 'Server name'),
                ),
                const SizedBox(height: 12),
                // IP / Hostname
                TextFormField(
                  controller: _ipController,
                  enabled: !_isLoading,
                  decoration: const InputDecoration(labelText: 'IP / Hostname'),
                ),
                const SizedBox(height: 12),
                // Port
                TextFormField(
                  controller: _portController,
                  enabled: !_isLoading,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Port'),
                ),
                const SizedBox(height: 12),
                // Protocol toggle
                Padding(
                  padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Protocol',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 16),
                      ToggleButtons(
                        isSelected: [_isHttp, !_isHttp],
                        onPressed: _isLoading
                            ? null
                            : (index) {
                                setState(() {
                                  _isHttp = index == 0;
                                });
                              },
                        borderRadius: BorderRadius.circular(8),
                        constraints: const BoxConstraints(
                          minHeight: 36,
                          minWidth: 72,
                        ),
                        children: const [Text('http'), Text('https')],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                // Insecure connections checkbox (only visible for https)
                if (!_isHttp) ...[
                  CheckboxListTile(
                    value: _allowInsecureConnections,
                    onChanged: _isLoading
                        ? null
                        : (value) {
                            setState(() {
                              _allowInsecureConnections = value ?? false;
                            });
                          },
                    title: const Text('Disable SSL certificate verification'),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                  if (_allowInsecureConnections)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.orange.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Warning: potentially dangerous',
                          style: TextStyle(
                            color: Colors.orange.shade700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 12),
                ],
                // API Key
                TextFormField(
                  controller: _apiKeyController,
                  enabled: !_isLoading,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'API Key',
                    helperText: 'Generate the API Key in your pyLoad instance\'s settings page.',
                  ),
                ),
                const SizedBox(height: 16),
                // Submit button
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _isLoading ? null : _handleSubmit,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  _isEditing ? 'Save changes' : 'Add server',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary,
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
        ),
      ),
    );
  }
}
