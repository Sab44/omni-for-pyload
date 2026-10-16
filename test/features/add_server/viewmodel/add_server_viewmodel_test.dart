import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:omni_for_pyload/domain/models/clicknload_server.dart';
import 'package:omni_for_pyload/domain/models/server.dart';
import 'package:omni_for_pyload/domain/models/server_id.dart';
import 'package:omni_for_pyload/domain/repositories/i_local_network_repository.dart';
import 'package:omni_for_pyload/domain/repositories/i_pyload_api_repository.dart';
import 'package:omni_for_pyload/domain/repositories/i_server_repository.dart';
import 'package:omni_for_pyload/features/add_server/viewmodel/add_server_viewmodel.dart';
import 'package:openapi_client/api.dart';

import 'add_server_viewmodel_test.mocks.dart';

@GenerateMocks([
  IServerRepository,
  IPyLoadApiRepository,
  ILocalNetworkRepository,
])
void main() {
  group('AddServerViewModel', () {
    late MockIServerRepository mockServerRepository;
    late MockIPyLoadApiRepository mockPyLoadApiRepository;
    late MockILocalNetworkRepository mockLocalNetworkRepository;
    late AddServerViewModel viewModel;

    setUp(() {
      mockServerRepository = MockIServerRepository();
      mockPyLoadApiRepository = MockIPyLoadApiRepository();
      mockLocalNetworkRepository = MockILocalNetworkRepository();
      when(mockLocalNetworkRepository.isAccessDenied(any))
          .thenAnswer((_) async => false);
      viewModel = AddServerViewModel(
        serverRepository: mockServerRepository,
        pyLoadApiRepository: mockPyLoadApiRepository,
        localNetworkRepository: mockLocalNetworkRepository,
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
          mockServerRepository.serverExists(
            const ServerId('192.168.1.1', 8000),
          ),
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
          mockServerRepository.serverExists(
            const ServerId('192.168.1.1', 8000),
          ),
        ).called(1);
      },
    );

    test(
      'validateAndAddServer calls getServerStatus and addServer on success',
      () async {
        when(
          mockServerRepository.serverExists(
            const ServerId('192.168.1.1', 8000),
          ),
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
          mockServerRepository.serverExists(
            const ServerId('192.168.1.1', 8000),
          ),
        ).called(1);
        verify(mockPyLoadApiRepository.getServerStatus(any)).called(1);
        verify(mockServerRepository.addServer(any)).called(1);
      },
    );

    test('validateAndAddServer defaults name to pyLoad when empty', () async {
      when(
        mockServerRepository.serverExists(const ServerId('192.168.1.1', 8000)),
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

      verify(
        mockServerRepository.serverExists(const ServerId('192.168.1.1', 8000)),
      ).called(1);
    });

    test(
      'validateAndAddServer defaults name to pyLoad when only whitespace',
      () async {
        when(
          mockServerRepository.serverExists(
            const ServerId('192.168.1.1', 8000),
          ),
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
          mockServerRepository.serverExists(
            const ServerId('192.168.1.1', 8000),
          ),
        ).called(1);
      },
    );

    test('validateAndAddServer trims server name', () async {
      when(
        mockServerRepository.serverExists(const ServerId('192.168.1.1', 8000)),
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
          mockServerRepository.serverExists(
            const ServerId('192.168.1.1', 8000),
          ),
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

    test(
      'validateAndAddServer throws LocalNetworkAccessDeniedException '
      'without testing the connection when local network access is denied',
      () async {
        when(
          mockServerRepository.serverExists(
            const ServerId('192.168.1.1', 8000),
          ),
        ).thenAnswer((_) async => false);
        when(mockLocalNetworkRepository.isAccessDenied(any))
            .thenAnswer((_) async => true);

        await expectLater(
          viewModel.validateAndAddServer(
            name: 'Test Server',
            ip: '192.168.1.1',
            port: '8000',
            apiKey: 'test-api-key',
            protocol: 'http',
            allowInsecureConnections: false,
          ),
          throwsA(isA<LocalNetworkAccessDeniedException>()),
        );
        verifyNever(mockPyLoadApiRepository.getServerStatus(any));
        verifyNever(mockServerRepository.addServer(any));
      },
    );

    test('openAppSettings opens the app settings', () async {
      when(mockLocalNetworkRepository.openAppSettings())
          .thenAnswer((_) async {});

      await viewModel.openAppSettings();

      verify(mockLocalNetworkRepository.openAppSettings()).called(1);
    });

    group('validateAndUpdateServer', () {
      late Server original;

      setUp(() {
        original = Server(
          ip: '192.168.1.1',
          port: 8000,
          apiKey: 'old-key',
          protocol: 'http',
          allowInsecure: false,
          name: 'Home',
          clickNLoad: const ClickNLoadServer(
            ip: '192.168.1.1',
            port: 9666,
            protocol: 'http',
            allowInsecureConnections: false,
          ),
        );
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
      });

      Future<Server> update({
        String name = 'Home',
        String ip = '192.168.1.1',
        String port = '8000',
        String apiKey = 'old-key',
        String protocol = 'http',
        bool allowInsecureConnections = false,
      }) => viewModel.validateAndUpdateServer(
        original: original,
        name: name,
        ip: ip,
        port: port,
        apiKey: apiKey,
        protocol: protocol,
        allowInsecureConnections: allowInsecureConnections,
      );

      test(
        'returns the original without saving when nothing changed',
        () async {
          final result = await update();

          expect(result, same(original));
          verifyNever(mockPyLoadApiRepository.getServerStatus(any));
          verifyNever(mockServerRepository.replaceServer(any, any));
        },
      );

      test(
        'saves changes and keeps the Click\'N\'Load configuration',
        () async {
          final result = await update(
            name: 'Office',
            apiKey: 'new-key',
            protocol: 'https',
            allowInsecureConnections: true,
          );

          expect(result.name, 'Office');
          expect(result.apiKey, 'new-key');
          expect(result.protocol, 'https');
          expect(result.allowInsecure, isTrue);
          expect(result.clickNLoad, original.clickNLoad);
          verify(mockPyLoadApiRepository.getServerStatus(result)).called(1);
          verify(mockServerRepository.replaceServer(original.id, result))
              .called(1);
        },
      );

      test(
        'does not check for duplicates when IP and port are unchanged',
        () async {
          await update(name: 'Office');

          verifyNever(mockServerRepository.serverExists(any));
        },
      );

      test('rejects an IP and port used by another server', () async {
        when(
          mockServerRepository.serverExists(
            const ServerId('192.168.1.2', 8000),
          ),
        ).thenAnswer((_) async => true);

        await expectLater(
          update(ip: '192.168.1.2'),
          throwsA(contains('A server with this IP and port already exists')),
        );
        verifyNever(mockServerRepository.replaceServer(any, any));
      });

      test('accepts a new IP and port that is not in use', () async {
        when(
          mockServerRepository.serverExists(
            const ServerId('192.168.1.2', 8080),
          ),
        ).thenAnswer((_) async => false);

        final result = await update(ip: '192.168.1.2', port: '8080');

        expect(result.ip, '192.168.1.2');
        expect(result.port, 8080);
        verify(mockServerRepository.replaceServer(original.id, result))
            .called(1);
      });

      test('applies the same field validation as adding', () async {
        await expectLater(update(ip: ''), throwsA(contains('IP or hostname')));
        await expectLater(update(port: '0'), throwsA(contains('between 1')));
        await expectLater(update(apiKey: ''), throwsA(contains('API Key')));
        verifyNever(mockServerRepository.replaceServer(any, any));
      });

      test('does not save when local network access is denied', () async {
        when(mockLocalNetworkRepository.isAccessDenied(any))
            .thenAnswer((_) async => true);

        await expectLater(
          update(apiKey: 'new-key'),
          throwsA(isA<LocalNetworkAccessDeniedException>()),
        );
        verifyNever(mockPyLoadApiRepository.getServerStatus(any));
        verifyNever(mockServerRepository.replaceServer(any, any));
      });

      test('does not save when the connection test fails', () async {
        when(mockPyLoadApiRepository.getServerStatus(any))
            .thenThrow(ApiException(401, 'Authentication failed'));

        await expectLater(
          update(apiKey: 'wrong-key'),
          throwsA(isA<ApiException>()),
        );
        verifyNever(mockServerRepository.replaceServer(any, any));
      });
    });
    group('QR code', () {
      const qrCode =
          'http://localhost:8000/qr-redirector#host=localhost&port=8000'
          '&path=&ssl=false&key=pl_test-key';

      test('parseQrCode extracts the server configuration', () {
        final config = AddServerViewModel.parseQrCode(qrCode);

        expect(config.host, 'localhost');
        expect(config.port, '8000');
        expect(config.path, '');
        expect(config.ssl, false);
        expect(config.apiKey, 'pl_test-key');
      });

      test('parseQrCode handles ssl and a path prefix', () {
        final config = AddServerViewModel.parseQrCode(
          'https://example.com:443/pyload/qr-redirector'
          '#host=example.com&port=443&path=/pyload&ssl=true&key=abc',
        );

        expect(config.ssl, true);
        expect(config.path, 'pyload');
      });

      test('parseQrCode rejects other QR codes', () {
        for (final code in [
          'some text',
          'https://example.com/',
          'http://localhost:8000/qr-redirector',
          'http://localhost:8000/qr-redirector#host=localhost&port=8000',
        ]) {
          expect(
            () => AddServerViewModel.parseQrCode(code),
            throwsA(contains('not a valid pyLoad server QR code')),
            reason: code,
          );
        }
      });

      test(
        'addServerFromQrCode tests the connection and adds the server',
        () async {
          when(
            mockServerRepository.serverExists(
              const ServerId('localhost', 8000),
            ),
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

          final server = await viewModel.addServerFromQrCode(qrCode);

          expect(server.ip, 'localhost');
          expect(server.port, 8000);
          expect(server.apiKey, 'pl_test-key');
          expect(server.protocol, 'http');
          expect(server.allowInsecure, false);
          verify(mockPyLoadApiRepository.getServerStatus(any)).called(1);
          verify(mockServerRepository.addServer(any)).called(1);
        },
      );

      test(
        'addServerFromQrCode does not add the server if connection fails',
        () async {
          when(
            mockServerRepository.serverExists(
              const ServerId('localhost', 8000),
            ),
          ).thenAnswer((_) async => false);
          when(mockPyLoadApiRepository.getServerStatus(any))
              .thenThrow(ApiException(401, 'Unauthorized'));

          await expectLater(
            viewModel.addServerFromQrCode(qrCode),
            throwsA(isA<ApiException>()),
          );
          verifyNever(mockServerRepository.addServer(any));
        },
      );

      test('addServerFromQrCode rejects a path prefix', () async {
        await expectLater(
          viewModel.addServerFromQrCode(
            'http://localhost:8000/pyload/qr-redirector'
            '#host=localhost&port=8000&path=pyload&ssl=false&key=abc',
          ),
          throwsA(contains('path prefix')),
        );
        verifyNever(mockPyLoadApiRepository.getServerStatus(any));
        verifyNever(mockServerRepository.addServer(any));
      });
    });
  });
}
