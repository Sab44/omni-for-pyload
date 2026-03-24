//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi_client.api;

class DownloadInfo {
  /// Returns a new [DownloadInfo] instance.
  DownloadInfo({
    required this.fid,
    required this.name,
    required this.speed,
    required this.eta,
    required this.formatEta,
    required this.bleft,
    required this.size,
    required this.formatSize,
    required this.percent,
    required this.status,
    required this.statusmsg,
    required this.formatWait,
    required this.waitUntil,
    required this.packageId,
    required this.packageName,
    required this.plugin,
    required this.info,
  });

  int fid;

  String name;

  int speed;

  int eta;

  String formatEta;

  int bleft;

  int size;

  String formatSize;

  int percent;

  DownloadStatus status;

  String statusmsg;

  String formatWait;

  double waitUntil;

  int packageId;

  String packageName;

  String plugin;

  String info;

  @override
  bool operator ==(Object other) => identical(this, other) || other is DownloadInfo &&
    other.fid == fid &&
    other.name == name &&
    other.speed == speed &&
    other.eta == eta &&
    other.formatEta == formatEta &&
    other.bleft == bleft &&
    other.size == size &&
    other.formatSize == formatSize &&
    other.percent == percent &&
    other.status == status &&
    other.statusmsg == statusmsg &&
    other.formatWait == formatWait &&
    other.waitUntil == waitUntil &&
    other.packageId == packageId &&
    other.packageName == packageName &&
    other.plugin == plugin &&
    other.info == info;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (fid.hashCode) +
    (name.hashCode) +
    (speed.hashCode) +
    (eta.hashCode) +
    (formatEta.hashCode) +
    (bleft.hashCode) +
    (size.hashCode) +
    (formatSize.hashCode) +
    (percent.hashCode) +
    (status.hashCode) +
    (statusmsg.hashCode) +
    (formatWait.hashCode) +
    (waitUntil.hashCode) +
    (packageId.hashCode) +
    (packageName.hashCode) +
    (plugin.hashCode) +
    (info.hashCode);

  @override
  String toString() => 'DownloadInfo[fid=$fid, name=$name, speed=$speed, eta=$eta, formatEta=$formatEta, bleft=$bleft, size=$size, formatSize=$formatSize, percent=$percent, status=$status, statusmsg=$statusmsg, formatWait=$formatWait, waitUntil=$waitUntil, packageId=$packageId, packageName=$packageName, plugin=$plugin, info=$info]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'fid'] = this.fid;
      json[r'name'] = this.name;
      json[r'speed'] = this.speed;
      json[r'eta'] = this.eta;
      json[r'format_eta'] = this.formatEta;
      json[r'bleft'] = this.bleft;
      json[r'size'] = this.size;
      json[r'format_size'] = this.formatSize;
      json[r'percent'] = this.percent;
      json[r'status'] = this.status;
      json[r'statusmsg'] = this.statusmsg;
      json[r'format_wait'] = this.formatWait;
      json[r'wait_until'] = this.waitUntil;
      json[r'package_id'] = this.packageId;
      json[r'package_name'] = this.packageName;
      json[r'plugin'] = this.plugin;
      json[r'info'] = this.info;
    return json;
  }

  /// Returns a new [DownloadInfo] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static DownloadInfo? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'fid'), 'Required key "DownloadInfo[fid]" is missing from JSON.');
        assert(json[r'fid'] != null, 'Required key "DownloadInfo[fid]" has a null value in JSON.');
        assert(json.containsKey(r'name'), 'Required key "DownloadInfo[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "DownloadInfo[name]" has a null value in JSON.');
        assert(json.containsKey(r'speed'), 'Required key "DownloadInfo[speed]" is missing from JSON.');
        assert(json[r'speed'] != null, 'Required key "DownloadInfo[speed]" has a null value in JSON.');
        assert(json.containsKey(r'eta'), 'Required key "DownloadInfo[eta]" is missing from JSON.');
        assert(json[r'eta'] != null, 'Required key "DownloadInfo[eta]" has a null value in JSON.');
        assert(json.containsKey(r'format_eta'), 'Required key "DownloadInfo[format_eta]" is missing from JSON.');
        assert(json[r'format_eta'] != null, 'Required key "DownloadInfo[format_eta]" has a null value in JSON.');
        assert(json.containsKey(r'bleft'), 'Required key "DownloadInfo[bleft]" is missing from JSON.');
        assert(json[r'bleft'] != null, 'Required key "DownloadInfo[bleft]" has a null value in JSON.');
        assert(json.containsKey(r'size'), 'Required key "DownloadInfo[size]" is missing from JSON.');
        assert(json[r'size'] != null, 'Required key "DownloadInfo[size]" has a null value in JSON.');
        assert(json.containsKey(r'format_size'), 'Required key "DownloadInfo[format_size]" is missing from JSON.');
        assert(json[r'format_size'] != null, 'Required key "DownloadInfo[format_size]" has a null value in JSON.');
        assert(json.containsKey(r'percent'), 'Required key "DownloadInfo[percent]" is missing from JSON.');
        assert(json[r'percent'] != null, 'Required key "DownloadInfo[percent]" has a null value in JSON.');
        assert(json.containsKey(r'status'), 'Required key "DownloadInfo[status]" is missing from JSON.');
        assert(json[r'status'] != null, 'Required key "DownloadInfo[status]" has a null value in JSON.');
        assert(json.containsKey(r'statusmsg'), 'Required key "DownloadInfo[statusmsg]" is missing from JSON.');
        assert(json[r'statusmsg'] != null, 'Required key "DownloadInfo[statusmsg]" has a null value in JSON.');
        assert(json.containsKey(r'format_wait'), 'Required key "DownloadInfo[format_wait]" is missing from JSON.');
        assert(json[r'format_wait'] != null, 'Required key "DownloadInfo[format_wait]" has a null value in JSON.');
        assert(json.containsKey(r'wait_until'), 'Required key "DownloadInfo[wait_until]" is missing from JSON.');
        assert(json[r'wait_until'] != null, 'Required key "DownloadInfo[wait_until]" has a null value in JSON.');
        assert(json.containsKey(r'package_id'), 'Required key "DownloadInfo[package_id]" is missing from JSON.');
        assert(json[r'package_id'] != null, 'Required key "DownloadInfo[package_id]" has a null value in JSON.');
        assert(json.containsKey(r'package_name'), 'Required key "DownloadInfo[package_name]" is missing from JSON.');
        assert(json[r'package_name'] != null, 'Required key "DownloadInfo[package_name]" has a null value in JSON.');
        assert(json.containsKey(r'plugin'), 'Required key "DownloadInfo[plugin]" is missing from JSON.');
        assert(json[r'plugin'] != null, 'Required key "DownloadInfo[plugin]" has a null value in JSON.');
        assert(json.containsKey(r'info'), 'Required key "DownloadInfo[info]" is missing from JSON.');
        assert(json[r'info'] != null, 'Required key "DownloadInfo[info]" has a null value in JSON.');
        return true;
      }());

      return DownloadInfo(
        fid: mapValueOfType<int>(json, r'fid')!,
        name: mapValueOfType<String>(json, r'name')!,
        speed: mapValueOfType<int>(json, r'speed')!,
        eta: mapValueOfType<int>(json, r'eta')!,
        formatEta: mapValueOfType<String>(json, r'format_eta')!,
        bleft: mapValueOfType<int>(json, r'bleft')!,
        size: mapValueOfType<int>(json, r'size')!,
        formatSize: mapValueOfType<String>(json, r'format_size')!,
        percent: mapValueOfType<int>(json, r'percent')!,
        status: DownloadStatus.fromJson(json[r'status'])!,
        statusmsg: mapValueOfType<String>(json, r'statusmsg')!,
        formatWait: mapValueOfType<String>(json, r'format_wait')!,
        waitUntil: mapValueOfType<double>(json, r'wait_until')!,
        packageId: mapValueOfType<int>(json, r'package_id')!,
        packageName: mapValueOfType<String>(json, r'package_name')!,
        plugin: mapValueOfType<String>(json, r'plugin')!,
        info: mapValueOfType<String>(json, r'info')!,
      );
    }
    return null;
  }

  static List<DownloadInfo> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <DownloadInfo>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DownloadInfo.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, DownloadInfo> mapFromJson(dynamic json) {
    final map = <String, DownloadInfo>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = DownloadInfo.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of DownloadInfo-objects as value to a dart map
  static Map<String, List<DownloadInfo>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<DownloadInfo>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = DownloadInfo.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'fid',
    'name',
    'speed',
    'eta',
    'format_eta',
    'bleft',
    'size',
    'format_size',
    'percent',
    'status',
    'statusmsg',
    'format_wait',
    'wait_until',
    'package_id',
    'package_name',
    'plugin',
    'info',
  };
}

