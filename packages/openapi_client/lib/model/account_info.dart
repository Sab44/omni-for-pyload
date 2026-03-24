//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi_client.api;

class AccountInfo {
  /// Returns a new [AccountInfo] instance.
  AccountInfo({
    this.validuntil,
    this.login = '',
    this.options = const {},
    this.valid = false,
    this.trafficleft,
    this.premium = false,
    this.type = '',
  });

  double? validuntil;

  String login;

  Object options;

  bool valid;

  int? trafficleft;

  bool premium;

  String type;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AccountInfo &&
    other.validuntil == validuntil &&
    other.login == login &&
    other.options == options &&
    other.valid == valid &&
    other.trafficleft == trafficleft &&
    other.premium == premium &&
    other.type == type;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (validuntil == null ? 0 : validuntil!.hashCode) +
    (login.hashCode) +
    (options.hashCode) +
    (valid.hashCode) +
    (trafficleft == null ? 0 : trafficleft!.hashCode) +
    (premium.hashCode) +
    (type.hashCode);

  @override
  String toString() => 'AccountInfo[validuntil=$validuntil, login=$login, options=$options, valid=$valid, trafficleft=$trafficleft, premium=$premium, type=$type]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.validuntil != null) {
      json[r'validuntil'] = this.validuntil;
    } else {
      json[r'validuntil'] = null;
    }
      json[r'login'] = this.login;
      json[r'options'] = this.options;
      json[r'valid'] = this.valid;
    if (this.trafficleft != null) {
      json[r'trafficleft'] = this.trafficleft;
    } else {
      json[r'trafficleft'] = null;
    }
      json[r'premium'] = this.premium;
      json[r'type'] = this.type;
    return json;
  }

  /// Returns a new [AccountInfo] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AccountInfo? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return AccountInfo(
        validuntil: mapValueOfType<double>(json, r'validuntil'),
        login: mapValueOfType<String>(json, r'login') ?? '',
        options: mapValueOfType<Object>(json, r'options') ?? {},
        valid: mapValueOfType<bool>(json, r'valid') ?? false,
        trafficleft: mapValueOfType<int>(json, r'trafficleft'),
        premium: mapValueOfType<bool>(json, r'premium') ?? false,
        type: mapValueOfType<String>(json, r'type') ?? '',
      );
    }
    return null;
  }

  static List<AccountInfo> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AccountInfo>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AccountInfo.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AccountInfo> mapFromJson(dynamic json) {
    final map = <String, AccountInfo>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AccountInfo.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AccountInfo-objects as value to a dart map
  static Map<String, List<AccountInfo>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AccountInfo>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AccountInfo.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

