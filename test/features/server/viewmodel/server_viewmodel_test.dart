import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:omni_for_pyload/domain/models/clicknload_server.dart';
import 'package:omni_for_pyload/domain/models/server.dart';
import 'package:omni_for_pyload/domain/repositories/i_pyload_api_repository.dart';
import 'package:omni_for_pyload/domain/repositories/i_server_repository.dart';
import 'package:omni_for_pyload/features/click_n_load/services/click_n_load_controller.dart';
import 'package:omni_for_pyload/features/click_n_load/services/click_n_load_proxy.dart';
import 'package:omni_for_pyload/features/server/viewmodel/server_viewmodel.dart';
import 'package:openapi_client/api.dart';

import '../../click_n_load/fake_click_n_load_platform.dart';
import 'server_viewmodel_test.mocks.dart';

@GenerateMocks([IPyLoadApiRepository, IServerRepository])
void main() {
  group('ServerViewModel', () {
    late MockIPyLoadApiRepository mockPyLoadApiRepository;
    late MockIServerRepository mockServerRepository;
    late FakeClickNLoadPlatform clickNLoadPlatform;
    late ClickNLoadController clickNLoadController;
    late Server server;
    late ServerViewModel viewModel;

    ClickNLoadController createClickNLoadController() => ClickNLoadController(
      platform: clickNLoadPlatform,
      serverRepository: mockServerRepository,
      proxyFactory: (target) => ClickNLoadProxy(
        target: target,
        client: MockClient((_) async => http.Response('ok', 200)),
        port: 0,
      ),
    );

    ServerViewModel createViewModel() => ServerViewModel(
      server: server,
      pyLoadApiRepository: mockPyLoadApiRepository,
      serverRepository: mockServerRepository,
      clickNLoadController: clickNLoadController,
    );

    setUp(() {
      mockPyLoadApiRepository = MockIPyLoadApiRepository();
      mockServerRepository = MockIServerRepository();
      clickNLoadPlatform = FakeClickNLoadPlatform();
      clickNLoadController = createClickNLoadController();
      server = Server(
        ip: '192.168.1.100',
        port: 8000,
        apiKey: 'test-api-key',
        protocol: 'http',
        allowInsecure: false,
        name: 'Test Server',
      );

      // Mock initial server status call which happens in constructor
      when(mockPyLoadApiRepository.getServerStatus(server)).thenAnswer(
        (_) async => ServerStatus(
          pause: false,
          active: 1,
          total: 10,
          speed: 100,
          download: true,
          reconnect: false,
          queue: 5,
          captcha: false,
          proxy: false,
        ),
      );

      viewModel = createViewModel();
    });

    tearDown(() async {
      viewModel.dispose();
      await clickNLoadController.stop();
    });

    test('initial state is correct', () {
      expect(viewModel.selectedTabIndex, 0);
      expect(viewModel.downloads, isEmpty);
      expect(viewModel.queueData, isEmpty);
      expect(viewModel.collectorData, isEmpty);
      expect(viewModel.selectedPackageIds, isEmpty);
      expect(viewModel.isSelectionMode, false);
      expect(viewModel.error, null);
    });

    test('setSelectedTab updates index and starts polling', () async {
      // Setup mocks for polling calls
      when(mockPyLoadApiRepository.getDownloadStatus(server))
          .thenAnswer((_) async => []);
      when(mockPyLoadApiRepository.getQueue(server))
          .thenAnswer((_) async => []);
      when(mockPyLoadApiRepository.getCollector(server))
          .thenAnswer((_) async => []);

      // Tab 0 (Overview) - already selected by default, but let's verify behavior
      viewModel.setSelectedTab(0);
      expect(viewModel.selectedTabIndex, 0);
      verify(mockPyLoadApiRepository.getDownloadStatus(server))
          .called(greaterThan(0));

      // Tab 1 (Queue)
      viewModel.setSelectedTab(1);
      expect(viewModel.selectedTabIndex, 1);
      verify(mockPyLoadApiRepository.getQueue(server)).called(1);

      // Tab 2 (Collector)
      viewModel.setSelectedTab(2);
      expect(viewModel.selectedTabIndex, 2);
      verify(mockPyLoadApiRepository.getCollector(server)).called(1);
    });

    test('toggleSelection adds and removes package ids', () {
      viewModel.toggleSelection(1);
      expect(viewModel.selectedPackageIds, contains(1));
      expect(viewModel.isSelectionMode, true);

      viewModel.toggleSelection(1);
      expect(viewModel.selectedPackageIds, isNot(contains(1)));
      expect(viewModel.isSelectionMode, false);
    });

    test('clearSelection clears all selected package ids', () {
      viewModel.toggleSelection(1);
      viewModel.toggleSelection(2);
      expect(viewModel.selectedPackageIds.length, 2);

      viewModel.clearSelection();
      expect(viewModel.selectedPackageIds, isEmpty);
      expect(viewModel.isSelectionMode, false);
    });

    test('deleteSelectedPackages calls repository and clears selection', () async {
      viewModel.toggleSelection(1);
      viewModel.toggleSelection(2);

      when(mockPyLoadApiRepository.deletePackages(server, [1, 2]))
          .thenAnswer((_) async => {});
      // Mock getDownloadStatus because setSelectedTab(0) is called after delete
      when(mockPyLoadApiRepository.getDownloadStatus(server))
          .thenAnswer((_) async => []);

      final result = await viewModel.deleteSelectedPackages();

      expect(result, true);
      verify(mockPyLoadApiRepository.deletePackages(server, [1, 2])).called(1);
      expect(viewModel.selectedPackageIds, isEmpty);
    });

    test(
      'restartSelectedPackages calls repository and clears selection',
      () async {
        viewModel.toggleSelection(1);

        when(mockPyLoadApiRepository.restartPackages(server, [1]))
            .thenAnswer((_) async => Result.success);
        when(mockPyLoadApiRepository.getDownloadStatus(server))
            .thenAnswer((_) async => []);

        final result = await viewModel.restartSelectedPackages();

        expect(result, Result.success);
        verify(mockPyLoadApiRepository.restartPackages(server, [1])).called(1);
        expect(viewModel.selectedPackageIds, isEmpty);
      },
    );

    test(
      'moveSelectedPackages calls repository with correct destination',
      () async {
        // Test moving to Queue (when on Collector tab)
        viewModel.setSelectedTab(2); // Collector tab
        viewModel.toggleSelection(1);

        when(mockPyLoadApiRepository.getCollector(server))
            .thenAnswer((_) async => []);
        when(
          mockPyLoadApiRepository.movePackages(server, [1], Destination.QUEUE),
        ).thenAnswer((_) async => Result.success);

        final result = await viewModel.moveSelectedPackages();

        expect(result, Result.success);
        verify(
          mockPyLoadApiRepository.movePackages(server, [1], Destination.QUEUE),
        ).called(1);
        expect(viewModel.selectedPackageIds, isEmpty);
      },
    );

    test('extractSelectedPackages calls repository', () async {
      viewModel.toggleSelection(1);

      when(mockPyLoadApiRepository.extractPackages(server, [1]))
          .thenAnswer((_) async => Result.success);
      when(mockPyLoadApiRepository.getDownloadStatus(server))
          .thenAnswer((_) async => []);

      final result = await viewModel.extractSelectedPackages();

      expect(result, true);
      verify(mockPyLoadApiRepository.extractPackages(server, [1])).called(1);
      expect(viewModel.selectedPackageIds, isEmpty);
    });

    test('resumeQueue calls unpauseServer', () async {
      // Mock server status as paused
      when(mockPyLoadApiRepository.getServerStatus(server)).thenAnswer(
        (_) async => ServerStatus(
          pause: true,
          active: 1,
          total: 10,
          speed: 100,
          download: true,
          reconnect: false,
          queue: 5,
          captcha: false,
          proxy: false,
        ),
      );

      final pausedViewModel = createViewModel();

      // Allow the constructor's async fetch to complete
      await Future.delayed(Duration.zero);

      when(mockPyLoadApiRepository.unpauseServer(server))
          .thenAnswer((_) async => true);

      final result = await pausedViewModel.resumeQueue();

      expect(result, true);
      verify(mockPyLoadApiRepository.unpauseServer(server)).called(1);
      pausedViewModel.dispose();
    });

    test('pauseQueue calls pauseServer', () async {
      // Initial state is not paused (from setUp), so pauseQueue should proceed.

      // Wait for initial fetch to populate _serverStatus (pause: false)
      await Future.delayed(Duration.zero);

      when(mockPyLoadApiRepository.pauseServer(server))
          .thenAnswer((_) async => true);
      // It also calls _fetchServerStatus again
      when(mockPyLoadApiRepository.getServerStatus(server)).thenAnswer(
        (_) async => ServerStatus(
          pause: true,
          active: 1,
          total: 10,
          speed: 100,
          download: true,
          reconnect: false,
          queue: 5,
          captcha: false,
          proxy: false,
        ),
      );

      final result = await viewModel.pauseQueue();

      expect(result, true);
      verify(mockPyLoadApiRepository.pauseServer(server)).called(1);
    });

    test('stopQueue calls stopAllDownloads', () async {
      when(mockPyLoadApiRepository.stopAllDownloads(server))
          .thenAnswer((_) async => []);

      final result = await viewModel.stopQueue();

      expect(result, true);
      verify(mockPyLoadApiRepository.stopAllDownloads(server)).called(1);
    });

    test('clearFinished calls deleteFinished', () async {
      when(mockPyLoadApiRepository.deleteFinished(server))
          .thenAnswer((_) async => []);
      when(mockPyLoadApiRepository.getDownloadStatus(server))
          .thenAnswer((_) async => []);

      final result = await viewModel.clearFinished();

      expect(result, true);
      verify(mockPyLoadApiRepository.deleteFinished(server)).called(1);
    });

    test('restartFailed calls restartFailed', () async {
      when(mockPyLoadApiRepository.restartFailed(server))
          .thenAnswer((_) async => []);
      when(mockPyLoadApiRepository.getDownloadStatus(server))
          .thenAnswer((_) async => []);

      final result = await viewModel.restartFailed();

      expect(result, true);
      verify(mockPyLoadApiRepository.restartFailed(server)).called(1);
    });

    test('uploadDlc calls uploadContainer', () async {
      final bytes = [1, 2, 3];
      when(
        mockPyLoadApiRepository.uploadContainer(
          server,
          'test.dlc',
          bytes,
          Destination.COLLECTOR,
        ),
      ).thenAnswer((_) async => {});

      // If tab is 2 (Collector), it refreshes
      viewModel.setSelectedTab(2);
      when(mockPyLoadApiRepository.getCollector(server))
          .thenAnswer((_) async => []);

      final result = await viewModel.uploadDlc(
        'test.dlc',
        bytes,
        Destination.COLLECTOR,
      );

      expect(result, true);
      verify(
        mockPyLoadApiRepository.uploadContainer(
          server,
          'test.dlc',
          bytes,
          Destination.COLLECTOR,
        ),
      ).called(1);
      // Verify refresh happened (called twice: once for tab select, once for upload refresh)
      verify(mockPyLoadApiRepository.getCollector(server)).called(2);
    });

    test('addPackageWithLinks calls addPackage without password', () async {
      final links = ['http://example.com/file.zip'];
      when(
        mockPyLoadApiRepository.addPackage(
          server,
          'test package',
          links,
          Destination.QUEUE,
        ),
      ).thenAnswer((_) async => 123);

      // If destination is Queue and tab is Queue, it refreshes
      viewModel.setSelectedTab(1);
      when(mockPyLoadApiRepository.getQueue(server))
          .thenAnswer((_) async => []);

      final result = await viewModel.addPackageWithLinks(
        'test package',
        links,
        '',
        Destination.QUEUE,
      );

      expect(result, true);
      verify(
        mockPyLoadApiRepository.addPackage(
          server,
          'test package',
          links,
          Destination.QUEUE,
        ),
      ).called(1);
      verifyNever(mockPyLoadApiRepository.setPackagePassword(any, any, any));
      // Verify refresh happened (called twice: once for tab select, once for addPackage refresh)
      verify(mockPyLoadApiRepository.getQueue(server)).called(2);
    });

    test('addPackageWithLinks calls addPackage with password', () async {
      final links = ['http://example.com/file.zip'];
      when(
        mockPyLoadApiRepository.addPackage(
          server,
          'test package',
          links,
          Destination.QUEUE,
        ),
      ).thenAnswer((_) async => 123);

      // If destination is Queue and tab is Queue, it refreshes
      viewModel.setSelectedTab(1);
      when(mockPyLoadApiRepository.getQueue(server))
          .thenAnswer((_) async => []);

      final result = await viewModel.addPackageWithLinks(
        'test package',
        links,
        's3cret',
        Destination.QUEUE,
      );

      expect(result, true);
      verify(
        mockPyLoadApiRepository.addPackage(
          server,
          'test package',
          links,
          Destination.QUEUE,
        ),
      ).called(1);
      verify(mockPyLoadApiRepository.setPackagePassword(server, 123, 's3cret'))
          .called(1);
      // Verify refresh happened (called twice: once for tab select, once for addPackage refresh)
      verify(mockPyLoadApiRepository.getQueue(server)).called(2);
    });

    group('server', () {
      const clickNLoad = ClickNLoadServer(
        ip: '192.168.1.5',
        port: 9666,
        protocol: 'https',
        allowInsecureConnections: true,
      );

      test('reloadServer picks up changes saved elsewhere', () async {
        final stored = server.copyWith(clickNLoad: () => clickNLoad);
        when(mockServerRepository.getServer(server.id))
            .thenAnswer((_) async => stored);
        when(mockPyLoadApiRepository.getServerStatus(stored))
            .thenAnswer((_) async => throw Exception('offline'));
        var notified = false;
        viewModel.addListener(() => notified = true);

        await viewModel.reloadServer();

        expect(viewModel.server, stored);
        expect(viewModel.hasClickNLoadConfigured, isTrue);
        expect(notified, isTrue);
      });

      test('reloadServer keeps the server if it no longer exists', () async {
        when(mockServerRepository.getServer(server.id))
            .thenAnswer((_) async => null);

        await viewModel.reloadServer();

        expect(viewModel.server, server);
      });

      test('configureClickNLoad persists a new server snapshot', () async {
        when(mockServerRepository.getServer(server.id))
            .thenAnswer((_) async => server);

        final success = await viewModel.configureClickNLoad(
          ip: '192.168.1.5',
          port: 9666,
          protocol: 'https',
          allowInsecureConnections: true,
        );

        final expected = server.copyWith(clickNLoad: () => clickNLoad);
        expect(success, isTrue);
        verify(mockServerRepository.updateServer(expected)).called(1);
        expect(viewModel.server, expected);
        expect(viewModel.hasClickNLoadConfigured, isTrue);
        expect(server.hasClickNLoad, isFalse);
      });

      test('configureClickNLoad keeps the server if saving fails', () async {
        when(mockServerRepository.getServer(server.id))
            .thenAnswer((_) async => server);
        when(mockServerRepository.updateServer(any))
            .thenThrow(Exception('storage error'));

        final success = await viewModel.configureClickNLoad(
          ip: '192.168.1.5',
          port: 9666,
          protocol: 'https',
          allowInsecureConnections: true,
        );

        expect(success, isFalse);
        expect(viewModel.server, server);
        expect(viewModel.hasClickNLoadConfigured, isFalse);
      });
    });

    group('Click\'N\'Load', () {
      const clickNLoad = ClickNLoadServer(
        ip: '192.168.1.5',
        port: 9666,
        protocol: 'http',
        allowInsecureConnections: false,
      );
      late Server configured;

      setUp(() {
        configured = server.copyWith(clickNLoad: () => clickNLoad);
        when(mockServerRepository.getServer(server.id))
            .thenAnswer((_) async => configured);
        when(mockPyLoadApiRepository.getServerStatus(configured))
            .thenAnswer((_) async => throw Exception('offline'));
      });

      test('starting uses the stored configuration', () async {
        final result = await viewModel.startClickNLoad();

        expect(result, ClickNLoadStartResult.started);
        expect(viewModel.isClickNLoadRunning, isTrue);
        expect(
          clickNLoadController.state,
          ClickNLoadRunning(server.id, clickNLoad),
        );
      });

      test('starting is refused once the configuration was deleted', () async {
        await viewModel.startClickNLoad();
        await clickNLoadController.reconfigure(server.id, null);
        when(mockServerRepository.getServer(server.id))
            .thenAnswer((_) async => server);

        final result = await viewModel.startClickNLoad();

        expect(result, ClickNLoadStartResult.notConfigured);
        expect(viewModel.isClickNLoadRunning, isFalse);
        expect(clickNLoadPlatform.isRunning, isFalse);
      });

      test('starting is refused once the server was removed', () async {
        when(mockServerRepository.getServer(server.id))
            .thenAnswer((_) async => null);
        viewModel.dispose();
        server = configured;
        viewModel = createViewModel();

        final result = await viewModel.startClickNLoad();

        expect(result, ClickNLoadStartResult.notConfigured);
        expect(clickNLoadPlatform.startCount, 0);
      });

      test('starting while running reports already running', () async {
        await viewModel.startClickNLoad();

        final result = await viewModel.startClickNLoad();

        expect(result, ClickNLoadStartResult.alreadyRunning);
        expect(viewModel.isClickNLoadRunning, isTrue);
      });

      test('stopping from the notification updates the view model', () async {
        await viewModel.startClickNLoad();
        var notified = false;
        viewModel.addListener(() => notified = true);

        clickNLoadPlatform.stopFromNotification();
        await pumpEventQueue();

        expect(viewModel.isClickNLoadRunning, isFalse);
        expect(notified, isTrue);
      });

      test('is not running when it forwards for another server', () async {
        final other = configured.copyWith(ip: '192.168.1.2');
        when(mockServerRepository.getServer(other.id))
            .thenAnswer((_) async => other);
        await clickNLoadController.start(other.id);

        expect(viewModel.isClickNLoadRunning, isFalse);
      });

      test('reports whether the platform supports it', () {
        expect(viewModel.isClickNLoadSupported, isTrue);

        viewModel.dispose();
        clickNLoadPlatform = FakeClickNLoadPlatform(isSupported: false);
        clickNLoadController = createClickNLoadController();
        viewModel = createViewModel();

        expect(viewModel.isClickNLoadSupported, isFalse);
      });

      test('leaving the server screen stops it', () async {
        await viewModel.startClickNLoad();

        viewModel.dispose();
        await pumpEventQueue();

        expect(clickNLoadController.state, const ClickNLoadStopped());
        expect(clickNLoadPlatform.isRunning, isFalse);
        viewModel = createViewModel();
      });
    });
  });
}
