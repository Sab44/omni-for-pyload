//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi_client.api;

class ApiSetPackageDataPostRequest {
  /// Returns a new [ApiSetPackageDataPostRequest] instance.
  ApiSetPackageDataPostRequest({
    required this.packageId,
    this.data = const {},
  });

  /// package id
  int packageId;

  /// dict that maps attribute to desired value
  Map<String, Object> data;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ApiSetPackageDataPostRequest &&
    other.packageId == packageId &&
    _deepEquality.equals(other.data, data);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (packageId.hashCode) +
    (data.hashCode);

  @override
  String toString() => 'ApiSetPackageDataPostRequest[packageId=$packageId, data=$data]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'package_id'] = this.packageId;
      json[r'data'] = this.data;
    return json;
  }

  /// Returns a new [ApiSetPackageDataPostRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ApiSetPackageDataPostRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'package_id'), 'Required key "ApiSetPackageDataPostRequest[package_id]" is missing from JSON.');
        assert(json[r'package_id'] != null, 'Required key "ApiSetPackageDataPostRequest[package_id]" has a null value in JSON.');
        assert(json.containsKey(r'data'), 'Required key "ApiSetPackageDataPostRequest[data]" is missing from JSON.');
        assert(json[r'data'] != null, 'Required key "ApiSetPackageDataPostRequest[data]" has a null value in JSON.');
        return true;
      }());

      return ApiSetPackageDataPostRequest(
        packageId: mapValueOfType<int>(json, r'package_id')!,
        data: mapCastOfType<String, Object>(json, r'data')!,
      );
    }
    return null;
  }

  static List<ApiSetPackageDataPostRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ApiSetPackageDataPostRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ApiSetPackageDataPostRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ApiSetPackageDataPostRequest> mapFromJson(dynamic json) {
    final map = <String, ApiSetPackageDataPostRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ApiSetPackageDataPostRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ApiSetPackageDataPostRequest-objects as value to a dart map
  static Map<String, List<ApiSetPackageDataPostRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ApiSetPackageDataPostRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ApiSetPackageDataPostRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'package_id',
    'data',
  };
}

