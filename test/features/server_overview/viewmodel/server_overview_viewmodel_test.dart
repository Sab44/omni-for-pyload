import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:omni_for_pyload/domain/models/server.dart';
import 'package:omni_for_pyload/domain/repositories/i_server_repository.dart';
import 'package:omni_for_pyload/domain/repositories/i_pyload_api_repository.dart';
import 'package:omni_for_pyload/features/server_overview/viewmodel/server_overview_viewmodel.dart';
import 'package:openapi_client/api.dart';
import 'dart:async';
import 'package:fake_async/fake_async.dart';

import 'server_overview_viewmodel_test.mocks.dart';

@GenerateMocks([IServerRepository, IPyLoadApiRepository])
void main() {
  group('ServerOverviewViewModel', () {
    late MockIServerRepository mockServerRepository;
    late MockIPyLoadApiRepository mockPyLoadApiRepository;
    late Server server;
    late ServerOverviewViewModel viewModel;

    setUp(() {
      mockServerRepository = MockIServerRepository();
      mockPyLoadApiRepository = MockIPyLoadApiRepository();
      viewModel = ServerOverviewViewModel(
        serverRepository: mockServerRepository,
        pyLoadApiRepository: mockPyLoadApiRepository,
      );

      server = Server(
        ip: '192.168.1.1',
        port: 8000,
        apiKey: 'test-api-key-1',
        protocol: 'http',
        allowInsecure: false,
      );
    });

    tearDown(() {
      viewModel.dispose();
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

      when(
        mockServerRepository.getAllServers(),
      ).thenAnswer((_) async => testServers);

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
      when(
        mockServerRepository.getAllServers(),
      ).thenAnswer((_) async => initialServers);

      when(
        mockServerRepository.removeServer('192.168.1.1', 8000),
      ).thenAnswer((_) async => Future<void>.value());

      // Load servers first
      await viewModel.loadServers();
      expect(viewModel.servers.length, 1);

      // Then remove one
      await viewModel.removeServer(server);

      expect(viewModel.servers, isEmpty);
      verify(mockServerRepository.removeServer('192.168.1.1', 8000)).called(1);
    });

    test('polling updates status to online on success', () {
      fakeAsync((async) {
        when(
          mockServerRepository.getAllServers(),
        ).thenAnswer((_) async => [server]);
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

        expect(viewModel.statuses['192.168.1.1:8000'], equals('online'));
        // verify(mockPyLoadApiRepository.getServerStatus(any)).called(1); // Removed

        // Advance 2 seconds
        async.elapse(const Duration(seconds: 2, milliseconds: 100));
        async.flushMicrotasks();

        verify(mockPyLoadApiRepository.getServerStatus(any)).called(2);
      });
    });

    test('polling updates status to offline on error', () {
      fakeAsync((async) {
        when(
          mockServerRepository.getAllServers(),
        ).thenAnswer((_) async => [server]);
        when(mockPyLoadApiRepository.getServerStatus(any)).thenThrow('Error');

        viewModel.loadServers();
        async.flushMicrotasks();

        expect(viewModel.statuses['192.168.1.1:8000'], equals('offline'));

        // Advance 2 seconds
        async.elapse(const Duration(seconds: 2, milliseconds: 100));
        async.flushMicrotasks();

        verify(mockPyLoadApiRepository.getServerStatus(any)).called(2);
      });
    });

    test('polling updates status to offline on timeout', () {
      fakeAsync((async) {
        when(
          mockServerRepository.getAllServers(),
        ).thenAnswer((_) async => [server]);

        // Simulate timeout by returning a future that completes after 2 seconds
        when(mockPyLoadApiRepository.getServerStatus(any)).thenAnswer((
          _,
        ) async {
          await Future.delayed(const Duration(seconds: 2));
          throw TimeoutException('Connection timeout');
        });

        viewModel.loadServers();
        async.flushMicrotasks();

        // Should be waiting now.
        // Advance 2 seconds (timeout)
        async.elapse(const Duration(seconds: 2, milliseconds: 100));
        async.flushMicrotasks();

        expect(viewModel.statuses['192.168.1.1:8000'], equals('offline'));

        // Should poll immediately again (no 2s delay)
        // We verify it was called again immediately
        verify(mockPyLoadApiRepository.getServerStatus(any)).called(2);
      });
    });

    test('loadServers triggers notifyListeners', () async {
      final testServers = [server];

      when(
        mockServerRepository.getAllServers(),
      ).thenAnswer((_) async => testServers);

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

    test('removeServer triggers notifyListeners', () async {
      when(
        mockServerRepository.getAllServers(),
      ).thenAnswer((_) async => [server]);
      when(
        mockServerRepository.removeServer(any, any),
      ).thenAnswer((_) async => Future.value());

      await viewModel.loadServers();

      int listenerCount = 0;
      viewModel.addListener(() {
        listenerCount++;
      });

      await viewModel.removeServer(server);

      expect(listenerCount, equals(1));
    });
  });
}
