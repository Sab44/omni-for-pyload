import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:omni_for_pyload/core/service_locator.dart';
import 'package:omni_for_pyload/domain/repositories/i_pyload_api_repository.dart';
import 'package:omni_for_pyload/domain/repositories/i_server_repository.dart';
import 'package:omni_for_pyload/features/add_server/viewmodel/add_server_viewmodel.dart';
import 'package:omni_for_pyload/features/error_dialog/ui/error_dialog.dart';

/// Scans a server configuration QR code from pyLoad's web UI and adds the
/// server after a successful connection test
///
/// Pops with `true` if a server was added.
class ScanServerQrScreen extends StatefulWidget {
  const ScanServerQrScreen({super.key});

  @override
  State<ScanServerQrScreen> createState() => _ScanServerQrScreenState();
}

class _ScanServerQrScreenState extends State<ScanServerQrScreen> {
  final MobileScannerController _scannerController = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
  );
  late AddServerViewModel _viewModel;
  bool _isLoading = false;
  bool _isCodeDetected = false;

  @override
  void initState() {
    super.initState();
    _viewModel = AddServerViewModel(
      serverRepository: getIt<IServerRepository>(),
      pyLoadApiRepository: getIt<IPyLoadApiRepository>(),
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isCodeDetected) return;
    final qrCode = capture.barcodes
        .map((barcode) => barcode.rawValue)
        .whereType<String>()
        .firstOrNull;
    if (qrCode == null) return;

    // Only the first code is handled, the screen is closed afterwards
    _isCodeDetected = true;
    setState(() {
      _isLoading = true;
    });
    await _scannerController.stop();

    try {
      await _viewModel.addServerFromQrCode(qrCode);
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (!mounted) return;
      // The scanner stays stopped; return to the server overview once the
      // error was dismissed
      setState(() {
        _isLoading = false;
      });
      await showErrorDialog(context, e.toString());
      if (mounted) {
        Navigator.pop(context, false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Scan QR code'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _scannerController,
            onDetect: _onDetect,
            errorBuilder: (context, error) => _ScannerError(error: error),
          ),
          if (!_isLoading)
            const Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    'Scan the QR code shown when generating an API key in '
                    'your pyLoad instance\'s settings page.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          if (_isLoading)
            const ColoredBox(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Connecting to server...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ScannerError extends StatelessWidget {
  final MobileScannerException error;

  const _ScannerError({required this.error});

  @override
  Widget build(BuildContext context) {
    final message = error.errorCode == MobileScannerErrorCode.permissionDenied
        ? 'Camera access was denied. Allow camera access in the system '
              'settings to scan QR codes.'
        : 'The camera could not be started.';
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.no_photography, color: Colors.white, size: 48),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
