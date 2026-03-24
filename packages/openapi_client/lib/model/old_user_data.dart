//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi_client.api;

class OldUserData {
  /// Returns a new [OldUserData] instance.
  OldUserData({
    this.name,
    this.email,
    this.role,
    this.permission,
    this.templateName,
  });

  String? name;

  String? email;

  int? role;

  int? permission;

  String? templateName;

  @override
  bool operator ==(Object other) => identical(this, other) || other is OldUserData &&
    other.name == name &&
    other.email == email &&
    other.role == role &&
    other.permission == permission &&
    other.templateName == templateName;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name == null ? 0 : name!.hashCode) +
    (email == null ? 0 : email!.hashCode) +
    (role == null ? 0 : role!.hashCode) +
    (permission == null ? 0 : permission!.hashCode) +
    (templateName == null ? 0 : templateName!.hashCode);

  @override
  String toString() => 'OldUserData[name=$name, email=$email, role=$role, permission=$permission, templateName=$templateName]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.name != null) {
      json[r'name'] = this.name;
    } else {
      json[r'name'] = null;
    }
    if (this.email != null) {
      json[r'email'] = this.email;
    } else {
      json[r'email'] = null;
    }
    if (this.role != null) {
      json[r'role'] = this.role;
    } else {
      json[r'role'] = null;
    }
    if (this.permission != null) {
      json[r'permission'] = this.permission;
    } else {
      json[r'permission'] = null;
    }
    if (this.templateName != null) {
      json[r'template_name'] = this.templateName;
    } else {
      json[r'template_name'] = null;
    }
    return json;
  }

  /// Returns a new [OldUserData] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static OldUserData? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return OldUserData(
        name: mapValueOfType<String>(json, r'name'),
        email: mapValueOfType<String>(json, r'email'),
        role: mapValueOfType<int>(json, r'role'),
        permission: mapValueOfType<int>(json, r'permission'),
        templateName: mapValueOfType<String>(json, r'template_name'),
      );
    }
    return null;
  }

  static List<OldUserData> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OldUserData>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OldUserData.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, OldUserData> mapFromJson(dynamic json) {
    final map = <String, OldUserData>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = OldUserData.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of OldUserData-objects as value to a dart map
  static Map<String, List<OldUserData>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<OldUserData>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = OldUserData.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

