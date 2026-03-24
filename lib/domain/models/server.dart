import 'package:hive/hive.dart';
import 'package:omni_for_pyload/domain/models/clicknload_server.dart';

part 'server.g.dart';

@HiveType(typeId: 0)
class Server extends HiveObject {
  @HiveField(0)
  late String ip;

  @HiveField(1)
  late int port;

  @HiveField(2)
  late String apiKey;

  @HiveField(3)
  late String protocol;

  @HiveField(4)
  late String name;

  @HiveField(5)
  late bool allowInsecure;

  // Click'N'Load configuration (nullable - not configured by default)
  @HiveField(6)
  String? clickNLoadIp;

  @HiveField(7)
  int? clickNLoadPort;

  @HiveField(8)
  String? clickNLoadProtocol;

  @HiveField(9)
  bool? clickNLoadAllowInsecure;

  Server({
    required this.ip,
    required this.port,
    required this.apiKey,
    required this.protocol,
    required this.allowInsecure,
    this.name = 'pyLoad',
    this.clickNLoadIp,
    this.clickNLoadPort,
    this.clickNLoadProtocol,
    this.clickNLoadAllowInsecure,
  });

  /// Check if Click'N'Load is configured for this server
  bool get hasClickNLoad =>
      clickNLoadIp != null &&
      clickNLoadPort != null &&
      clickNLoadProtocol != null &&
      clickNLoadAllowInsecure != null;

  /// Get a ClickNLoadServer instance from the configured properties
  /// Returns null if Click'N'Load is not configured
  ClickNLoadServer? get clickNLoadServer {
    if (!hasClickNLoad) return null;
    return ClickNLoadServer(
      ip: clickNLoadIp!,
      port: clickNLoadPort!,
      protocol: clickNLoadProtocol!,
      allowInsecureConnections: clickNLoadAllowInsecure!,
    );
  }

  /// Configure Click'N'Load for this server
  void configureClickNLoad({
    required String ip,
    required int port,
    required String protocol,
    required bool allowInsecureConnections,
  }) {
    clickNLoadIp = ip;
    clickNLoadPort = port;
    clickNLoadProtocol = protocol;
    clickNLoadAllowInsecure = allowInsecureConnections;
  }

  /// Clear Click'N'Load configuration for this server
  void clearClickNLoad() {
    clickNLoadIp = null;
    clickNLoadPort = null;
    clickNLoadProtocol = null;
    clickNLoadAllowInsecure = null;
  }

  /// Get the base URL for this server
  String get baseUrl {
    return '$protocol://$ip:$port';
  }

  /// Create a copy of this server with optional field overrides
  Server copyWith({
    String? ip,
    int? port,
    String? apiKey,
    String? protocol,
    bool? allowInsecure,
    String? name,
    String? clickNLoadIp,
    int? clickNLoadPort,
    String? clickNLoadProtocol,
    bool? clickNLoadAllowInsecure,
  }) {
    return Server(
      ip: ip ?? this.ip,
      port: port ?? this.port,
      apiKey: apiKey ?? this.apiKey,
      protocol: protocol ?? this.protocol,
      allowInsecure: allowInsecure ?? this.allowInsecure,
      name: name ?? this.name,
      clickNLoadIp: clickNLoadIp ?? this.clickNLoadIp,
      clickNLoadPort: clickNLoadPort ?? this.clickNLoadPort,
      clickNLoadProtocol: clickNLoadProtocol ?? this.clickNLoadProtocol,
      clickNLoadAllowInsecure:
          clickNLoadAllowInsecure ?? this.clickNLoadAllowInsecure,
    );
  }

  bool areMainConnectionParametersEqualTo(Server other) {
    return ip == other.ip &&
        port == other.port &&
        apiKey == other.apiKey &&
        protocol == other.protocol &&
        allowInsecure == other.allowInsecure;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Server &&
          runtimeType == other.runtimeType &&
          ip == other.ip &&
          port == other.port &&
          apiKey == other.apiKey &&
          protocol == other.protocol &&
          allowInsecure == other.allowInsecure &&
          name == other.name &&
          clickNLoadIp == other.clickNLoadIp &&
          clickNLoadPort == other.clickNLoadPort &&
          clickNLoadProtocol == other.clickNLoadProtocol &&
          clickNLoadAllowInsecure == other.clickNLoadAllowInsecure;

  @override
  int get hashCode =>
      ip.hashCode ^
      port.hashCode ^
      apiKey.hashCode ^
      protocol.hashCode ^
      allowInsecure.hashCode ^
      name.hashCode ^
      clickNLoadIp.hashCode ^
      clickNLoadPort.hashCode ^
      clickNLoadProtocol.hashCode ^
      clickNLoadAllowInsecure.hashCode;
}
