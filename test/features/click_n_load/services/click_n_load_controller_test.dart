import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:omni_for_pyload/domain/models/clicknload_server.dart';
import 'package:omni_for_pyload/domain/models/server.dart';
import 'package:omni_for_pyload/domain/models/server_id.dart';
import 'package:omni_for_pyload/domain/repositories/i_server_repository.dart';
import 'package:omni_for_pyload/features/click_n_load/services/click_n_load_controller.dart';
import 'package:omni_for_pyload/features/click_n_load/services/click_n_load_proxy.dart';

import '../fake_click_n_load_platform.dart';
import 'click_n_load_controller_test.mocks.dart';

@GenerateMocks([IServerRepository])
void main() {
  group('ClickNLoadController', () {
    const target = ClickNLoadServer(
      ip: '192.168.1.5',
      port: 9666,
      protocol: 'http',
      allowInsecureConnections: false,
    );
    const server = Server(
      ip: '192.168.1.1',
      port: 8000,
      apiKey: 'key',
      protocol: 'http',
      allowInsecure: false,
      clickNLoad: target,
    );

    late FakeClickNLoadPlatform platform;
    late MockIServerRepository serverRepository;
    late Map<ServerId, Server> storedServers;
    late List<ClickNLoadProxy> proxies;
    late ClickNLoadController controller;

    ClickNLoadController createController() => ClickNLoadController(
      platform: platform,
      serverRepository: serverRepository,
      proxyFactory: (target) {
        final proxy = ClickNLoadProxy(
          target: target,
          client: MockClient((_) async => http.Response('ok', 200)),
          port: 0,
        );
        proxies.add(proxy);
        return proxy;
      },
    );

    /// Whether the most recently created proxy answers requests
    Future<bool> proxyResponds() async {
      final port = proxies.last.boundPort;
      if (port == null) return false;
      final response = await http.get(
        Uri.parse('http://127.0.0.1:$port/jdcheck.js'),
      );
      return response.statusCode == 200;
    }

    setUp(() {
      platform = FakeClickNLoadPlatform();
      serverRepository = MockIServerRepository();
      storedServers = {server.id: server};
      when(serverRepository.getServer(any)).thenAnswer(
        (invocation) async => storedServers[invocation.positionalArguments[0]],
      );
      when(serverRepository.updateServer(any)).thenAnswer((invocation) async {
        final updated = invocation.positionalArguments[0] as Server;
        storedServers[updated.id] = updated;
      });
      proxies = [];
      controller = createController();
    });

    tearDown(() => controller.stop());

    test('starting runs the service and the proxy for the target', () async {
      final result = await controller.start(server.id);

      expect(result, ClickNLoadStartResult.started);
      expect(controller.state, ClickNLoadRunning(server.id, target));
      expect(platform.isRunning, isTrue);
      expect(await proxyResponds(), isTrue);
    });

    test('starting while running reports already running and keeps the '
        'proxy working', () async {
      await controller.start(server.id);

      final result = await controller.start(server.id);

      expect(result, ClickNLoadStartResult.alreadyRunning);
      expect(controller.state, ClickNLoadRunning(server.id, target));
      expect(proxies, hasLength(1));
      expect(platform.isRunning, isTrue);
      expect(platform.startCount, 1);
      expect(await proxyResponds(), isTrue);
    });

    test('a double tap starts only once', () async {
      final results = await Future.wait([
        controller.start(server.id),
        controller.start(server.id),
      ]);

      expect(results, [
        ClickNLoadStartResult.started,
        ClickNLoadStartResult.alreadyRunning,
      ]);
      expect(proxies, hasLength(1));
      expect(await proxyResponds(), isTrue);
    });

    test('stopping from the notification stops the proxy and notifies '
        'listeners', () async {
      await controller.start(server.id);
      var notified = false;
      controller.addListener(() => notified = true);

      platform.stopFromNotification();
      await pumpEventQueue();

      expect(controller.state, const ClickNLoadStopped());
      expect(notified, isTrue);
      expect(await proxyResponds(), isFalse);
    });

    test('stop stops the proxy and the service', () async {
      await controller.start(server.id);

      await controller.stop();

      expect(controller.state, const ClickNLoadStopped());
      expect(platform.isRunning, isFalse);
      expect(await proxyResponds(), isFalse);
    });

    test('can start again after stopping', () async {
      await controller.start(server.id);
      await controller.stop();

      final result = await controller.start(server.id);

      expect(result, ClickNLoadStartResult.started);
      expect(await proxyResponds(), isTrue);
    });

    test('a server without configuration is not started', () async {
      storedServers[server.id] = server.copyWith(clickNLoad: () => null);

      final result = await controller.start(server.id);

      expect(result, ClickNLoadStartResult.notConfigured);
      expect(controller.state, const ClickNLoadStopped());
      expect(platform.startCount, 0);
    });

    test('reports unsupported platforms', () async {
      platform = FakeClickNLoadPlatform(isSupported: false);
      controller = createController();

      final result = await controller.start(server.id);

      expect(result, ClickNLoadStartResult.unsupported);
      expect(controller.state, const ClickNLoadUnsupported());
      expect(platform.startCount, 0);
    });

    test('a failing native service fails the start', () async {
      platform.failStart = true;

      final result = await controller.start(server.id);

      expect(result, ClickNLoadStartResult.failed);
      expect(controller.state, const ClickNLoadStopped());
      expect(platform.isRunning, isFalse);
    });

    test('a port in use fails the start and stops the service', () async {
      final blocker = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
      addTearDown(blocker.close);
      controller = ClickNLoadController(
        platform: platform,
        serverRepository: serverRepository,
        proxyFactory: (target) => ClickNLoadProxy(
          target: target,
          client: MockClient((_) async => http.Response('ok', 200)),
          port: blocker.port,
        ),
      );

      final result = await controller.start(server.id);

      expect(result, ClickNLoadStartResult.failed);
      expect(controller.state, const ClickNLoadStopped());
      expect(platform.isRunning, isFalse);
    });

    test('restarts when the native service died without notice', () async {
      await controller.start(server.id);
      platform.isRunning = false;

      final result = await controller.start(server.id);

      expect(result, ClickNLoadStartResult.started);
      expect(platform.isRunning, isTrue);
      expect(await proxyResponds(), isTrue);
    });

    test('starting for another target switches the proxy over', () async {
      const otherTarget = ClickNLoadServer(
        ip: '192.168.1.9',
        port: 9666,
        protocol: 'http',
        allowInsecureConnections: false,
      );
      final other = server.copyWith(
        ip: '192.168.1.2',
        clickNLoad: () => otherTarget,
      );
      storedServers[other.id] = other;
      await controller.start(server.id);

      final result = await controller.start(other.id);

      expect(result, ClickNLoadStartResult.started);
      expect(controller.state, ClickNLoadRunning(other.id, otherTarget));
      expect(proxies.first.boundPort, isNull);
      expect(await proxyResponds(), isTrue);
    });

    test('a removed server can no longer be started', () async {
      storedServers.remove(server.id);

      final result = await controller.start(server.id);

      expect(result, ClickNLoadStartResult.notConfigured);
      expect(platform.startCount, 0);
    });

    group('stopFor', () {
      test('stops it when running for the server', () async {
        await controller.start(server.id);

        await controller.stopFor(server.id);

        expect(controller.state, const ClickNLoadStopped());
        expect(platform.isRunning, isFalse);
        expect(await proxyResponds(), isFalse);
      });

      test('leaves it running for another server alone', () async {
        await controller.start(server.id);

        await controller.stopFor(server.copyWith(ip: '192.168.1.2').id);

        expect(controller.state, ClickNLoadRunning(server.id, target));
        expect(await proxyResponds(), isTrue);
      });
    });

    group('reconfigure', () {
      const newTarget = ClickNLoadServer(
        ip: '192.168.1.7',
        port: 9666,
        protocol: 'https',
        allowInsecureConnections: true,
      );

      test('persists the new configuration and returns the server', () async {
        final saved = await controller.reconfigure(server.id, newTarget);

        final expected = server.copyWith(clickNLoad: () => newTarget);
        verify(serverRepository.updateServer(expected)).called(1);
        expect(saved, expected);
        expect(controller.state, const ClickNLoadStopped());
        expect(platform.startCount, 0);
      });

      test('restarts against the new target if it was running', () async {
        await controller.start(server.id);

        await controller.reconfigure(server.id, newTarget);

        expect(controller.state, ClickNLoadRunning(server.id, newTarget));
        expect(proxies, hasLength(2));
        expect(proxies.last.target, newTarget);
        expect(await proxyResponds(), isTrue);
      });

      test('clearing the configuration stops it', () async {
        await controller.start(server.id);

        await controller.reconfigure(server.id, null);

        verify(
          serverRepository.updateServer(
            server.copyWith(clickNLoad: () => null),
          ),
        ).called(1);
        expect(controller.state, const ClickNLoadStopped());
        expect(platform.isRunning, isFalse);
        expect(await proxyResponds(), isFalse);
      });

      test('a cleared configuration can no longer be started', () async {
        await controller.start(server.id);
        await controller.reconfigure(server.id, null);

        final result = await controller.start(server.id);

        expect(result, ClickNLoadStartResult.notConfigured);
        expect(controller.state, const ClickNLoadStopped());
        expect(platform.isRunning, isFalse);
      });

      test('leaves it running for another server alone', () async {
        final other = server.copyWith(ip: '192.168.1.2');
        storedServers[other.id] = other;
        await controller.start(server.id);

        await controller.reconfigure(other.id, null);

        expect(controller.state, ClickNLoadRunning(server.id, target));
        expect(proxies, hasLength(1));
        expect(await proxyResponds(), isTrue);
      });

      test('returns null for a removed server', () async {
        storedServers.remove(server.id);

        final saved = await controller.reconfigure(server.id, newTarget);

        expect(saved, isNull);
        verifyNever(serverRepository.updateServer(any));
      });
    });
  });
}
