//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi_client.api;

class UserData {
  /// Returns a new [UserData] instance.
  UserData({
    this.id,
    this.name,
    this.email,
    this.role,
    this.permission,
    this.template,
  });

  int? id;

  String? name;

  String? email;

  int? role;

  int? permission;

  String? template;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UserData &&
    other.id == id &&
    other.name == name &&
    other.email == email &&
    other.role == role &&
    other.permission == permission &&
    other.template == template;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id == null ? 0 : id!.hashCode) +
    (name == null ? 0 : name!.hashCode) +
    (email == null ? 0 : email!.hashCode) +
    (role == null ? 0 : role!.hashCode) +
    (permission == null ? 0 : permission!.hashCode) +
    (template == null ? 0 : template!.hashCode);

  @override
  String toString() => 'UserData[id=$id, name=$name, email=$email, role=$role, permission=$permission, template=$template]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.id != null) {
      json[r'id'] = this.id;
    } else {
      json[r'id'] = null;
    }
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
    if (this.template != null) {
      json[r'template'] = this.template;
    } else {
      json[r'template'] = null;
    }
    return json;
  }

  /// Returns a new [UserData] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UserData? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return UserData(
        id: mapValueOfType<int>(json, r'id'),
        name: mapValueOfType<String>(json, r'name'),
        email: mapValueOfType<String>(json, r'email'),
        role: mapValueOfType<int>(json, r'role'),
        permission: mapValueOfType<int>(json, r'permission'),
        template: mapValueOfType<String>(json, r'template'),
      );
    }
    return null;
  }

  static List<UserData> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UserData>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserData.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UserData> mapFromJson(dynamic json) {
    final map = <String, UserData>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UserData.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UserData-objects as value to a dart map
  static Map<String, List<UserData>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UserData>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UserData.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

