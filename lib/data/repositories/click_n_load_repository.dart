import 'package:http/http.dart' as http;
import 'package:omni_for_pyload/core/utils/http_client_factory.dart';
import 'package:omni_for_pyload/domain/models/clicknload_server.dart';
import 'package:omni_for_pyload/domain/repositories/i_click_n_load_repository.dart';

class ClickNLoadRepository implements IClickNLoadRepository {
  final http.Client _client;
  final ClickNLoadServer _server;

  factory ClickNLoadRepository(ClickNLoadServer clicknloadserver) {
    http.Client initClient = HttpClientFactory.createClient(
      clicknloadserver.allowInsecureConnections,
    );
    return ClickNLoadRepository._internal(clicknloadserver, initClient);
  }

  ClickNLoadRepository._internal(this._server, this._client);

  Future<http.Response> _forward(
    String path, {
    String method = 'GET',
    Map<String, String>? headers,
    Object? body,
  }) async {
    final uri = Uri.parse(
      '${_server.protocol}://${_server.ip}:${_server.port}$path',
    );

    // Filter headers if necessary, but for now forward most
    // We might want to remove 'host' or 'content-length' as the client will set them
    final forwardedHeaders = Map<String, String>.from(headers ?? {});
    forwardedHeaders.remove('host');
    forwardedHeaders.remove('content-length');

    print('Forwarding $method request to $uri');
    if (body != null) {
      print('Body: $body');
    }

    final request = http.Request(method, uri);
    request.headers.addAll(forwardedHeaders);

    if (body is String) {
      request.body = body;
    } else if (body is List<int>) {
      request.bodyBytes = body;
    }

    try {
      final streamedResponse = await _client.send(request);
      final originalResponse = await http.Response.fromStream(streamedResponse);
      Map<String, String> adaptedHeaders = originalResponse.headers;
      adaptedHeaders["content-length"] = "${originalResponse.bodyBytes.length}";

      http.Response response = http.Response(
        originalResponse.body,
        originalResponse.statusCode,
        request: http.Request(method, Uri.parse("http://127.0.0.1/$path")),
        headers: adaptedHeaders,
        isRedirect: originalResponse.isRedirect,
        persistentConnection: originalResponse.persistentConnection,
        reasonPhrase: originalResponse.reasonPhrase,
      );

      return response;
    } catch (e) {
      print('Error forwarding request: $e');
      // Return a 500 if forwarding fails
      return http.Response('Error forwarding request: $e', 500);
    }
  }

  @override
  Future<http.Response> index({
    String? id,
    String? method,
    Map<String, String>? headers,
    Object? body,
  }) {
    final path = id != null ? '/flash/$id' : '/flash/';
    return _forward(
      path,
      method: method ?? 'GET',
      headers: headers,
      body: body,
    );
  }

  @override
  Future<http.Response> add({Map<String, String>? headers, Object? body}) {
    return _forward('/flash/add', method: 'POST', headers: headers, body: body);
  }

  @override
  Future<http.Response> addCrypted({
    Map<String, String>? headers,
    Object? body,
  }) {
    return _forward(
      '/flash/addcrypted',
      method: 'POST',
      headers: headers,
      body: body,
    );
  }

  @override
  Future<http.Response> addCrypted2({
    Map<String, String>? headers,
    Object? body,
  }) {
    return _forward(
      '/flash/addcrypted2',
      method: 'POST',
      headers: headers,
      body: body,
    );
  }
}
