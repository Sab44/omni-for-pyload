//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi_client.api;

class ConfigSection {
  /// Returns a new [ConfigSection] instance.
  ConfigSection({
    required this.name,
    required this.description,
    this.items = const [],
    required this.outline,
  });

  String name;

  String description;

  List<ConfigItem> items;

  String? outline;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ConfigSection &&
    other.name == name &&
    other.description == description &&
    _deepEquality.equals(other.items, items) &&
    other.outline == outline;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name.hashCode) +
    (description.hashCode) +
    (items.hashCode) +
    (outline == null ? 0 : outline!.hashCode);

  @override
  String toString() => 'ConfigSection[name=$name, description=$description, items=$items, outline=$outline]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'name'] = this.name;
      json[r'description'] = this.description;
      json[r'items'] = this.items;
    if (this.outline != null) {
      json[r'outline'] = this.outline;
    } else {
      json[r'outline'] = null;
    }
    return json;
  }

  /// Returns a new [ConfigSection] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ConfigSection? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'name'), 'Required key "ConfigSection[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "ConfigSection[name]" has a null value in JSON.');
        assert(json.containsKey(r'description'), 'Required key "ConfigSection[description]" is missing from JSON.');
        assert(json[r'description'] != null, 'Required key "ConfigSection[description]" has a null value in JSON.');
        assert(json.containsKey(r'items'), 'Required key "ConfigSection[items]" is missing from JSON.');
        assert(json[r'items'] != null, 'Required key "ConfigSection[items]" has a null value in JSON.');
        assert(json.containsKey(r'outline'), 'Required key "ConfigSection[outline]" is missing from JSON.');
        return true;
      }());

      return ConfigSection(
        name: mapValueOfType<String>(json, r'name')!,
        description: mapValueOfType<String>(json, r'description')!,
        items: ConfigItem.listFromJson(json[r'items']),
        outline: mapValueOfType<String>(json, r'outline'),
      );
    }
    return null;
  }

  static List<ConfigSection> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ConfigSection>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ConfigSection.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ConfigSection> mapFromJson(dynamic json) {
    final map = <String, ConfigSection>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ConfigSection.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ConfigSection-objects as value to a dart map
  static Map<String, List<ConfigSection>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ConfigSection>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ConfigSection.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
    'description',
    'items',
    'outline',
  };
}

