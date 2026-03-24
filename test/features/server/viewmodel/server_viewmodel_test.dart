import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:omni_for_pyload/domain/models/server.dart';
import 'package:omni_for_pyload/domain/repositories/i_pyload_api_repository.dart';
import 'package:omni_for_pyload/domain/repositories/i_server_repository.dart';
import 'package:omni_for_pyload/features/server/viewmodel/server_viewmodel.dart';
import 'package:openapi_client/api.dart';

import 'server_viewmodel_test.mocks.dart';

@GenerateMocks([IPyLoadApiRepository, IServerRepository])
void main() {
  group('ServerViewModel', () {
    late MockIPyLoadApiRepository mockPyLoadApiRepository;
    late MockIServerRepository mockServerRepository;
    late Server server;
    late ServerViewModel viewModel;

    setUp(() {
      mockPyLoadApiRepository = MockIPyLoadApiRepository();
      mockServerRepository = MockIServerRepository();
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

      viewModel = ServerViewModel(
        server: server,
        pyLoadApiRepository: mockPyLoadApiRepository,
        serverRepository: mockServerRepository,
      );
    });

    tearDown(() {
      viewModel.dispose();
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
      when(
        mockPyLoadApiRepository.getDownloadStatus(server),
      ).thenAnswer((_) async => []);
      when(
        mockPyLoadApiRepository.getQueue(server),
      ).thenAnswer((_) async => []);
      when(
        mockPyLoadApiRepository.getCollector(server),
      ).thenAnswer((_) async => []);

      // Tab 0 (Overview) - already selected by default, but let's verify behavior
      viewModel.setSelectedTab(0);
      expect(viewModel.selectedTabIndex, 0);
      verify(
        mockPyLoadApiRepository.getDownloadStatus(server),
      ).called(greaterThan(0));

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

    test(
      'deleteSelectedPackages calls repository and clears selection',
      () async {
        viewModel.toggleSelection(1);
        viewModel.toggleSelection(2);

        when(
          mockPyLoadApiRepository.deletePackages(server, [1, 2]),
        ).thenAnswer((_) async => {});
        // Mock getDownloadStatus because setSelectedTab(0) is called after delete
        when(
          mockPyLoadApiRepository.getDownloadStatus(server),
        ).thenAnswer((_) async => []);

        final result = await viewModel.deleteSelectedPackages();

        expect(result, true);
        verify(
          mockPyLoadApiRepository.deletePackages(server, [1, 2]),
        ).called(1);
        expect(viewModel.selectedPackageIds, isEmpty);
      },
    );

    test(
      'restartSelectedPackages calls repository and clears selection',
      () async {
        viewModel.toggleSelection(1);

        when(
          mockPyLoadApiRepository.restartPackages(server, [1]),
        ).thenAnswer((_) async => Result.success);
        when(
          mockPyLoadApiRepository.getDownloadStatus(server),
        ).thenAnswer((_) async => []);

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

        when(
          mockPyLoadApiRepository.getCollector(server),
        ).thenAnswer((_) async => []);
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

      when(
        mockPyLoadApiRepository.extractPackages(server, [1]),
      ).thenAnswer((_) async => Result.success);
      when(
        mockPyLoadApiRepository.getDownloadStatus(server),
      ).thenAnswer((_) async => []);

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

      final pausedViewModel = ServerViewModel(
        server: server,
        pyLoadApiRepository: mockPyLoadApiRepository,
        serverRepository: mockServerRepository,
      );

      // Allow the constructor's async fetch to complete
      await Future.delayed(Duration.zero);

      when(
        mockPyLoadApiRepository.unpauseServer(server),
      ).thenAnswer((_) async => true);

      final result = await pausedViewModel.resumeQueue();

      expect(result, true);
      verify(mockPyLoadApiRepository.unpauseServer(server)).called(1);
      pausedViewModel.dispose();
    });

    test('pauseQueue calls pauseServer', () async {
      // Initial state is not paused (from setUp), so pauseQueue should proceed.

      // Wait for initial fetch to populate _serverStatus (pause: false)
      await Future.delayed(Duration.zero);

      when(
        mockPyLoadApiRepository.pauseServer(server),
      ).thenAnswer((_) async => true);
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
      when(
        mockPyLoadApiRepository.stopAllDownloads(server),
      ).thenAnswer((_) async => []);

      final result = await viewModel.stopQueue();

      expect(result, true);
      verify(mockPyLoadApiRepository.stopAllDownloads(server)).called(1);
    });

    test('clearFinished calls deleteFinished', () async {
      when(
        mockPyLoadApiRepository.deleteFinished(server),
      ).thenAnswer((_) async => []);
      when(
        mockPyLoadApiRepository.getDownloadStatus(server),
      ).thenAnswer((_) async => []);

      final result = await viewModel.clearFinished();

      expect(result, true);
      verify(mockPyLoadApiRepository.deleteFinished(server)).called(1);
    });

    test('restartFailed calls restartFailed', () async {
      when(
        mockPyLoadApiRepository.restartFailed(server),
      ).thenAnswer((_) async => []);
      when(
        mockPyLoadApiRepository.getDownloadStatus(server),
      ).thenAnswer((_) async => []);

      final result = await viewModel.restartFailed();

      expect(result, true);
      verify(mockPyLoadApiRepository.restartFailed(server)).called(1);
    });

    test('uploadDlc calls uploadContainer', () async {
      final bytes = [1, 2, 3];
      when(
        mockPyLoadApiRepository.uploadContainer(server, 'test.dlc', bytes),
      ).thenAnswer((_) async => {});

      // If tab is 2 (Collector), it refreshes
      viewModel.setSelectedTab(2);
      when(
        mockPyLoadApiRepository.getCollector(server),
      ).thenAnswer((_) async => []);

      final result = await viewModel.uploadDlc('test.dlc', bytes);

      expect(result, true);
      verify(
        mockPyLoadApiRepository.uploadContainer(server, 'test.dlc', bytes),
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
      when(
        mockPyLoadApiRepository.getQueue(server),
      ).thenAnswer((_) async => []);

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
      when(
        mockPyLoadApiRepository.getQueue(server),
      ).thenAnswer((_) async => []);

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
      verify(
        mockPyLoadApiRepository.setPackagePassword(server, 123, 's3cret'),
      ).called(1);
      // Verify refresh happened (called twice: once for tab select, once for addPackage refresh)
      verify(mockPyLoadApiRepository.getQueue(server)).called(2);
    });
  });
}
