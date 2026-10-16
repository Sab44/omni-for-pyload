/// Identifies a server by IP (or hostname) and port
///
/// Two servers with the same IP and port are the same server, regardless of
/// their other settings.
class ServerId {
  final String ip;
  final int port;

  const ServerId(this.ip, this.port);

  @override
  bool operator ==(Object other) =>
      other is ServerId && ip == other.ip && port == other.port;

  @override
  int get hashCode => Object.hash(ip, port);

  @override
  String toString() => '$ip:$port';
}
