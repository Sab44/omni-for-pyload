class ClickNLoadServer {
  final String ip;
  final int port;
  final String protocol;
  final bool allowInsecureConnections;

  const ClickNLoadServer({
    required this.ip,
    required this.port,
    required this.protocol,
    required this.allowInsecureConnections,
  });

  /// Get the base URL for this ClickNLoadServer
  String get baseUrl {
    return '$protocol://$ip:$port';
  }

  @override
  bool operator ==(Object other) =>
      other is ClickNLoadServer &&
      ip == other.ip &&
      port == other.port &&
      protocol == other.protocol &&
      allowInsecureConnections == other.allowInsecureConnections;

  @override
  int get hashCode => Object.hash(ip, port, protocol, allowInsecureConnections);
}
