import 'package:omni_for_pyload/features/click_n_load/services/click_n_load_platform.dart';

/// In-memory [ClickNLoadPlatform] that behaves like the Android service
class FakeClickNLoadPlatform implements ClickNLoadPlatform {
  @override
  final bool isSupported;

  bool isRunning = false;
  int startCount = 0;
  int stopCount = 0;
  bool failStart = false;
  void Function()? _onServiceStopped;

  FakeClickNLoadPlatform({this.isSupported = true});

  @override
  set onServiceStopped(void Function()? callback) =>
      _onServiceStopped = callback;

  /// Simulate the user stopping the service from its notification
  void stopFromNotification() {
    isRunning = false;
    _onServiceStopped?.call();
  }

  @override
  Future<void> startService() async {
    if (failStart) throw Exception('service failed to start');
    startCount++;
    isRunning = true;
  }

  @override
  Future<void> stopService() async {
    stopCount++;
    isRunning = false;
  }

  @override
  Future<bool> isServiceRunning() async => isRunning;
}
