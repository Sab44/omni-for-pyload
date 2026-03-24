//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi_client.api;

class ApiCheckUrlsPostRequest {
  /// Returns a new [ApiCheckUrlsPostRequest] instance.
  ApiCheckUrlsPostRequest({
    this.urls = const [],
  });

  List<String> urls;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ApiCheckUrlsPostRequest &&
    _deepEquality.equals(other.urls, urls);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (urls.hashCode);

  @override
  String toString() => 'ApiCheckUrlsPostRequest[urls=$urls]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'urls'] = this.urls;
    return json;
  }

  /// Returns a new [ApiCheckUrlsPostRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ApiCheckUrlsPostRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'urls'), 'Required key "ApiCheckUrlsPostRequest[urls]" is missing from JSON.');
        assert(json[r'urls'] != null, 'Required key "ApiCheckUrlsPostRequest[urls]" has a null value in JSON.');
        return true;
      }());

      return ApiCheckUrlsPostRequest(
        urls: json[r'urls'] is Iterable
            ? (json[r'urls'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<ApiCheckUrlsPostRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ApiCheckUrlsPostRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ApiCheckUrlsPostRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ApiCheckUrlsPostRequest> mapFromJson(dynamic json) {
    final map = <String, ApiCheckUrlsPostRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ApiCheckUrlsPostRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ApiCheckUrlsPostRequest-objects as value to a dart map
  static Map<String, List<ApiCheckUrlsPostRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ApiCheckUrlsPostRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ApiCheckUrlsPostRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'urls',
  };
}

