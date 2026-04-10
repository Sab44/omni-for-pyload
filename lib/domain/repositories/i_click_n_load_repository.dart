import 'package:http/http.dart' as http;

abstract class IClickNLoadRepository {
  Future<http.Response> index({
    String? id,
    String? method,
    Map<String, String>? headers,
    Object? body,
  });

  Future<http.Response> add({Map<String, String>? headers, Object? body});

  Future<http.Response> addCrypted({
    Map<String, String>? headers,
    Object? body,
  });

  Future<http.Response> addCrypted2({
    Map<String, String>? headers,
    Object? body,
  });
}
