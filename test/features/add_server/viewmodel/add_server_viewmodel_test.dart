import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:omni_for_pyload/domain/repositories/i_pyload_api_repository.dart';
import 'package:omni_for_pyload/domain/repositories/i_server_repository.dart';
import 'package:omni_for_pyload/features/add_server/viewmodel/add_server_viewmodel.dart';
import 'package:openapi_client/api.dart';

import 'add_server_viewmodel_test.mocks.dart';

@GenerateMocks([IServerRepository, IPyLoadApiRepository])
void main() {
  group('AddServerViewModel', () {
    late MockIServerRepository mockServerRepository;
    late MockIPyLoadApiRepository mockPyLoadApiRepository;
    late AddServerViewModel viewModel;

    setUp(() {
      mockServerRepository = MockIServerRepository();
      mockPyLoadApiRepository = MockIPyLoadApiRepository();
      viewModel = AddServerViewModel(
        serverRepository: mockServerRepository,
        pyLoadApiRepository: mockPyLoadApiRepository,
      );
    });

    test('validateAndAddServer throws error when IP is empty', () async {
      expect(
        () => viewModel.validateAndAddServer(
          name: 'Test Server',
          ip: '',
          port: '8000',
          apiKey: 'test-api-key',
          protocol: 'http',
          allowInsecureConnections: false,
        ),
        throwsA(
          isA<String>().having(
            (msg) => msg,
            'message',
            contains('IP or hostname is required'),
          ),
        ),
      );
    });

    test('validateAndAddServer throws error when port is invalid', () async {
      expect(
        () => viewModel.validateAndAddServer(
          name: 'Test Server',
          ip: '192.168.1.1',
          port: 'invalid',
          apiKey: 'test-api-key',
          protocol: 'http',
          allowInsecureConnections: false,
        ),
        throwsA(
          isA<String>().having(
            (msg) => msg,
            'message',
            contains('Port must be a valid number'),
          ),
        ),
      );
    });

    test(
      'validateAndAddServer throws error when port is out of range',
      () async {
        expect(
          () => viewModel.validateAndAddServer(
            name: 'Test Server',
            ip: '192.168.1.1',
            port: '99999',
            apiKey: 'test-api-key',
            protocol: 'http',
            allowInsecureConnections: false,
          ),
          throwsA(
            isA<String>().having(
              (msg) => msg,
              'message',
              contains('Port must be between 1 and 65535'),
            ),
          ),
        );
      },
    );

    test('validateAndAddServer throws error when apiKey is empty', () async {
      expect(
        () => viewModel.validateAndAddServer(
          name: 'Test Server',
          ip: '192.168.1.1',
          port: '8000',
          apiKey: '',
          protocol: 'http',
          allowInsecureConnections: false,
        ),
        throwsA(
          isA<String>().having(
            (msg) => msg,
            'message',
            contains('API Key is required'),
          ),
        ),
      );
    });

    test(
      'validateAndAddServer throws error when server already exists',
      () async {
        when(
          mockServerRepository.serverExists('192.168.1.1', 8000),
        ).thenAnswer((_) async => true);

        expect(
          () => viewModel.validateAndAddServer(
            name: 'Test Server',
            ip: '192.168.1.1',
            port: '8000',
            apiKey: 'test-api-key',
            protocol: 'http',
            allowInsecureConnections: false,
          ),
          throwsA(
            isA<String>().having(
              (msg) => msg,
              'message',
              contains('A server with this IP and port already exists'),
            ),
          ),
        );

        verify(
          mockServerRepository.serverExists('192.168.1.1', 8000),
        ).called(1);
      },
    );

    test(
      'validateAndAddServer calls getServerStatus and addServer on success',
      () async {
        when(
          mockServerRepository.serverExists('192.168.1.1', 8000),
        ).thenAnswer((_) async => false);

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

        final server = await viewModel.validateAndAddServer(
          name: 'Test Server',
          ip: '192.168.1.1',
          port: '8000',
          apiKey: 'test-api-key',
          protocol: 'https',
          allowInsecureConnections: true,
        );

        expect(server.ip, '192.168.1.1');
        expect(server.port, 8000);
        expect(server.apiKey, 'test-api-key');
        expect(server.protocol, 'https');
        expect(server.allowInsecure, true);
        expect(server.name, 'Test Server');

        verify(
          mockServerRepository.serverExists('192.168.1.1', 8000),
        ).called(1);
        verify(mockPyLoadApiRepository.getServerStatus(any)).called(1);
        verify(mockServerRepository.addServer(any)).called(1);
      },
    );

    test('validateAndAddServer defaults name to pyLoad when empty', () async {
      when(
        mockServerRepository.serverExists('192.168.1.1', 8000),
      ).thenAnswer((_) async => false);

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

      final server = await viewModel.validateAndAddServer(
        name: '',
        ip: '192.168.1.1',
        port: '8000',
        apiKey: 'test-api-key',
        protocol: 'http',
        allowInsecureConnections: false,
      );

      expect(server.name, 'pyLoad');
      expect(server.ip, '192.168.1.1');
      expect(server.port, 8000);

      verify(mockServerRepository.serverExists('192.168.1.1', 8000)).called(1);
    });

    test(
      'validateAndAddServer defaults name to pyLoad when only whitespace',
      () async {
        when(
          mockServerRepository.serverExists('192.168.1.1', 8000),
        ).thenAnswer((_) async => false);

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

        final server = await viewModel.validateAndAddServer(
          name: '   ',
          ip: '192.168.1.1',
          port: '8000',
          apiKey: 'test-api-key',
          protocol: 'http',
          allowInsecureConnections: false,
        );

        expect(server.name, 'pyLoad');
        expect(server.ip, '192.168.1.1');
        expect(server.port, 8000);

        verify(
          mockServerRepository.serverExists('192.168.1.1', 8000),
        ).called(1);
      },
    );

    test('validateAndAddServer trims server name', () async {
      when(
        mockServerRepository.serverExists('192.168.1.1', 8000),
      ).thenAnswer((_) async => false);

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

      final server = await viewModel.validateAndAddServer(
        name: '  My Server  ',
        ip: '192.168.1.1',
        port: '8000',
        apiKey: 'test-api-key',
        protocol: 'http',
        allowInsecureConnections: false,
      );

      expect(server.name, 'My Server');
    });

    test(
      'validateAndAddServer verifies server connection before adding',
      () async {
        when(
          mockServerRepository.serverExists('192.168.1.1', 8000),
        ).thenAnswer((_) async => false);

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

        await viewModel.validateAndAddServer(
          name: 'Test Server',
          ip: '192.168.1.1',
          port: '8000',
          apiKey: 'test-api-key',
          protocol: 'http',
          allowInsecureConnections: false,
        );

        // Verify both getServerStatus and addServer were called
        verify(mockPyLoadApiRepository.getServerStatus(any)).called(1);
        verify(mockServerRepository.addServer(any)).called(1);
      },
    );

    test('validateAndAddServer throws when port is 0', () async {
      expect(
        () => viewModel.validateAndAddServer(
          name: 'Test Server',
          ip: '192.168.1.1',
          port: '0',
          apiKey: 'test-api-key',
          protocol: 'http',
          allowInsecureConnections: false,
        ),
        throwsA(
          isA<String>().having(
            (msg) => msg,
            'message',
            contains('Port must be between 1 and 65535'),
          ),
        ),
      );
    });

    test('validateAndAddServer throws when port is 65536', () async {
      expect(
        () => viewModel.validateAndAddServer(
          name: 'Test Server',
          ip: '192.168.1.1',
          port: '65536',
          apiKey: 'test-api-key',
          protocol: 'http',
          allowInsecureConnections: false,
        ),
        throwsA(
          isA<String>().having(
            (msg) => msg,
            'message',
            contains('Port must be between 1 and 65535'),
          ),
        ),
      );
    });
  });
}
