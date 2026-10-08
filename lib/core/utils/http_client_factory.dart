import 'dart:io';

import 'package:http/io_client.dart';

class HttpClientFactory {
  /// Creates an IOClient with optional SSL verification control
  static IOClient createClient(bool allowInsecureConnections) {
    if (allowInsecureConnections) {
      final HttpClient httpClient = HttpClient()
        ..badCertificateCallback = (
          X509Certificate cert,
          String host,
          int port,
        ) => true;
      return IOClient(httpClient);
    }

    return IOClient(HttpClient());
  }
}
