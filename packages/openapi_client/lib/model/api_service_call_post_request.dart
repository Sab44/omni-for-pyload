//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi_client.api;

class ApiServiceCallPostRequest {
  /// Returns a new [ApiServiceCallPostRequest] instance.
  ApiServiceCallPostRequest({
    required this.serviceName,
    this.arguments = const [],
    this.parseArguments = false,
  });

  String? serviceName;

  List<Object> arguments;

  bool parseArguments;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ApiServiceCallPostRequest &&
    other.serviceName == serviceName &&
    _deepEquality.equals(other.arguments, arguments) &&
    other.parseArguments == parseArguments;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (serviceName == null ? 0 : serviceName!.hashCode) +
    (arguments.hashCode) +
    (parseArguments.hashCode);

  @override
  String toString() => 'ApiServiceCallPostRequest[serviceName=$serviceName, arguments=$arguments, parseArguments=$parseArguments]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.serviceName != null) {
      json[r'service_name'] = this.serviceName;
    } else {
      json[r'service_name'] = null;
    }
      json[r'arguments'] = this.arguments;
      json[r'parse_arguments'] = this.parseArguments;
    return json;
  }

  /// Returns a new [ApiServiceCallPostRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ApiServiceCallPostRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'service_name'), 'Required key "ApiServiceCallPostRequest[service_name]" is missing from JSON.');
        assert(json.containsKey(r'arguments'), 'Required key "ApiServiceCallPostRequest[arguments]" is missing from JSON.');
        assert(json[r'arguments'] != null, 'Required key "ApiServiceCallPostRequest[arguments]" has a null value in JSON.');
        return true;
      }());

      return ApiServiceCallPostRequest(
        serviceName: mapValueOfType<String>(json, r'service_name'),
        arguments: json[r'arguments'] is Iterable
            ? (json[r'arguments'] as Iterable).cast<Object>().toList(growable: false)
            : const [],
        parseArguments: mapValueOfType<bool>(json, r'parse_arguments') ?? false,
      );
    }
    return null;
  }

  static List<ApiServiceCallPostRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ApiServiceCallPostRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ApiServiceCallPostRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ApiServiceCallPostRequest> mapFromJson(dynamic json) {
    final map = <String, ApiServiceCallPostRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ApiServiceCallPostRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ApiServiceCallPostRequest-objects as value to a dart map
  static Map<String, List<ApiServiceCallPostRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ApiServiceCallPostRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ApiServiceCallPostRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'service_name',
    'arguments',
  };
}

