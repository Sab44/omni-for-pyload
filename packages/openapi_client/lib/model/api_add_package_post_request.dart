//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi_client.api;

class ApiAddPackagePostRequest {
  /// Returns a new [ApiAddPackagePostRequest] instance.
  ApiAddPackagePostRequest({
    required this.name,
    this.links = const [],
    this.dest = Destination.QUEUE,
  });

  /// name of the new package
  String name;

  /// list of urls
  List<String> links;

  /// `Destination`
  Destination dest;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ApiAddPackagePostRequest &&
    other.name == name &&
    _deepEquality.equals(other.links, links) &&
    other.dest == dest;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name.hashCode) +
    (links.hashCode) +
    (dest.hashCode);

  @override
  String toString() => 'ApiAddPackagePostRequest[name=$name, links=$links, dest=$dest]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'name'] = this.name;
      json[r'links'] = this.links;
      json[r'dest'] = this.dest;
    return json;
  }

  /// Returns a new [ApiAddPackagePostRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ApiAddPackagePostRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'name'), 'Required key "ApiAddPackagePostRequest[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "ApiAddPackagePostRequest[name]" has a null value in JSON.');
        assert(json.containsKey(r'links'), 'Required key "ApiAddPackagePostRequest[links]" is missing from JSON.');
        assert(json[r'links'] != null, 'Required key "ApiAddPackagePostRequest[links]" has a null value in JSON.');
        return true;
      }());

      return ApiAddPackagePostRequest(
        name: mapValueOfType<String>(json, r'name')!,
        links: json[r'links'] is Iterable
            ? (json[r'links'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        dest: Destination.fromJson(json[r'dest']) ?? Destination.QUEUE,
      );
    }
    return null;
  }

  static List<ApiAddPackagePostRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ApiAddPackagePostRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ApiAddPackagePostRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ApiAddPackagePostRequest> mapFromJson(dynamic json) {
    final map = <String, ApiAddPackagePostRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ApiAddPackagePostRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ApiAddPackagePostRequest-objects as value to a dart map
  static Map<String, List<ApiAddPackagePostRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ApiAddPackagePostRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ApiAddPackagePostRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
    'links',
  };
}

