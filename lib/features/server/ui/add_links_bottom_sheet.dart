import 'package:flutter/material.dart';
import 'package:openapi_client/api.dart';
import 'package:omni_for_pyload/features/error_dialog/ui/error_dialog.dart';

/// Bottom sheet widget for adding links to create a new package.
class AddLinksBottomSheet extends StatefulWidget {
  final Future<bool> Function(
    String name,
    List<String> links,
    String password,
    Destination destination,
  )
  onAdd;

  const AddLinksBottomSheet({required this.onAdd, super.key});

  @override
  State<AddLinksBottomSheet> createState() => _AddLinksBottomSheetState();
}

class _AddLinksBottomSheetState extends State<AddLinksBottomSheet> {
  final _packageNameController = TextEditingController();
  final _linksController = TextEditingController();
  final _passwordController = TextEditingController();
  Destination _selectedDestination = Destination.QUEUE;
  bool _isAdding = false;

  @override
  void dispose() {
    _packageNameController.dispose();
    _linksController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _addPackage() async {
    final packageName = _packageNameController.text.trim();
    final linksText = _linksController.text.trim();
    final passwordText = _passwordController.text.trim();

    // Validation
    if (packageName.isEmpty) {
      showErrorDialog(context, 'Please enter a package name');
      return;
    }

    if (linksText.isEmpty) {
      showErrorDialog(context, 'Please enter at least one link');
      return;
    }

    // Parse links - split by newlines and filter empty lines
    final links = linksText
        .split('\n')
        .map((link) => link.trim())
        .where((link) => link.isNotEmpty)
        .toList();

    if (links.isEmpty) {
      showErrorDialog(context, 'Please enter at least one valid link');
      return;
    }

    setState(() => _isAdding = true);

    final success = await widget.onAdd(
      packageName,
      links,
      passwordText,
      _selectedDestination,
    );

    if (mounted) {
      if (success) {
        Navigator.pop(context);
      } else {
        setState(() => _isAdding = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 1.0,
      minChildSize: 0.5,
      maxChildSize: 1.0,
      expand: false,
      builder: (context, scrollController) {
        return Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          shape: Theme.of(context).bottomSheetTheme.shape,
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 32,
            ),
            child: Column(
              children: [
                // Title
                Text(
                  'Add links',
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // Scrollable content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 16),
                              // Package name input
                              TextField(
                                controller: _packageNameController,
                                enabled: !_isAdding,
                                decoration: const InputDecoration(
                                  labelText: 'Package name',
                                  border: OutlineInputBorder(),
                                ),
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: 16),

                              // Links multiline input
                              TextField(
                                controller: _linksController,
                                enabled: !_isAdding,
                                maxLines: 8,
                                minLines: 8,
                                textAlignVertical: TextAlignVertical.top,
                                decoration: const InputDecoration(
                                  labelText: 'Links',
                                  hintText: 'Enter one link per line',
                                  alignLabelWithHint: true,
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.multiline,
                              ),
                              const SizedBox(height: 16),

                              // Password input
                              TextField(
                                controller: _passwordController,
                                enabled: !_isAdding,
                                decoration: const InputDecoration(
                                  labelText: 'Password',
                                  border: OutlineInputBorder(),
                                ),
                                obscureText: true,
                              ),
                              const SizedBox(height: 16),

                              // Destination section
                              Text(
                                'Destination',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              RadioGroup<Destination>(
                                groupValue: _selectedDestination,
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(
                                      () => _selectedDestination = value,
                                    );
                                  }
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: RadioListTile<Destination>(
                                        title: const Text('Queue'),
                                        value: Destination.QUEUE,
                                        contentPadding: EdgeInsets.zero,
                                        enabled: !_isAdding,
                                      ),
                                    ),
                                    Expanded(
                                      child: RadioListTile<Destination>(
                                        title: const Text('Collector'),
                                        value: Destination.COLLECTOR,
                                        contentPadding: EdgeInsets.zero,
                                        enabled: !_isAdding,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Add button
                      ElevatedButton(
                        onPressed: _isAdding ? null : _addPackage,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isAdding
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Add'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
