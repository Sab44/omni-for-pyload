//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi_client.api;

class ConfigItem {
  /// Returns a new [ConfigItem] instance.
  ConfigItem({
    required this.name,
    required this.description,
    required this.value,
    required this.type,
  });

  String name;

  String description;

  String value;

  String type;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ConfigItem &&
    other.name == name &&
    other.description == description &&
    other.value == value &&
    other.type == type;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name.hashCode) +
    (description.hashCode) +
    (value.hashCode) +
    (type.hashCode);

  @override
  String toString() => 'ConfigItem[name=$name, description=$description, value=$value, type=$type]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'name'] = this.name;
      json[r'description'] = this.description;
      json[r'value'] = this.value;
      json[r'type'] = this.type;
    return json;
  }

  /// Returns a new [ConfigItem] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ConfigItem? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'name'), 'Required key "ConfigItem[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "ConfigItem[name]" has a null value in JSON.');
        assert(json.containsKey(r'description'), 'Required key "ConfigItem[description]" is missing from JSON.');
        assert(json[r'description'] != null, 'Required key "ConfigItem[description]" has a null value in JSON.');
        assert(json.containsKey(r'value'), 'Required key "ConfigItem[value]" is missing from JSON.');
        assert(json[r'value'] != null, 'Required key "ConfigItem[value]" has a null value in JSON.');
        assert(json.containsKey(r'type'), 'Required key "ConfigItem[type]" is missing from JSON.');
        assert(json[r'type'] != null, 'Required key "ConfigItem[type]" has a null value in JSON.');
        return true;
      }());

      return ConfigItem(
        name: mapValueOfType<String>(json, r'name')!,
        description: mapValueOfType<String>(json, r'description')!,
        value: mapValueOfType<String>(json, r'value')!,
        type: mapValueOfType<String>(json, r'type')!,
      );
    }
    return null;
  }

  static List<ConfigItem> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ConfigItem>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ConfigItem.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ConfigItem> mapFromJson(dynamic json) {
    final map = <String, ConfigItem>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ConfigItem.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ConfigItem-objects as value to a dart map
  static Map<String, List<ConfigItem>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ConfigItem>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ConfigItem.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
    'description',
    'value',
    'type',
  };
}

