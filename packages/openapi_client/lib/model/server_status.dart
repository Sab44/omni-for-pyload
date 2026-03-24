//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi_client.api;

class ServerStatus {
  /// Returns a new [ServerStatus] instance.
  ServerStatus({
    required this.pause,
    required this.active,
    required this.queue,
    required this.total,
    required this.speed,
    required this.download,
    required this.reconnect,
    required this.captcha,
    required this.proxy,
  });

  bool pause;

  int active;

  int queue;

  int total;

  int speed;

  bool download;

  bool reconnect;

  bool captcha;

  bool proxy;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ServerStatus &&
    other.pause == pause &&
    other.active == active &&
    other.queue == queue &&
    other.total == total &&
    other.speed == speed &&
    other.download == download &&
    other.reconnect == reconnect &&
    other.captcha == captcha &&
    other.proxy == proxy;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (pause.hashCode) +
    (active.hashCode) +
    (queue.hashCode) +
    (total.hashCode) +
    (speed.hashCode) +
    (download.hashCode) +
    (reconnect.hashCode) +
    (captcha.hashCode) +
    (proxy.hashCode);

  @override
  String toString() => 'ServerStatus[pause=$pause, active=$active, queue=$queue, total=$total, speed=$speed, download=$download, reconnect=$reconnect, captcha=$captcha, proxy=$proxy]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'pause'] = this.pause;
      json[r'active'] = this.active;
      json[r'queue'] = this.queue;
      json[r'total'] = this.total;
      json[r'speed'] = this.speed;
      json[r'download'] = this.download;
      json[r'reconnect'] = this.reconnect;
      json[r'captcha'] = this.captcha;
      json[r'proxy'] = this.proxy;
    return json;
  }

  /// Returns a new [ServerStatus] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ServerStatus? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'pause'), 'Required key "ServerStatus[pause]" is missing from JSON.');
        assert(json[r'pause'] != null, 'Required key "ServerStatus[pause]" has a null value in JSON.');
        assert(json.containsKey(r'active'), 'Required key "ServerStatus[active]" is missing from JSON.');
        assert(json[r'active'] != null, 'Required key "ServerStatus[active]" has a null value in JSON.');
        assert(json.containsKey(r'queue'), 'Required key "ServerStatus[queue]" is missing from JSON.');
        assert(json[r'queue'] != null, 'Required key "ServerStatus[queue]" has a null value in JSON.');
        assert(json.containsKey(r'total'), 'Required key "ServerStatus[total]" is missing from JSON.');
        assert(json[r'total'] != null, 'Required key "ServerStatus[total]" has a null value in JSON.');
        assert(json.containsKey(r'speed'), 'Required key "ServerStatus[speed]" is missing from JSON.');
        assert(json[r'speed'] != null, 'Required key "ServerStatus[speed]" has a null value in JSON.');
        assert(json.containsKey(r'download'), 'Required key "ServerStatus[download]" is missing from JSON.');
        assert(json[r'download'] != null, 'Required key "ServerStatus[download]" has a null value in JSON.');
        assert(json.containsKey(r'reconnect'), 'Required key "ServerStatus[reconnect]" is missing from JSON.');
        assert(json[r'reconnect'] != null, 'Required key "ServerStatus[reconnect]" has a null value in JSON.');
        assert(json.containsKey(r'captcha'), 'Required key "ServerStatus[captcha]" is missing from JSON.');
        assert(json[r'captcha'] != null, 'Required key "ServerStatus[captcha]" has a null value in JSON.');
        assert(json.containsKey(r'proxy'), 'Required key "ServerStatus[proxy]" is missing from JSON.');
        assert(json[r'proxy'] != null, 'Required key "ServerStatus[proxy]" has a null value in JSON.');
        return true;
      }());

      return ServerStatus(
        pause: mapValueOfType<bool>(json, r'pause')!,
        active: mapValueOfType<int>(json, r'active')!,
        queue: mapValueOfType<int>(json, r'queue')!,
        total: mapValueOfType<int>(json, r'total')!,
        speed: mapValueOfType<int>(json, r'speed')!,
        download: mapValueOfType<bool>(json, r'download')!,
        reconnect: mapValueOfType<bool>(json, r'reconnect')!,
        captcha: mapValueOfType<bool>(json, r'captcha')!,
        proxy: mapValueOfType<bool>(json, r'proxy')!,
      );
    }
    return null;
  }

  static List<ServerStatus> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ServerStatus>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ServerStatus.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ServerStatus> mapFromJson(dynamic json) {
    final map = <String, ServerStatus>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ServerStatus.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ServerStatus-objects as value to a dart map
  static Map<String, List<ServerStatus>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ServerStatus>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ServerStatus.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'pause',
    'active',
    'queue',
    'total',
    'speed',
    'download',
    'reconnect',
    'captcha',
    'proxy',
  };
}

