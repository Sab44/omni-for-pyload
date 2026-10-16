import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:omni_for_pyload/data/repositories/pyload_api_repository.dart';
import 'package:omni_for_pyload/domain/models/pyload_api_failure.dart';
import 'package:omni_for_pyload/domain/models/server.dart';
import 'package:omni_for_pyload/domain/repositories/i_pyload_api_repository.dart';
import 'package:openapi_client/api.dart';

void main() {
  const server = Server(
    ip: '192.168.1.10',
    port: 8000,
    apiKey: 'key',
    protocol: 'http',
    allowInsecure: false,
  );

  PyLoadApiRepository repositoryWith(MockClientHandler handler) =>
      PyLoadApiRepository(createClient: (_) => MockClient(handler));

  group('failures', () {
    test('401 fails with unauthorized', () async {
      final repository = repositoryWith(
        (_) async => http.Response('Unauthorized', 401),
      );

      expect(
        repository.getServerStatus(server),
        throwsA(isA<PyLoadApiUnauthorized>()),
      );
    });

    test('5xx fails with server error carrying the status code', () async {
      final repository = repositoryWith(
        (_) async => http.Response('Internal Server Error', 503),
      );

      await expectLater(
        repository.getServerStatus(server),
        throwsA(
          isA<PyLoadApiServerError>().having((f) => f.statusCode, 'code', 503),
        ),
      );
    });

    test('slow response fails with timeout', () async {
      final repository = PyLoadApiRepository(
        createClient: (_) => MockClient((_) async {
          await Future.delayed(const Duration(milliseconds: 200));
          return http.Response('{}', 200);
        }),
        timeout: const Duration(milliseconds: 10),
      );

      await expectLater(
        repository.getServerStatus(server),
        throwsA(isA<PyLoadApiTimeout>()),
      );
    });

    test('connection error fails with unreachable', () async {
      final repository = repositoryWith(
        (_) async => throw http.ClientException('Connection refused'),
      );

      await expectLater(
        repository.getServerStatus(server),
        throwsA(isA<PyLoadApiUnreachable>()),
      );
    });

    test('missing body fails with bad response', () async {
      final repository = repositoryWith((_) async => http.Response('', 200));

      await expectLater(
        repository.getServerStatus(server),
        throwsA(isA<PyLoadApiBadResponse>()),
      );
      await expectLater(
        repository.getPackageData(server, 1),
        throwsA(isA<PyLoadApiBadResponse>()),
      );
      await expectLater(
        repository.addPackage(server, 'name', ['link'], Destination.QUEUE),
        throwsA(isA<PyLoadApiBadResponse>()),
      );
    });

    test('malformed body fails with bad response', () async {
      final repository = repositoryWith(
        (_) async => http.Response('not json', 200),
      );

      await expectLater(
        repository.getServerStatus(server),
        throwsA(isA<PyLoadApiBadResponse>()),
      );
    });
  });

  group('wrongly shaped body', () {
    for (final body in ['[1]', '"text"', '{"pause": 3}']) {
      test('$body fails with bad response', () async {
        final repository = repositoryWith(
          (_) async => http.Response(body, 200),
        );

        await expectLater(
          repository.getServerStatus(server),
          throwsA(isA<PyLoadApiBadResponse>()),
        );
        await expectLater(
          repository.getQueue(server),
          throwsA(isA<PyLoadApiBadResponse>()),
        );
      });
    }
  });

  group('bulk actions', () {
    /// Fails every request that concerns package 2
    PyLoadApiRepository failingForPackage2() => repositoryWith((request) async {
      final concernsPackage2 =
          request.url.queryParameters['package_id'] == '2' ||
          request.body.contains('[2]');
      return concernsPackage2
          ? http.Response('error', 500)
          : http.Response('', 200);
    });

    test('restart reports partial if some packages fail', () async {
      expect(
        await failingForPackage2().restartPackages(server, [1, 2]),
        Result.partial,
      );
    });

    test('move reports partial if some packages fail', () async {
      expect(
        await failingForPackage2().movePackages(server, [
          1,
          2,
        ], Destination.COLLECTOR),
        Result.partial,
      );
    });

    test('extract reports partial if some packages fail', () async {
      expect(
        await failingForPackage2().extractPackages(server, [1, 2]),
        Result.partial,
      );
    });

    test('reports success if all and failure if no package succeeds', () async {
      final repository = failingForPackage2();

      expect(await repository.restartPackages(server, [1, 3]), Result.success);
      expect(await repository.extractPackages(server, [2]), Result.failure);
    });
  });

  group('connections', () {
    late List<_TrackingClient> clients;
    late List<bool> insecureFlags;
    late PyLoadApiRepository repository;

    setUp(() {
      clients = [];
      insecureFlags = [];
      repository = PyLoadApiRepository(
        createClient: (allowInsecure) {
          insecureFlags.add(allowInsecure);
          final client = _TrackingClient();
          clients.add(client);
          return client;
        },
      );
    });

    test(
      'repeated calls for several servers reuse their connections',
      () async {
        final other = server.copyWith(ip: '192.168.1.11');

        for (var i = 0; i < 3; i++) {
          await repository.getDownloadStatus(server);
          await repository.getDownloadStatus(other);
        }

        expect(clients, hasLength(2));
        expect(clients.where((c) => c.isClosed), isEmpty);
      },
    );

    test('changed API key or TLS setting replaces and closes the old '
        'connection', () async {
      await repository.getDownloadStatus(server);
      await repository.getDownloadStatus(server.copyWith(apiKey: 'new key'));
      await repository.getDownloadStatus(
        server.copyWith(apiKey: 'new key', allowInsecure: true),
      );

      expect(clients, hasLength(3));
      expect(insecureFlags, [false, false, true]);
      expect(clients.map((c) => c.isClosed), [true, true, false]);
    });

    test('a replaced connection is closed only after its running requests '
        'finished', () async {
      final response = Completer<void>();
      final slowRepository = PyLoadApiRepository(
        createClient: (_) {
          final client = _TrackingClient(beforeResponse: response.future);
          clients.add(client);
          return client;
        },
      );

      final running = slowRepository.getDownloadStatus(server);
      await Future.delayed(Duration.zero);
      final replacing = slowRepository.getDownloadStatus(
        server.copyWith(apiKey: 'new key'),
      );
      await Future.delayed(Duration.zero);
      expect(clients.first.isClosed, isFalse);

      response.complete();
      await expectLater(running, completion(isEmpty));
      await replacing;
      expect(clients.map((c) => c.isClosed), [true, false]);
    });

    test('changed host or port creates a new connection', () async {
      await repository.getDownloadStatus(server);
      await repository.getDownloadStatus(server.copyWith(ip: 'pyload.local'));
      await repository.getDownloadStatus(server.copyWith(port: 9000));

      expect(clients, hasLength(3));
      expect(clients.map((c) => c.requestedUrls.single.authority), [
        '192.168.1.10:8000',
        'pyload.local:8000',
        '192.168.1.10:9000',
      ]);
    });

    test('sends the API key of the current server', () async {
      await repository.getDownloadStatus(server.copyWith(apiKey: 'secret'));

      expect(clients.single.apiKeys, ['secret']);
    });
  });
}

/// Answers every request with an empty list and records what was sent
class _TrackingClient extends http.BaseClient {
  /// Responses are held back until this completes
  final Future<void>? beforeResponse;
  final requestedUrls = <Uri>[];
  final apiKeys = <String?>[];
  bool isClosed = false;

  _TrackingClient({this.beforeResponse});

  late final _inner = MockClient((request) async {
    requestedUrls.add(request.url);
    await beforeResponse;
    apiKeys.add(request.headers['X-API-Key']);
    return http.Response('[]', 200);
  });

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (isClosed) throw StateError('Client used after close');
    final response = await _inner.send(request);
    // Like IOClient, closing aborts responses that are still being read
    return http.StreamedResponse(
      response.stream.map((chunk) {
        if (isClosed) throw http.ClientException('Connection closed');
        return chunk;
      }),
      response.statusCode,
      headers: response.headers,
    );
  }

  @override
  void close() => isClosed = true;
}
