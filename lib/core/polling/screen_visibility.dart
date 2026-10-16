import 'package:flutter/widgets.dart';

/// Tracks which page route covers which, registered with the app's navigator
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

/// Tells a screen whether it is visible: the app is in the foreground and no
/// other page is pushed on top of it. Screens use it to pause polling.
///
/// The screen is visible initially; [onVisibilityChanged] is called on every
/// change.
mixin ScreenVisibility<T extends StatefulWidget> on State<T> {
  late final _observer = _VisibilityObserver(
    onAppLifecycleChanged: _onAppLifecycleChanged,
    onCoveredChanged: (isCovered) {
      _isCovered = isCovered;
      _update();
    },
  );
  bool _isInForeground = true;
  bool _isCovered = false;
  bool _isVisible = true;

  void onVisibilityChanged(bool isVisible);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(_observer);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(_observer, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_observer);
    routeObserver.unsubscribe(_observer);
    super.dispose();
  }

  void _onAppLifecycleChanged(AppLifecycleState state) {
    // Intermediate states (inactive, hidden) keep the last state
    if (state == AppLifecycleState.paused) {
      _isInForeground = false;
    } else if (state == AppLifecycleState.resumed) {
      _isInForeground = true;
    }
    _update();
  }

  void _update() {
    final isVisible = _isInForeground && !_isCovered;
    if (isVisible == _isVisible) return;
    _isVisible = isVisible;
    onVisibilityChanged(isVisible);
  }
}

class _VisibilityObserver with WidgetsBindingObserver implements RouteAware {
  final void Function(AppLifecycleState state) onAppLifecycleChanged;
  final void Function(bool isCovered) onCoveredChanged;

  _VisibilityObserver({
    required this.onAppLifecycleChanged,
    required this.onCoveredChanged,
  });

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) =>
      onAppLifecycleChanged(state);

  @override
  void didPushNext() => onCoveredChanged(true);

  @override
  void didPopNext() => onCoveredChanged(false);

  @override
  void didPush() {}

  @override
  void didPop() {}
}
