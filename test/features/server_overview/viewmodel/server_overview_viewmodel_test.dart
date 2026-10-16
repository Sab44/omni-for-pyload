import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:omni_for_pyload/domain/models/clicknload_server.dart';
import 'package:omni_for_pyload/domain/models/pyload_api_failure.dart';
import 'package:omni_for_pyload/domain/models/server.dart';
import 'package:omni_for_pyload/domain/models/server_id.dart';
import 'package:omni_for_pyload/domain/repositories/i_server_repository.dart';
import 'package:omni_for_pyload/domain/repositories/i_pyload_api_repository.dart';
import 'package:omni_for_pyload/features/click_n_load/services/click_n_load_controller.dart';
import 'package:omni_for_pyload/features/click_n_load/services/click_n_load_proxy.dart';
import 'package:omni_for_pyload/features/server_overview/viewmodel/server_availability.dart';
import 'package:omni_for_pyload/features/server_overview/viewmodel/server_overview_viewmodel.dart';
import 'package:openapi_client/api.dart';

import 'dart:async';

import 'package:fake_async/fake_async.dart';

import '../../click_n_load/fake_click_n_load_platform.dart';
import 'server_overview_viewmodel_test.mocks.dart';

@GenerateMocks([IServerRepository, IPyLoadApiRepository])
void main() {
  group('ServerOverviewViewModel', () {
    late MockIServerRepository mockServerRepository;
    late MockIPyLoadApiRepository mockPyLoadApiRepository;
    late FakeClickNLoadPlatform clickNLoadPlatform;
    late ClickNLoadController clickNLoadController;
    late Server server;
    late ServerOverviewViewModel viewModel;

    setUp(() {
      mockServerRepository = MockIServerRepository();
      mockPyLoadApiRepository = MockIPyLoadApiRepository();
      // Servers are offline unless a test stubs a status
      when(mockPyLoadApiRepository.getServerStatus(any))
          .thenThrow(const PyLoadApiUnreachable());
      clickNLoadPlatform = FakeClickNLoadPlatform();
      clickNLoadController = ClickNLoadController(
        platform: clickNLoadPlatform,
        serverRepository: mockServerRepository,
        proxyFactory: (target) => ClickNLoadProxy(
          target: target,
          client: MockClient((_) async => http.Response('ok', 200)),
          port: 0,
        ),
      );
      viewModel = ServerOverviewViewModel(
        serverRepository: mockServerRepository,
        pyLoadApiRepository: mockPyLoadApiRepository,
        clickNLoadController: clickNLoadController,
      );

      server = Server(
        ip: '192.168.1.1',
        port: 8000,
        apiKey: 'test-api-key-1',
        protocol: 'http',
        allowInsecure: false,
      );
    });

    tearDown(() async {
      viewModel.dispose();
      await clickNLoadController.stop();
    });

    test('loadServers retrieves and updates server list', () async {
      final testServers = [
        server,
        Server(
          ip: '192.168.1.2',
          port: 8001,
          apiKey: 'test-api-key-2',
          protocol: 'https',
          allowInsecure: true,
        ),
      ];

      when(mockServerRepository.getAllServers())
          .thenAnswer((_) async => testServers);

      await viewModel.loadServers();

      expect(viewModel.servers, equals(testServers));
      expect(viewModel.servers.length, 2);
      verify(mockServerRepository.getAllServers()).called(1);
    });

    test('loadServers returns empty list when no servers exist', () async {
      when(mockServerRepository.getAllServers()).thenAnswer((_) async => []);

      await viewModel.loadServers();

      expect(viewModel.servers, isEmpty);
      verify(mockServerRepository.getAllServers()).called(1);
    });

    test('removeServer removes server from list and repository', () async {
      final initialServers = [server];
      when(mockServerRepository.getAllServers())
          .thenAnswer((_) async => initialServers);

      when(
        mockServerRepository.removeServer(const ServerId('192.168.1.1', 8000)),
      ).thenAnswer((_) async => Future<void>.value());

      // Load servers first
      await viewModel.loadServers();
      expect(viewModel.servers.length, 1);

      // Then remove one
      await viewModel.removeServer(server);

      expect(viewModel.servers, isEmpty);
      verify(
        mockServerRepository.removeServer(const ServerId('192.168.1.1', 8000)),
      ).called(1);
    });

    test('polling updates status to online on success', () {
      fakeAsync((async) {
        when(mockServerRepository.getAllServers())
            .thenAnswer((_) async => [server]);
        when(mockPyLoadApiRepository.getServerStatus(any)).thenAnswer(
          (_) => Future.value(
            ServerStatus(
              pause: false,
              active: 0,
              queue: 0,
              total: 0,
              speed: 0,
              download: false,
              reconnect: false,
              captcha: false,
              proxy: false,
            ),
          ),
        );

        viewModel.loadServers();
        async.flushMicrotasks();

        expect(
          viewModel.statusOf(const ServerId('192.168.1.1', 8000)),
          ServerAvailability.online,
        );
        // verify(mockPyLoadApiRepository.getServerStatus(any)).called(1); // Removed

        // Advance 2 seconds
        async.elapse(const Duration(seconds: 2, milliseconds: 100));
        async.flushMicrotasks();

        verify(mockPyLoadApiRepository.getServerStatus(any)).called(2);
      });
    });

    test('polling updates status to offline on error', () {
      fakeAsync((async) {
        when(mockServerRepository.getAllServers())
            .thenAnswer((_) async => [server]);
        when(mockPyLoadApiRepository.getServerStatus(any))
            .thenThrow(const PyLoadApiUnreachable());

        viewModel.loadServers();
        async.flushMicrotasks();

        expect(
          viewModel.statusOf(const ServerId('192.168.1.1', 8000)),
          ServerAvailability.offline,
        );

        // Advance 2 seconds
        async.elapse(const Duration(seconds: 2, milliseconds: 100));
        async.flushMicrotasks();

        verify(mockPyLoadApiRepository.getServerStatus(any)).called(2);
      });
    });

    test('polling updates status to offline on timeout', () {
      fakeAsync((async) {
        when(mockServerRepository.getAllServers())
            .thenAnswer((_) async => [server]);

        // Simulate timeout by returning a future that completes after 2 seconds
        when(mockPyLoadApiRepository.getServerStatus(any))
            .thenAnswer((_) async {
              await Future.delayed(const Duration(seconds: 2));
              throw const PyLoadApiTimeout();
            });

        viewModel.loadServers();
        async.flushMicrotasks();

        // Should be waiting now.
        // Advance 2 seconds (timeout)
        async.elapse(const Duration(seconds: 2, milliseconds: 100));
        async.flushMicrotasks();

        expect(
          viewModel.statusOf(const ServerId('192.168.1.1', 8000)),
          ServerAvailability.offline,
        );

        // Should poll immediately again (no 2s delay)
        // We verify it was called again immediately
        verify(mockPyLoadApiRepository.getServerStatus(any)).called(2);
      });
    });

    test('loadServers triggers notifyListeners', () async {
      final testServers = [server];

      when(mockServerRepository.getAllServers())
          .thenAnswer((_) async => testServers);

      // Create a spy to track notifyListeners calls
      int listenerCount = 0;
      viewModel.addListener(() {
        listenerCount++;
      });

      await viewModel.loadServers();

      // Expect at least 1, could be more due to status updates
      expect(listenerCount, greaterThanOrEqualTo(1));
      expect(viewModel.servers.length, equals(1));
    });

    test('removeServer stops Click\'N\'Load running for it', () async {
      final configured = server.copyWith(
        clickNLoad: () => const ClickNLoadServer(
          ip: '192.168.1.5',
          port: 9666,
          protocol: 'http',
          allowInsecureConnections: false,
        ),
      );
      when(mockServerRepository.getServer(server.id))
          .thenAnswer((_) async => configured);
      when(mockServerRepository.removeServer(any)).thenAnswer((_) async {});
      await clickNLoadController.start(server.id);

      await viewModel.removeServer(configured);

      expect(clickNLoadController.state, const ClickNLoadStopped());
      expect(clickNLoadPlatform.isRunning, isFalse);
    });

    test('removeServer triggers notifyListeners', () async {
      when(mockServerRepository.getAllServers())
          .thenAnswer((_) async => [server]);
      when(mockServerRepository.removeServer(any))
          .thenAnswer((_) async => Future.value());
      // Keep the status request pending so polling does not notify listeners
      when(mockPyLoadApiRepository.getServerStatus(any))
          .thenAnswer((_) => Completer<ServerStatus>().future);

      await viewModel.loadServers();

      int listenerCount = 0;
      viewModel.addListener(() {
        listenerCount++;
      });

      await viewModel.removeServer(server);

      expect(listenerCount, equals(1));
    });

    test('polling uses the edited configuration after reload', () {
      fakeAsync((async) {
        final edited = server.copyWith(protocol: 'https', apiKey: 'new-key');
        var stored = [server];
        when(mockServerRepository.getAllServers())
            .thenAnswer((_) async => stored);
        when(mockPyLoadApiRepository.getServerStatus(any)).thenAnswer(
          (_) async => ServerStatus(
            pause: false,
            active: 0,
            queue: 0,
            total: 0,
            speed: 0,
            download: false,
            reconnect: false,
            captcha: false,
            proxy: false,
          ),
        );

        viewModel.loadServers();
        async.flushMicrotasks();
        verify(mockPyLoadApiRepository.getServerStatus(server)).called(1);

        stored = [edited];
        viewModel.loadServers();
        async.flushMicrotasks();
        verify(mockPyLoadApiRepository.getServerStatus(edited)).called(1);

        async.elapse(const Duration(seconds: 2, milliseconds: 100));
        verify(mockPyLoadApiRepository.getServerStatus(edited)).called(1);
        verifyNever(mockPyLoadApiRepository.getServerStatus(server));
      });
    });

    test('loadServers drops the status of an edited server', () {
      fakeAsync((async) {
        final edited = server.copyWith(name: 'Renamed');
        var stored = [server];
        final pending = Completer<ServerStatus>();
        when(mockServerRepository.getAllServers())
            .thenAnswer((_) async => stored);
        when(mockPyLoadApiRepository.getServerStatus(server))
            .thenThrow(const PyLoadApiUnreachable());
        when(mockPyLoadApiRepository.getServerStatus(edited))
            .thenAnswer((_) => pending.future);

        viewModel.loadServers();
        async.flushMicrotasks();
        expect(
          viewModel.statusOf(const ServerId('192.168.1.1', 8000)),
          ServerAvailability.offline,
        );

        stored = [edited];
        viewModel.loadServers();
        async.flushMicrotasks();

        expect(
          viewModel.statusOf(const ServerId('192.168.1.1', 8000)),
          ServerAvailability.fetching,
        );
      });
    });

    test('nothing is fetched while paused', () {
      fakeAsync((async) {
        when(mockServerRepository.getAllServers())
            .thenAnswer((_) async => [server]);

        viewModel.loadServers();
        async.flushMicrotasks();
        viewModel.pausePolling();
        clearInteractions(mockPyLoadApiRepository);
        async.elapse(const Duration(minutes: 1));

        verifyNever(mockPyLoadApiRepository.getServerStatus(any));
      });
    });

    test('resuming fetches right away, then every 2 seconds', () {
      fakeAsync((async) {
        when(mockServerRepository.getAllServers())
            .thenAnswer((_) async => [server]);
        viewModel.loadServers();
        async.flushMicrotasks();
        viewModel.pausePolling();
        async.elapse(const Duration(minutes: 1));
        clearInteractions(mockPyLoadApiRepository);

        viewModel.resumePolling();
        async.flushMicrotasks();
        verify(mockPyLoadApiRepository.getServerStatus(server)).called(1);

        async.elapse(const Duration(seconds: 4));
        verify(mockPyLoadApiRepository.getServerStatus(server)).called(2);
      });
    });

    test('a removed server is no longer polled', () {
      fakeAsync((async) {
        when(mockServerRepository.getAllServers())
            .thenAnswer((_) async => [server]);
        when(mockServerRepository.removeServer(any)).thenAnswer((_) async {});
        // Created in fake time, so removing can stop Click'N'Load
        final inFakeTime = ServerOverviewViewModel(
          serverRepository: mockServerRepository,
          pyLoadApiRepository: mockPyLoadApiRepository,
          clickNLoadController: ClickNLoadController(
            platform: FakeClickNLoadPlatform(),
            serverRepository: mockServerRepository,
          ),
        );
        inFakeTime.loadServers();
        async.flushMicrotasks();

        inFakeTime.removeServer(server);
        async.flushMicrotasks();
        clearInteractions(mockPyLoadApiRepository);
        async.elapse(const Duration(minutes: 1));

        verifyNever(mockPyLoadApiRepository.getServerStatus(any));
        inFakeTime.dispose();
      });
    });

    test('nothing is fetched after dispose', () {
      fakeAsync((async) {
        final disposed = ServerOverviewViewModel(
          serverRepository: mockServerRepository,
          pyLoadApiRepository: mockPyLoadApiRepository,
          clickNLoadController: clickNLoadController,
        );
        when(mockServerRepository.getAllServers())
            .thenAnswer((_) async => [server]);
        disposed.loadServers();
        async.flushMicrotasks();

        disposed.dispose();
        clearInteractions(mockPyLoadApiRepository);
        async.elapse(const Duration(minutes: 1));

        verifyNever(mockPyLoadApiRepository.getServerStatus(any));
      });
    });

    test('loadServers keeps the status of an unchanged server', () {
      fakeAsync((async) {
        when(mockServerRepository.getAllServers())
            .thenAnswer((_) async => [server.copyWith()]);
        when(mockPyLoadApiRepository.getServerStatus(any))
            .thenThrow(const PyLoadApiUnreachable());

        viewModel.loadServers();
        async.flushMicrotasks();
        viewModel.loadServers();
        async.flushMicrotasks();

        expect(
          viewModel.statusOf(const ServerId('192.168.1.1', 8000)),
          ServerAvailability.offline,
        );
      });
    });
  });
}
