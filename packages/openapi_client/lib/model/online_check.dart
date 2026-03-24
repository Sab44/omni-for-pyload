//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi_client.api;

class OnlineCheck {
  /// Returns a new [OnlineCheck] instance.
  OnlineCheck({
    required this.rid,
    required this.data,
  });

  int rid;

  Object data;

  @override
  bool operator ==(Object other) => identical(this, other) || other is OnlineCheck &&
    other.rid == rid &&
    other.data == data;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (rid.hashCode) +
    (data.hashCode);

  @override
  String toString() => 'OnlineCheck[rid=$rid, data=$data]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'rid'] = this.rid;
      json[r'data'] = this.data;
    return json;
  }

  /// Returns a new [OnlineCheck] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static OnlineCheck? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'rid'), 'Required key "OnlineCheck[rid]" is missing from JSON.');
        assert(json[r'rid'] != null, 'Required key "OnlineCheck[rid]" has a null value in JSON.');
        assert(json.containsKey(r'data'), 'Required key "OnlineCheck[data]" is missing from JSON.');
        assert(json[r'data'] != null, 'Required key "OnlineCheck[data]" has a null value in JSON.');
        return true;
      }());

      return OnlineCheck(
        rid: mapValueOfType<int>(json, r'rid')!,
        data: mapValueOfType<Object>(json, r'data')!,
      );
    }
    return null;
  }

  static List<OnlineCheck> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OnlineCheck>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OnlineCheck.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, OnlineCheck> mapFromJson(dynamic json) {
    final map = <String, OnlineCheck>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = OnlineCheck.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of OnlineCheck-objects as value to a dart map
  static Map<String, List<OnlineCheck>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<OnlineCheck>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = OnlineCheck.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'rid',
    'data',
  };
}

