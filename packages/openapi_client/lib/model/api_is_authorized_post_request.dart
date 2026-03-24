//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi_client.api;

class ApiIsAuthorizedPostRequest {
  /// Returns a new [ApiIsAuthorizedPostRequest] instance.
  ApiIsAuthorizedPostRequest({
    required this.funcName,
    this.userdata = const {},
  });

  /// function name
  String funcName;

  /// dictionary of user data
  Map<String, Object> userdata;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ApiIsAuthorizedPostRequest &&
    other.funcName == funcName &&
    _deepEquality.equals(other.userdata, userdata);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (funcName.hashCode) +
    (userdata.hashCode);

  @override
  String toString() => 'ApiIsAuthorizedPostRequest[funcName=$funcName, userdata=$userdata]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'func_name'] = this.funcName;
      json[r'userdata'] = this.userdata;
    return json;
  }

  /// Returns a new [ApiIsAuthorizedPostRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ApiIsAuthorizedPostRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'func_name'), 'Required key "ApiIsAuthorizedPostRequest[func_name]" is missing from JSON.');
        assert(json[r'func_name'] != null, 'Required key "ApiIsAuthorizedPostRequest[func_name]" has a null value in JSON.');
        assert(json.containsKey(r'userdata'), 'Required key "ApiIsAuthorizedPostRequest[userdata]" is missing from JSON.');
        assert(json[r'userdata'] != null, 'Required key "ApiIsAuthorizedPostRequest[userdata]" has a null value in JSON.');
        return true;
      }());

      return ApiIsAuthorizedPostRequest(
        funcName: mapValueOfType<String>(json, r'func_name')!,
        userdata: mapCastOfType<String, Object>(json, r'userdata')!,
      );
    }
    return null;
  }

  static List<ApiIsAuthorizedPostRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ApiIsAuthorizedPostRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ApiIsAuthorizedPostRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ApiIsAuthorizedPostRequest> mapFromJson(dynamic json) {
    final map = <String, ApiIsAuthorizedPostRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ApiIsAuthorizedPostRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ApiIsAuthorizedPostRequest-objects as value to a dart map
  static Map<String, List<ApiIsAuthorizedPostRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ApiIsAuthorizedPostRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ApiIsAuthorizedPostRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'func_name',
    'userdata',
  };
}

