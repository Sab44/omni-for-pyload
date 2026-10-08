import 'dart:io';

import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:omni_for_pyload/data/repositories/click_n_load_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

class ClickNLoadService {
  static final _log = Logger('ClickNLoadService');

  static const MethodChannel _channel = MethodChannel(
    'com.downloader.omni_for_pyload/click_n_load',
  );

  final ClickNLoadRepository _repository;

  ClickNLoadService({required this._repository}) {
    // Set up handler for callbacks from native side
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  HttpServer? _server;
  bool _isRunning = false;

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onServiceStopped':
        // Native service was stopped (e.g., notification tapped)
        // Stop the HTTP server on the Dart side
        await _stopHttpServer();
        _isRunning = false;
        _log.info('Received stop signal from native service');
        return null;
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'Method ${call.method} not implemented',
        );
    }
  }

  /// Check if the service is currently running
  Future<bool> isRunning() async {
    if (!Platform.isAndroid) {
      return _isRunning;
    }

    try {
      final bool running = await _channel.invokeMethod('isRunning');
      // Sync state - if native says not running but we have a server, clean up
      if (!running && _server != null) {
        await _stopHttpServer();
      }
      return running && _server != null;
    } catch (e, stackTrace) {
      _log.warning('Error checking service status', e, stackTrace);
      return false;
    }
  }

  /// Start the Click'n'Load service with the given server configuration
  Future<bool> start() async {
    if (!Platform.isAndroid) {
      _log.warning('Click\'N\'Load is not supported on this platform');
      return false;
    }

    try {
      // Start the native foreground service first
      await _channel.invokeMethod('startService');

      // Start the HTTP server
      await _startHttpServer();

      _isRunning = true;
      _log.info('Service started');
      return true;
    } catch (e, stackTrace) {
      _log.severe('Error starting service', e, stackTrace);
      // Clean up on failure
      await stop();
      return false;
    }
  }

  /// Stop the Click'n'Load service
  Future<void> stop() async {
    if (!Platform.isAndroid) {
      return;
    }

    try {
      // Stop the HTTP server
      await _stopHttpServer();

      // Stop the native foreground service
      await _channel.invokeMethod('stopService');

      _isRunning = false;
      _log.info('Service stopped');
    } catch (e, stackTrace) {
      _log.warning('Error stopping service', e, stackTrace);
    }
  }

  Future<void> _startHttpServer() async {
    if (_server != null) {
      _log.fine('HTTP server already running');
      return;
    }

    final app = Router();

    // Helper to handle requests
    Future<Response> handle(Future<dynamic> Function() action) async {
      try {
        final response = await action();
        return Response(
          response.statusCode,
          body: response.bodyBytes,
          headers: response.headers,
        );
      } catch (e, stackTrace) {
        _log.warning('Error handling request', e, stackTrace);
        return Response.internalServerError(body: e.toString());
      }
    }

    // Define routes
    app.get(
      '/flash/',
      (Request request) => handle(
        () => _repository.index(method: 'GET', headers: request.headers),
      ),
    );

    app.post('/flash/', (Request request) async {
      final body = await request.readAsString();
      return handle(
        () => _repository.index(
          method: 'POST',
          headers: request.headers,
          body: body,
        ),
      );
    });

    app.post('/flash/add', (Request request) async {
      final body = await request.readAsString();
      return handle(
        () => _repository.add(headers: request.headers, body: body),
      );
    });

    app.post('/flash/addcrypted', (Request request) async {
      final body = await request.readAsString();
      return handle(
        () => _repository.addCrypted(headers: request.headers, body: body),
      );
    });

    app.post('/flash/addcrypted2', (Request request) async {
      final body = await request.readAsString();
      return handle(
        () => _repository.addCrypted2(headers: request.headers, body: body),
      );
    });

    // jdcheck.js endpoint - hardcoded response
    app.get('/jdcheck.js', (Request request) async {
      String response = "jdownloader=true;\r\n";
      response += "var version='42707';\r\n";
      return Response.ok(
        response,
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

    try {
      _server = await shelf_io.serve(
        handler,
        InternetAddress.loopbackIPv4,
        9666,
      );
      _log.info('HTTP server running on port ${_server!.port}');
    } catch (e, stackTrace) {
      _log.severe('Failed to start HTTP server', e, stackTrace);
      rethrow;
    }
  }

  Future<void> _stopHttpServer() async {
    if (_server != null) {
      await _server!.close(force: true);
      _server = null;
      _log.info('HTTP server stopped');
    }
  }
}
