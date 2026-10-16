import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:omni_for_pyload/domain/models/clicknload_server.dart';
import 'package:omni_for_pyload/features/click_n_load/services/click_n_load_proxy.dart';

void main() {
  group('ClickNLoadProxy', () {
    const target = ClickNLoadServer(
      ip: '192.168.1.5',
      port: 9667,
      protocol: 'https',
      allowInsecureConnections: false,
    );

    late List<http.Request> upstreamRequests;
    late ClickNLoadProxy proxy;
    late Uri proxyUri;

    Future<void> startProxy(MockClientHandler upstream) async {
      proxy = ClickNLoadProxy(
        target: target,
        client: MockClient((request) {
          upstreamRequests.add(request);
          return upstream(request);
        }),
        port: 0,
      );
      await proxy.start();
      proxyUri = Uri.parse('http://127.0.0.1:${proxy.boundPort}');
    }

    setUp(() => upstreamRequests = []);
    tearDown(() => proxy.stop());

    test('answers jdcheck.js itself', () async {
      await startProxy((_) async => http.Response('unexpected', 404));

      final response = await http.get(proxyUri.resolve('/jdcheck.js'));

      expect(response.statusCode, 200);
      expect(response.body, "jdownloader=true;\r\nvar version='42707';\r\n");
      expect(response.headers['content-type'], 'application/javascript');
      expect(upstreamRequests, isEmpty);
    });

    for (final (method, path) in [
      ('GET', '/flash/'),
      ('POST', '/flash/'),
      ('POST', '/flash/add'),
      ('POST', '/flash/addcrypted'),
      ('POST', '/flash/addcrypted2'),
    ]) {
      test('forwards $method $path to the target', () async {
        await startProxy(
          (_) async => http.Response(
            'upstream says hi',
            201,
            headers: {'x-upstream': 'yes'},
          ),
        );

        final request = http.Request(method, proxyUri.resolve(path))
          ..headers['referer'] = 'https://example.com/'
          ..body = method == 'POST' ? 'urls=http://a.example/file' : '';
        final response = await http.Response.fromStream(await request.send());

        expect(response.statusCode, 201);
        expect(response.body, 'upstream says hi');
        expect(response.headers['x-upstream'], 'yes');

        final upstream = upstreamRequests.single;
        expect(upstream.method, method);
        expect(upstream.url, Uri.parse('https://192.168.1.5:9667$path'));
        expect(upstream.headers['referer'], 'https://example.com/');
        expect(upstream.headers.containsKey('host'), isFalse);
        if (method == 'POST') {
          expect(upstream.body, 'urls=http://a.example/file');
        }
      });
    }

    test('does not forward unknown paths', () async {
      await startProxy((_) async => http.Response('unexpected', 200));

      final response = await http.get(proxyUri.resolve('/somewhere'));

      expect(response.statusCode, 404);
      expect(upstreamRequests, isEmpty);
    });

    test('answers 500 if the target cannot be reached', () async {
      await startProxy((_) async => throw http.ClientException('refused'));

      final response = await http.post(
        proxyUri.resolve('/flash/add'),
        body: 'urls=http://a.example/file',
      );

      expect(response.statusCode, 500);
      expect(response.body, contains('Error forwarding request'));
    });
  });
}
