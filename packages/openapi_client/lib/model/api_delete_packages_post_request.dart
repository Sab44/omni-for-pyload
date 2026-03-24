//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi_client.api;

class ApiDeletePackagesPostRequest {
  /// Returns a new [ApiDeletePackagesPostRequest] instance.
  ApiDeletePackagesPostRequest({
    this.packageIds = const [],
  });

  /// list of package ids
  List<int> packageIds;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ApiDeletePackagesPostRequest &&
    _deepEquality.equals(other.packageIds, packageIds);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (packageIds.hashCode);

  @override
  String toString() => 'ApiDeletePackagesPostRequest[packageIds=$packageIds]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'package_ids'] = this.packageIds;
    return json;
  }

  /// Returns a new [ApiDeletePackagesPostRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ApiDeletePackagesPostRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'package_ids'), 'Required key "ApiDeletePackagesPostRequest[package_ids]" is missing from JSON.');
        assert(json[r'package_ids'] != null, 'Required key "ApiDeletePackagesPostRequest[package_ids]" has a null value in JSON.');
        return true;
      }());

      return ApiDeletePackagesPostRequest(
        packageIds: json[r'package_ids'] is Iterable
            ? (json[r'package_ids'] as Iterable).cast<int>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<ApiDeletePackagesPostRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ApiDeletePackagesPostRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ApiDeletePackagesPostRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ApiDeletePackagesPostRequest> mapFromJson(dynamic json) {
    final map = <String, ApiDeletePackagesPostRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ApiDeletePackagesPostRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ApiDeletePackagesPostRequest-objects as value to a dart map
  static Map<String, List<ApiDeletePackagesPostRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ApiDeletePackagesPostRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ApiDeletePackagesPostRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'package_ids',
  };
}

