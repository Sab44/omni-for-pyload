//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi_client.api;

class ApiGeneratePackagesPostRequest {
  /// Returns a new [ApiGeneratePackagesPostRequest] instance.
  ApiGeneratePackagesPostRequest({
    this.links = const [],
  });

  /// list of urls
  List<String> links;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ApiGeneratePackagesPostRequest &&
    _deepEquality.equals(other.links, links);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (links.hashCode);

  @override
  String toString() => 'ApiGeneratePackagesPostRequest[links=$links]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'links'] = this.links;
    return json;
  }

  /// Returns a new [ApiGeneratePackagesPostRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ApiGeneratePackagesPostRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'links'), 'Required key "ApiGeneratePackagesPostRequest[links]" is missing from JSON.');
        assert(json[r'links'] != null, 'Required key "ApiGeneratePackagesPostRequest[links]" has a null value in JSON.');
        return true;
      }());

      return ApiGeneratePackagesPostRequest(
        links: json[r'links'] is Iterable
            ? (json[r'links'] as Iterable).cast<String>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<ApiGeneratePackagesPostRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ApiGeneratePackagesPostRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ApiGeneratePackagesPostRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ApiGeneratePackagesPostRequest> mapFromJson(dynamic json) {
    final map = <String, ApiGeneratePackagesPostRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ApiGeneratePackagesPostRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ApiGeneratePackagesPostRequest-objects as value to a dart map
  static Map<String, List<ApiGeneratePackagesPostRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ApiGeneratePackagesPostRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ApiGeneratePackagesPostRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'links',
  };
}

