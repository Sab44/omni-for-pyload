//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi_client.api;

class CaptchaTask {
  /// Returns a new [CaptchaTask] instance.
  CaptchaTask({
    required this.tid,
    this.data,
    this.type,
    this.resultType,
  });

  int tid;

  Object? data;

  String? type;

  String? resultType;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CaptchaTask &&
    other.tid == tid &&
    other.data == data &&
    other.type == type &&
    other.resultType == resultType;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (tid.hashCode) +
    (data == null ? 0 : data!.hashCode) +
    (type == null ? 0 : type!.hashCode) +
    (resultType == null ? 0 : resultType!.hashCode);

  @override
  String toString() => 'CaptchaTask[tid=$tid, data=$data, type=$type, resultType=$resultType]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'tid'] = this.tid;
    if (this.data != null) {
      json[r'data'] = this.data;
    } else {
      json[r'data'] = null;
    }
    if (this.type != null) {
      json[r'type'] = this.type;
    } else {
      json[r'type'] = null;
    }
    if (this.resultType != null) {
      json[r'result_type'] = this.resultType;
    } else {
      json[r'result_type'] = null;
    }
    return json;
  }

  /// Returns a new [CaptchaTask] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CaptchaTask? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'tid'), 'Required key "CaptchaTask[tid]" is missing from JSON.');
        assert(json[r'tid'] != null, 'Required key "CaptchaTask[tid]" has a null value in JSON.');
        return true;
      }());

      return CaptchaTask(
        tid: mapValueOfType<int>(json, r'tid')!,
        data: mapValueOfType<Object>(json, r'data'),
        type: mapValueOfType<String>(json, r'type'),
        resultType: mapValueOfType<String>(json, r'result_type'),
      );
    }
    return null;
  }

  static List<CaptchaTask> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CaptchaTask>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CaptchaTask.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CaptchaTask> mapFromJson(dynamic json) {
    final map = <String, CaptchaTask>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CaptchaTask.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CaptchaTask-objects as value to a dart map
  static Map<String, List<CaptchaTask>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CaptchaTask>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CaptchaTask.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'tid',
  };
}

