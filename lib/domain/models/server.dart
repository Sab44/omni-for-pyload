import 'package:omni_for_pyload/domain/models/clicknload_server.dart';
import 'package:omni_for_pyload/domain/models/server_id.dart';

class Server {
  final String ip;

  final int port;

  final String apiKey;

  final String protocol;

  final String name;

  final bool allowInsecure;

  /// Click'N'Load target, or null if Click'N'Load is not configured
  final ClickNLoadServer? clickNLoad;

  const Server({
    required this.ip,
    required this.port,
    required this.apiKey,
    required this.protocol,
    required this.allowInsecure,
    this.name = 'pyLoad',
    this.clickNLoad,
  });

  /// Servers are identified by IP and port
  ServerId get id => ServerId(ip, port);

  /// Check if Click'N'Load is configured for this server
  bool get hasClickNLoad => clickNLoad != null;

  /// Get the base URL for this server
  String get baseUrl {
    return '$protocol://$ip:$port';
  }

  /// Create a copy of this server with optional field overrides
  ///
  /// [clickNLoad] is a function so the configuration can also be cleared:
  /// `copyWith(clickNLoad: () => null)`.
  Server copyWith({
    String? ip,
    int? port,
    String? apiKey,
    String? protocol,
    bool? allowInsecure,
    String? name,
    ClickNLoadServer? Function()? clickNLoad,
  }) {
    return Server(
      ip: ip ?? this.ip,
      port: port ?? this.port,
      apiKey: apiKey ?? this.apiKey,
      protocol: protocol ?? this.protocol,
      allowInsecure: allowInsecure ?? this.allowInsecure,
      name: name ?? this.name,
      clickNLoad: clickNLoad != null ? clickNLoad() : this.clickNLoad,
    );
  }

  bool areMainConnectionParametersEqualTo(Server other) {
    return ip == other.ip &&
        port == other.port &&
        apiKey == other.apiKey &&
        protocol == other.protocol &&
        allowInsecure == other.allowInsecure;
  }

  Map<String, dynamic> toJson() {
    return {
      'ip': ip,
      'port': port,
      'apiKey': apiKey,
      'protocol': protocol,
      'name': name,
      'allowInsecure': allowInsecure,
      'clickNLoadIp': clickNLoad?.ip,
      'clickNLoadPort': clickNLoad?.port,
      'clickNLoadProtocol': clickNLoad?.protocol,
      'clickNLoadAllowInsecure': clickNLoad?.allowInsecureConnections,
    };
  }

  factory Server.fromJson(Map<String, dynamic> json) {
    final clickNLoadIp = json['clickNLoadIp'] as String?;
    final clickNLoadPort = json['clickNLoadPort'] as int?;
    final clickNLoadProtocol = json['clickNLoadProtocol'] as String?;
    final clickNLoadAllowInsecure = json['clickNLoadAllowInsecure'] as bool?;

    return Server(
      ip: json['ip'] as String,
      port: json['port'] as int,
      apiKey: json['apiKey'] as String,
      protocol: json['protocol'] as String,
      name: json['name'] as String? ?? 'pyLoad',
      allowInsecure: json['allowInsecure'] as bool? ?? false,
      clickNLoad:
          clickNLoadIp != null &&
              clickNLoadPort != null &&
              clickNLoadProtocol != null &&
              clickNLoadAllowInsecure != null
          ? ClickNLoadServer(
              ip: clickNLoadIp,
              port: clickNLoadPort,
              protocol: clickNLoadProtocol,
              allowInsecureConnections: clickNLoadAllowInsecure,
            )
          : null,
    );
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
          clickNLoad == other.clickNLoad;

  @override
  int get hashCode =>
      Object.hash(ip, port, apiKey, protocol, allowInsecure, name, clickNLoad);
}
