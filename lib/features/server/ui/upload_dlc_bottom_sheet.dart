import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:openapi_client/api.dart';
import 'package:omni_for_pyload/features/error_dialog/ui/error_dialog.dart';

/// Bottom sheet widget for uploading DLC files.
class UploadDlcBottomSheet extends StatefulWidget {
  final Future<void> Function(
    String fileName,
    List<int> fileBytes,
    Destination destination,
  )
  onUpload;

  const UploadDlcBottomSheet({required this.onUpload, super.key});

  @override
  State<UploadDlcBottomSheet> createState() => _UploadDlcBottomSheetState();
}

class _UploadDlcBottomSheetState extends State<UploadDlcBottomSheet> {
  static const int _maxFileSizeBytes = 1024 * 1024; // 1 MB

  String? _selectedFileName;
  List<int>? _selectedFileBytes;
  Destination _selectedDestination = Destination.QUEUE;
  bool _isUploading = false;

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        // Check file extension
        if (!file.name.toLowerCase().endsWith('.dlc')) {
          if (mounted) {
            showErrorDialog(context, 'Only .dlc files are allowed');
          }
          return;
        }

        // Check file size
        if (file.size > _maxFileSizeBytes) {
          if (mounted) {
            showErrorDialog(context, 'File size exceeds 1 MB limit');
          }
          return;
        }

        // Get file bytes
        final bytes = file.bytes;
        if (bytes == null) {
          // On some platforms, we need to read from path
          if (file.path != null) {
            final fileData = await File(file.path!).readAsBytes();
            setState(() {
              _selectedFileName = file.name;
              _selectedFileBytes = fileData;
            });
          }
        } else {
          setState(() {
            _selectedFileName = file.name;
            _selectedFileBytes = bytes;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error picking file: $e')));
      }
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedFileName == null || _selectedFileBytes == null) return;

    setState(() => _isUploading = true);

    await widget.onUpload(
      _selectedFileName!,
      _selectedFileBytes!,
      _selectedDestination,
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            Text(
              'Upload DLC',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Browse button
            Center(
              child: InkWell(
                onTap: _isUploading ? null : _pickFile,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.folder_open,
                        size: 48,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Browse',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Selected file name
            if (_selectedFileName != null)
              Text(
                _selectedFileName!,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              )
            else
              Text(
                'No file selected',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 24),
            Text('Destination', style: Theme.of(context).textTheme.titleMedium),
            RadioGroup<Destination>(
              groupValue: _selectedDestination,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedDestination = value);
                }
              },
              child: Row(
                children: [
                  Expanded(
                    child: RadioListTile<Destination>(
                      title: const Text('Queue'),
                      value: Destination.QUEUE,
                      contentPadding: EdgeInsets.zero,
                      enabled: !_isUploading,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<Destination>(
                      title: const Text('Collector'),
                      value: Destination.COLLECTOR,
                      contentPadding: EdgeInsets.zero,
                      enabled: !_isUploading,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Upload button
            ElevatedButton(
              onPressed: _selectedFileName != null && !_isUploading
                  ? _uploadFile
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isUploading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }
}
