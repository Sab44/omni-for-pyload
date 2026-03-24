//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi_client.api;

class ApiUpdateAccountPostRequest {
  /// Returns a new [ApiUpdateAccountPostRequest] instance.
  ApiUpdateAccountPostRequest({
    required this.plugin,
    required this.account,
    this.password = 'null',
    this.options = const {},
  });

  String? plugin;

  String? account;

  String password;

  Map<String, Object> options;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ApiUpdateAccountPostRequest &&
    other.plugin == plugin &&
    other.account == account &&
    other.password == password &&
    _deepEquality.equals(other.options, options);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (plugin == null ? 0 : plugin!.hashCode) +
    (account == null ? 0 : account!.hashCode) +
    (password.hashCode) +
    (options.hashCode);

  @override
  String toString() => 'ApiUpdateAccountPostRequest[plugin=$plugin, account=$account, password=$password, options=$options]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.plugin != null) {
      json[r'plugin'] = this.plugin;
    } else {
      json[r'plugin'] = null;
    }
    if (this.account != null) {
      json[r'account'] = this.account;
    } else {
      json[r'account'] = null;
    }
      json[r'password'] = this.password;
      json[r'options'] = this.options;
    return json;
  }

  /// Returns a new [ApiUpdateAccountPostRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ApiUpdateAccountPostRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'plugin'), 'Required key "ApiUpdateAccountPostRequest[plugin]" is missing from JSON.');
        assert(json.containsKey(r'account'), 'Required key "ApiUpdateAccountPostRequest[account]" is missing from JSON.');
        return true;
      }());

      return ApiUpdateAccountPostRequest(
        plugin: mapValueOfType<String>(json, r'plugin'),
        account: mapValueOfType<String>(json, r'account'),
        password: mapValueOfType<String>(json, r'password') ?? 'null',
        options: mapCastOfType<String, Object>(json, r'options') ?? const {},
      );
    }
    return null;
  }

  static List<ApiUpdateAccountPostRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ApiUpdateAccountPostRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ApiUpdateAccountPostRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ApiUpdateAccountPostRequest> mapFromJson(dynamic json) {
    final map = <String, ApiUpdateAccountPostRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ApiUpdateAccountPostRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ApiUpdateAccountPostRequest-objects as value to a dart map
  static Map<String, List<ApiUpdateAccountPostRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ApiUpdateAccountPostRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ApiUpdateAccountPostRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'plugin',
    'account',
  };
}

