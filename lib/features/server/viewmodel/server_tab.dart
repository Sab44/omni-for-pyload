import 'package:openapi_client/api.dart';

/// The tabs of the server screen, in display order
enum ServerTab {
  /// Active downloads
  overview(destination: null),
  queue(destination: Destination.QUEUE),
  collector(destination: Destination.COLLECTOR);

  /// Where the packages listed on this tab live; null if it lists none
  final Destination? destination;

  const ServerTab({required this.destination});

  bool get listsPackages => destination != null;

  /// The tab that lists the packages of [destination]
  static ServerTab forDestination(Destination destination) =>
      values.firstWhere((tab) => tab.destination == destination);

  /// Where selected packages of this tab are moved to; null if they can't be
  /// moved
  ServerTab? get moveTarget => switch (this) {
    ServerTab.overview => null,
    ServerTab.queue => ServerTab.collector,
    ServerTab.collector => ServerTab.queue,
  };
}
