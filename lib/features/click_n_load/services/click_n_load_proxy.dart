import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:omni_for_pyload/domain/models/clicknload_server.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

/// Local Click'N'Load HTTP server that forwards `/flash/*` requests to
/// [target] and answers `/jdcheck.js` itself
class ClickNLoadProxy {
  static final _log = Logger('ClickNLoadProxy');

  /// The port browsers send Click'N'Load requests to
  static const int defaultPort = 9666;

  final ClickNLoadServer target;
  final http.Client _client;
  final int _port;
  HttpServer? _server;

  ClickNLoadProxy({
    required this.target,
    required this._client,
    this._port = defaultPort,
  });

  /// The port the server listens on, or null if it is not running
  int? get boundPort => _server?.port;

  /// Start listening on the loopback interface
  ///
  /// Throws if the port cannot be bound, e.g. because it is in use.
  Future<void> start() async {
    if (_server != null) return;

    final app = Router()
      ..get('/flash/', (Request request) => _forward(request, '/flash/'))
      ..post('/flash/', (Request request) => _forward(request, '/flash/'))
      ..post('/flash/add', (Request request) => _forward(request, '/flash/add'))
      ..post(
        '/flash/addcrypted',
        (Request request) => _forward(request, '/flash/addcrypted'),
      )
      ..post(
        '/flash/addcrypted2',
        (Request request) => _forward(request, '/flash/addcrypted2'),
      )
      ..get('/jdcheck.js', (Request request) {
        return Response.ok(
          "jdownloader=true;\r\nvar version='42707';\r\n",
          headers: {'Content-Type': 'application/javascript'},
        );
      });

    final handler = Pipeline()
        .addMiddleware(
          logRequests(
            logger: (message, isError) =>
                isError ? _log.warning(message) : _log.fine(message),
          ),
        )
        .addHandler(app.call);

    _server = await shelf_io.serve(
      handler,
      InternetAddress.loopbackIPv4,
      _port,
    );
    _log.info(
      'HTTP server running on port ${_server!.port}, forwarding to '
      '${target.baseUrl}',
    );
  }

  /// Stop listening and close the upstream client
  Future<void> stop() async {
    final server = _server;
    _server = null;
    if (server != null) {
      await server.close(force: true);
      _log.info('HTTP server stopped');
    }
    _client.close();
  }

  Future<Response> _forward(Request request, String path) async {
    final uri = Uri.parse('${target.baseUrl}$path');
    final body = await request.readAsString();

    // The client sets these itself
    final headers = Map<String, String>.from(request.headers)
      ..remove('host')
      ..remove('content-length');

    _log.fine('Forwarding ${request.method} request to $uri');
    if (body.isNotEmpty) {
      _log.finest('Body: $body');
    }

    final upstreamRequest = http.Request(request.method, uri)
      ..headers.addAll(headers);
    if (body.isNotEmpty) {
      upstreamRequest.body = body;
    }

    try {
      final response = await http.Response.fromStream(
        await _client.send(upstreamRequest),
      );
      return Response(
        response.statusCode,
        body: response.bodyBytes,
        headers: {
          ...response.headers,
          'content-length': '${response.bodyBytes.length}',
        },
      );
    } catch (e, stackTrace) {
      _log.warning('Error forwarding request to $uri', e, stackTrace);
      return Response.internalServerError(body: 'Error forwarding request: $e');
    }
  }
}
