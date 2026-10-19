import 'package:flutter/material.dart';
import 'package:omni_for_pyload/features/add_server/viewmodel/add_server_viewmodel.dart';
import 'package:omni_for_pyload/features/error_dialog/ui/error_dialog.dart';

/// Shows why a server could not be added or saved
///
/// Shared by the manual form and the QR code scanner, so both show the same
/// dialogs. If local network access is denied, the dialog offers to open the
/// app settings.
Future<void> showAddServerErrorDialog(
  BuildContext context,
  Object error,
  AddServerViewModel viewModel,
) {
  final isLocalNetworkDenied = error is LocalNetworkAccessDeniedException;
  return showErrorDialog(
    context,
    error.toString(),
    actionLabel: isLocalNetworkDenied ? 'Open Settings' : null,
    onAction: isLocalNetworkDenied ? viewModel.openAppSettings : null,
  );
}
