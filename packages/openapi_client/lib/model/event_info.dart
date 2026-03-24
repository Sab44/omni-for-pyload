//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi_client.api;

class EventInfo {
  /// Returns a new [EventInfo] instance.
  EventInfo({
    required this.eventname,
    this.id,
    this.type,
    this.destination,
  });

  String eventname;

  String? id;

  int? type;

  int? destination;

  @override
  bool operator ==(Object other) => identical(this, other) || other is EventInfo &&
    other.eventname == eventname &&
    other.id == id &&
    other.type == type &&
    other.destination == destination;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (eventname.hashCode) +
    (id == null ? 0 : id!.hashCode) +
    (type == null ? 0 : type!.hashCode) +
    (destination == null ? 0 : destination!.hashCode);

  @override
  String toString() => 'EventInfo[eventname=$eventname, id=$id, type=$type, destination=$destination]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'eventname'] = this.eventname;
    if (this.id != null) {
      json[r'id'] = this.id;
    } else {
      json[r'id'] = null;
    }
    if (this.type != null) {
      json[r'type'] = this.type;
    } else {
      json[r'type'] = null;
    }
    if (this.destination != null) {
      json[r'destination'] = this.destination;
    } else {
      json[r'destination'] = null;
    }
    return json;
  }

  /// Returns a new [EventInfo] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static EventInfo? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'eventname'), 'Required key "EventInfo[eventname]" is missing from JSON.');
        assert(json[r'eventname'] != null, 'Required key "EventInfo[eventname]" has a null value in JSON.');
        return true;
      }());

      return EventInfo(
        eventname: mapValueOfType<String>(json, r'eventname')!,
        id: mapValueOfType<String>(json, r'id'),
        type: mapValueOfType<int>(json, r'type'),
        destination: mapValueOfType<int>(json, r'destination'),
      );
    }
    return null;
  }

  static List<EventInfo> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EventInfo>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EventInfo.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, EventInfo> mapFromJson(dynamic json) {
    final map = <String, EventInfo>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = EventInfo.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of EventInfo-objects as value to a dart map
  static Map<String, List<EventInfo>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<EventInfo>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = EventInfo.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'eventname',
  };
}

