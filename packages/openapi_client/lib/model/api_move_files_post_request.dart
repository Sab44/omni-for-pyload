//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi_client.api;

class ApiMoveFilesPostRequest {
  /// Returns a new [ApiMoveFilesPostRequest] instance.
  ApiMoveFilesPostRequest({
    this.fileIds = const [],
    required this.packageId,
  });

  /// list of file ids
  List<int> fileIds;

  /// destination package
  int packageId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ApiMoveFilesPostRequest &&
    _deepEquality.equals(other.fileIds, fileIds) &&
    other.packageId == packageId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (fileIds.hashCode) +
    (packageId.hashCode);

  @override
  String toString() => 'ApiMoveFilesPostRequest[fileIds=$fileIds, packageId=$packageId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'file_ids'] = this.fileIds;
      json[r'package_id'] = this.packageId;
    return json;
  }

  /// Returns a new [ApiMoveFilesPostRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ApiMoveFilesPostRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'file_ids'), 'Required key "ApiMoveFilesPostRequest[file_ids]" is missing from JSON.');
        assert(json[r'file_ids'] != null, 'Required key "ApiMoveFilesPostRequest[file_ids]" has a null value in JSON.');
        assert(json.containsKey(r'package_id'), 'Required key "ApiMoveFilesPostRequest[package_id]" is missing from JSON.');
        assert(json[r'package_id'] != null, 'Required key "ApiMoveFilesPostRequest[package_id]" has a null value in JSON.');
        return true;
      }());

      return ApiMoveFilesPostRequest(
        fileIds: json[r'file_ids'] is Iterable
            ? (json[r'file_ids'] as Iterable).cast<int>().toList(growable: false)
            : const [],
        packageId: mapValueOfType<int>(json, r'package_id')!,
      );
    }
    return null;
  }

  static List<ApiMoveFilesPostRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ApiMoveFilesPostRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ApiMoveFilesPostRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ApiMoveFilesPostRequest> mapFromJson(dynamic json) {
    final map = <String, ApiMoveFilesPostRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ApiMoveFilesPostRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ApiMoveFilesPostRequest-objects as value to a dart map
  static Map<String, List<ApiMoveFilesPostRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ApiMoveFilesPostRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ApiMoveFilesPostRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'file_ids',
    'package_id',
  };
}

