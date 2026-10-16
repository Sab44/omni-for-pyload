import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:omni_for_pyload/core/polling/screen_visibility.dart';

class _Screen extends StatefulWidget {
  final List<bool> changes;

  const _Screen(this.changes);

  @override
  State<_Screen> createState() => _ScreenState();
}

class _ScreenState extends State<_Screen> with ScreenVisibility {
  @override
  void onVisibilityChanged(bool isVisible) => widget.changes.add(isVisible);

  @override
  Widget build(BuildContext context) => const Text('screen');
}

void main() {
  late List<bool> changes;
  late GlobalKey<NavigatorState> navigator;

  Future<void> pumpScreen(WidgetTester tester) async {
    changes = [];
    navigator = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigator,
        navigatorObservers: [routeObserver],
        home: _Screen(changes),
      ),
    );
  }

  Future<void> pushCoveringPage(WidgetTester tester) async {
    navigator.currentState!.push(
      MaterialPageRoute<void>(builder: (_) => const Text('other')),
    );
    await tester.pumpAndSettle();
  }

  Future<void> popCoveringPage(WidgetTester tester) async {
    navigator.currentState!.pop();
    await tester.pumpAndSettle();
  }

  void setLifecycle(WidgetTester tester, AppLifecycleState state) =>
      tester.binding.handleAppLifecycleStateChanged(state);

  testWidgets('a covering page hides the screen until it is popped', (
    tester,
  ) async {
    await pumpScreen(tester);

    await pushCoveringPage(tester);
    expect(changes, [false]);

    await popCoveringPage(tester);
    expect(changes, [false, true]);
  });

  testWidgets('backgrounding hides the screen until the app is resumed', (
    tester,
  ) async {
    await pumpScreen(tester);

    setLifecycle(tester, AppLifecycleState.inactive);
    setLifecycle(tester, AppLifecycleState.hidden);
    setLifecycle(tester, AppLifecycleState.paused);
    expect(changes, [false]);

    setLifecycle(tester, AppLifecycleState.hidden);
    setLifecycle(tester, AppLifecycleState.inactive);
    setLifecycle(tester, AppLifecycleState.resumed);
    expect(changes, [false, true]);
  });

  testWidgets('resuming the app keeps a covered screen hidden', (tester) async {
    await pumpScreen(tester);
    await pushCoveringPage(tester);
    setLifecycle(tester, AppLifecycleState.hidden);
    setLifecycle(tester, AppLifecycleState.paused);

    setLifecycle(tester, AppLifecycleState.hidden);
    setLifecycle(tester, AppLifecycleState.resumed);
    expect(changes, [false]);

    await popCoveringPage(tester);
    expect(changes, [false, true]);
  });
}
