import 'package:flutter/material.dart';
import 'package:omni_for_pyload/features/click_n_load/viewmodel/click_n_load_bottom_sheet_viewmodel.dart';
import 'package:omni_for_pyload/features/error_dialog/ui/error_dialog.dart';

/// Bottom sheet widget for adding or editing a Click'N'Load server configuration.
class ClickNLoadBottomSheet extends StatefulWidget {
  /// The server IP to pre-fill in the form (used for new configurations)
  final String defaultIp;

  /// Default port for Click'N'Load (used for new configurations)
  final int defaultPort;

  /// Default protocol (used for new configurations)
  final String defaultProtocol;

  /// Default value for allowing insecure connections (used for new configurations)
  final bool defaultAllowInsecure;

  /// Whether we are editing an existing configuration
  final bool isEditMode;

  /// Callback when the user saves a Click'N'Load server configuration
  /// Parameters: ip, port, protocol, allowInsecureConnections
  /// Returns true if the configuration was saved successfully
  final Future<bool> Function(
    String ip,
    int port,
    String protocol,
    bool allowInsecureConnections,
  )
  onSave;

  const ClickNLoadBottomSheet({
    required this.defaultIp,
    required this.onSave,
    this.defaultPort = 9666,
    this.defaultProtocol = 'http',
    this.defaultAllowInsecure = false,
    this.isEditMode = false,
    super.key,
  });

  /// Factory constructor for creating a new Click'N'Load configuration
  factory ClickNLoadBottomSheet.add({
    required String defaultIp,
    required Future<bool> Function(
      String ip,
      int port,
      String protocol,
      bool allowInsecureConnections,
    )
    onSave,
  }) {
    return ClickNLoadBottomSheet(
      defaultIp: defaultIp,
      onSave: onSave,
      isEditMode: false,
    );
  }

  /// Factory constructor for editing an existing Click'N'Load configuration
  factory ClickNLoadBottomSheet.edit({
    required String currentIp,
    required int currentPort,
    required String currentProtocol,
    required bool currentAllowInsecure,
    required Future<bool> Function(
      String ip,
      int port,
      String protocol,
      bool allowInsecureConnections,
    )
    onSave,
  }) {
    return ClickNLoadBottomSheet(
      defaultIp: currentIp,
      defaultPort: currentPort,
      defaultProtocol: currentProtocol,
      defaultAllowInsecure: currentAllowInsecure,
      onSave: onSave,
      isEditMode: true,
    );
  }

  @override
  State<ClickNLoadBottomSheet> createState() => _ClickNLoadBottomSheetState();
}

class _ClickNLoadBottomSheetState extends State<ClickNLoadBottomSheet> {
  late final TextEditingController _ipController;
  late final TextEditingController _portController;
  late final ClickNLoadBottomSheetViewModel _viewModel;
  late int _selectedProtocolIndex;
  late bool _allowInsecureConnections;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _ipController = TextEditingController(text: widget.defaultIp);
    _portController = TextEditingController(
      text: widget.defaultPort.toString(),
    );
    _viewModel = ClickNLoadBottomSheetViewModel(onSave: widget.onSave);
    _selectedProtocolIndex = widget.defaultProtocol == 'https' ? 1 : 0;
    _allowInsecureConnections = widget.defaultAllowInsecure;
  }

  @override
  void dispose() {
    _ipController.dispose();
    _portController.dispose();
    super.dispose();
  }

  String get _selectedProtocol =>
      _selectedProtocolIndex == 0 ? 'http' : 'https';

  String get _title => widget.isEditMode
      ? "Edit Click'N'Load server"
      : "Configure Click'N'Load server";

  String get _buttonText => widget.isEditMode
      ? "Update Click'N'Load server"
      : "Save Click'N'Load server";

  Future<void> _saveClickNLoadServer() async {
    setState(() => _isSaving = true);

    final success = await _viewModel.validateAndSave(
      ip: _ipController.text,
      portText: _portController.text,
      protocol: _selectedProtocol,
      allowInsecureConnections: _allowInsecureConnections,
      onError: (message) => showErrorDialog(context, message),
    );

    if (mounted) {
      if (success) {
        Navigator.pop(context);
      } else {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            Text(
              _title,
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // IP / Hostname input
            TextField(
              controller: _ipController,
              enabled: !_isSaving,
              decoration: const InputDecoration(
                labelText: 'IP / Hostname',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // Port input
            TextField(
              controller: _portController,
              enabled: !_isSaving,
              decoration: const InputDecoration(
                labelText: 'Port',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 16),

            // Protocol toggle
            Center(
              child: ToggleButtons(
                isSelected: [
                  _selectedProtocolIndex == 0,
                  _selectedProtocolIndex == 1,
                ],
                onPressed: _isSaving
                    ? null
                    : (index) {
                        setState(() {
                          _selectedProtocolIndex = index;
                          // Reset insecure checkbox when switching to http
                          if (index == 0) {
                            _allowInsecureConnections = false;
                          }
                        });
                      },
                borderRadius: BorderRadius.circular(8),
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text('http'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text('https'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Insecure connections checkbox (only visible for https)
            if (_selectedProtocolIndex == 1) ...[
              CheckboxListTile(
                value: _allowInsecureConnections,
                onChanged: _isSaving
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
              const SizedBox(height: 16),
            ],

            const SizedBox(height: 8),

            // Save button
            ElevatedButton(
              onPressed: _isSaving ? null : _saveClickNLoadServer,
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(_buttonText),
            ),
          ],
        ),
      ),
    );
  }
}
