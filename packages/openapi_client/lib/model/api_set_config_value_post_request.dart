//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi_client.api;

class ApiSetConfigValuePostRequest {
  /// Returns a new [ApiSetConfigValuePostRequest] instance.
  ApiSetConfigValuePostRequest({
    required this.category,
    required this.option,
    required this.value,
    this.section = 'core',
  });

  String? category;

  String? option;

  /// new config value
  Object value;

  /// 'plugin' or 'core'
  String section;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ApiSetConfigValuePostRequest &&
    other.category == category &&
    other.option == option &&
    other.value == value &&
    other.section == section;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (category == null ? 0 : category!.hashCode) +
    (option == null ? 0 : option!.hashCode) +
    (value.hashCode) +
    (section.hashCode);

  @override
  String toString() => 'ApiSetConfigValuePostRequest[category=$category, option=$option, value=$value, section=$section]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.category != null) {
      json[r'category'] = this.category;
    } else {
      json[r'category'] = null;
    }
    if (this.option != null) {
      json[r'option'] = this.option;
    } else {
      json[r'option'] = null;
    }
      json[r'value'] = this.value;
      json[r'section'] = this.section;
    return json;
  }

  /// Returns a new [ApiSetConfigValuePostRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ApiSetConfigValuePostRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'category'), 'Required key "ApiSetConfigValuePostRequest[category]" is missing from JSON.');
        assert(json.containsKey(r'option'), 'Required key "ApiSetConfigValuePostRequest[option]" is missing from JSON.');
        assert(json.containsKey(r'value'), 'Required key "ApiSetConfigValuePostRequest[value]" is missing from JSON.');
        assert(json[r'value'] != null, 'Required key "ApiSetConfigValuePostRequest[value]" has a null value in JSON.');
        return true;
      }());

      return ApiSetConfigValuePostRequest(
        category: mapValueOfType<String>(json, r'category'),
        option: mapValueOfType<String>(json, r'option'),
        value: mapValueOfType<Object>(json, r'value')!,
        section: mapValueOfType<String>(json, r'section') ?? 'core',
      );
    }
    return null;
  }

  static List<ApiSetConfigValuePostRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ApiSetConfigValuePostRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ApiSetConfigValuePostRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ApiSetConfigValuePostRequest> mapFromJson(dynamic json) {
    final map = <String, ApiSetConfigValuePostRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ApiSetConfigValuePostRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ApiSetConfigValuePostRequest-objects as value to a dart map
  static Map<String, List<ApiSetConfigValuePostRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ApiSetConfigValuePostRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ApiSetConfigValuePostRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'category',
    'option',
    'value',
  };
}

