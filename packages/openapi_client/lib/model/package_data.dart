//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi_client.api;

class PackageData {
  /// Returns a new [PackageData] instance.
  PackageData({
    required this.pid,
    required this.name,
    required this.folder,
    required this.site,
    required this.password,
    required this.dest,
    required this.order,
    this.linksdone,
    this.sizedone,
    this.sizetotal,
    this.linkstotal,
    this.links = const [],
    this.fids = const [],
  });

  int pid;

  String name;

  String folder;

  String site;

  String password;

  int dest;

  int order;

  int? linksdone;

  int? sizedone;

  int? sizetotal;

  int? linkstotal;

  List<FileData>? links;

  List<int>? fids;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PackageData &&
    other.pid == pid &&
    other.name == name &&
    other.folder == folder &&
    other.site == site &&
    other.password == password &&
    other.dest == dest &&
    other.order == order &&
    other.linksdone == linksdone &&
    other.sizedone == sizedone &&
    other.sizetotal == sizetotal &&
    other.linkstotal == linkstotal &&
    _deepEquality.equals(other.links, links) &&
    _deepEquality.equals(other.fids, fids);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (pid.hashCode) +
    (name.hashCode) +
    (folder.hashCode) +
    (site.hashCode) +
    (password.hashCode) +
    (dest.hashCode) +
    (order.hashCode) +
    (linksdone == null ? 0 : linksdone!.hashCode) +
    (sizedone == null ? 0 : sizedone!.hashCode) +
    (sizetotal == null ? 0 : sizetotal!.hashCode) +
    (linkstotal == null ? 0 : linkstotal!.hashCode) +
    (links == null ? 0 : links!.hashCode) +
    (fids == null ? 0 : fids!.hashCode);

  @override
  String toString() => 'PackageData[pid=$pid, name=$name, folder=$folder, site=$site, password=$password, dest=$dest, order=$order, linksdone=$linksdone, sizedone=$sizedone, sizetotal=$sizetotal, linkstotal=$linkstotal, links=$links, fids=$fids]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'pid'] = this.pid;
      json[r'name'] = this.name;
      json[r'folder'] = this.folder;
      json[r'site'] = this.site;
      json[r'password'] = this.password;
      json[r'dest'] = this.dest;
      json[r'order'] = this.order;
    if (this.linksdone != null) {
      json[r'linksdone'] = this.linksdone;
    } else {
      json[r'linksdone'] = null;
    }
    if (this.sizedone != null) {
      json[r'sizedone'] = this.sizedone;
    } else {
      json[r'sizedone'] = null;
    }
    if (this.sizetotal != null) {
      json[r'sizetotal'] = this.sizetotal;
    } else {
      json[r'sizetotal'] = null;
    }
    if (this.linkstotal != null) {
      json[r'linkstotal'] = this.linkstotal;
    } else {
      json[r'linkstotal'] = null;
    }
    if (this.links != null) {
      json[r'links'] = this.links;
    } else {
      json[r'links'] = null;
    }
    if (this.fids != null) {
      json[r'fids'] = this.fids;
    } else {
      json[r'fids'] = null;
    }
    return json;
  }

  /// Returns a new [PackageData] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PackageData? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'pid'), 'Required key "PackageData[pid]" is missing from JSON.');
        assert(json[r'pid'] != null, 'Required key "PackageData[pid]" has a null value in JSON.');
        assert(json.containsKey(r'name'), 'Required key "PackageData[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "PackageData[name]" has a null value in JSON.');
        assert(json.containsKey(r'folder'), 'Required key "PackageData[folder]" is missing from JSON.');
        assert(json[r'folder'] != null, 'Required key "PackageData[folder]" has a null value in JSON.');
        assert(json.containsKey(r'site'), 'Required key "PackageData[site]" is missing from JSON.');
        assert(json[r'site'] != null, 'Required key "PackageData[site]" has a null value in JSON.');
        assert(json.containsKey(r'password'), 'Required key "PackageData[password]" is missing from JSON.');
        assert(json[r'password'] != null, 'Required key "PackageData[password]" has a null value in JSON.');
        assert(json.containsKey(r'dest'), 'Required key "PackageData[dest]" is missing from JSON.');
        assert(json[r'dest'] != null, 'Required key "PackageData[dest]" has a null value in JSON.');
        assert(json.containsKey(r'order'), 'Required key "PackageData[order]" is missing from JSON.');
        assert(json[r'order'] != null, 'Required key "PackageData[order]" has a null value in JSON.');
        return true;
      }());

      return PackageData(
        pid: mapValueOfType<int>(json, r'pid')!,
        name: mapValueOfType<String>(json, r'name')!,
        folder: mapValueOfType<String>(json, r'folder')!,
        site: mapValueOfType<String>(json, r'site')!,
        password: mapValueOfType<String>(json, r'password')!,
        dest: mapValueOfType<int>(json, r'dest')!,
        order: mapValueOfType<int>(json, r'order')!,
        linksdone: mapValueOfType<int>(json, r'linksdone'),
        sizedone: mapValueOfType<int>(json, r'sizedone'),
        sizetotal: mapValueOfType<int>(json, r'sizetotal'),
        linkstotal: mapValueOfType<int>(json, r'linkstotal'),
        links: FileData.listFromJson(json[r'links']),
        fids: json[r'fids'] is Iterable
            ? (json[r'fids'] as Iterable).cast<int>().toList(growable: false)
            : const [],
      );
    }
    return null;
  }

  static List<PackageData> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PackageData>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PackageData.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PackageData> mapFromJson(dynamic json) {
    final map = <String, PackageData>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PackageData.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PackageData-objects as value to a dart map
  static Map<String, List<PackageData>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PackageData>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PackageData.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'pid',
    'name',
    'folder',
    'site',
    'password',
    'dest',
    'order',
  };
}

