import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';

/// Native side of Click'N'Load: the service that keeps the app process alive
/// while the local proxy runs
abstract class ClickNLoadPlatform {
  /// Whether Click'N'Load can run on this platform at all
  bool get isSupported;

  /// Called when the native service was stopped from outside the app,
  /// e.g. from its notification
  set onServiceStopped(void Function()? callback);

  Future<void> startService();

  Future<void> stopService();

  Future<bool> isServiceRunning();
}

/// Android foreground service, controlled via a method channel
class AndroidClickNLoadPlatform implements ClickNLoadPlatform {
  static final _log = Logger('AndroidClickNLoadPlatform');

  static const MethodChannel _channel = MethodChannel(
    'com.downloader.omni_for_pyload/click_n_load',
  );

  void Function()? _onServiceStopped;

  AndroidClickNLoadPlatform() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  @override
  bool get isSupported => true;

  @override
  set onServiceStopped(void Function()? callback) =>
      _onServiceStopped = callback;

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onServiceStopped':
        _log.info('Received stop signal from native service');
        _onServiceStopped?.call();
        return null;
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'Method ${call.method} not implemented',
        );
    }
  }

  @override
  Future<void> startService() async {
    // The foreground service shows a notification, which needs permission
    await Permission.notification.request();
    await _channel.invokeMethod('startService');
  }

  @override
  Future<void> stopService() => _channel.invokeMethod('stopService');

  @override
  Future<bool> isServiceRunning() async =>
      await _channel.invokeMethod<bool>('isRunning') ?? false;
}

/// Platforms without Click'N'Load support (iOS)
class UnsupportedClickNLoadPlatform implements ClickNLoadPlatform {
  const UnsupportedClickNLoadPlatform();

  @override
  bool get isSupported => false;

  @override
  set onServiceStopped(void Function()? callback) {}

  @override
  Future<void> startService() =>
      throw UnsupportedError('Click\'N\'Load is not supported');

  @override
  Future<void> stopService() async {}

  @override
  Future<bool> isServiceRunning() async => false;
}
