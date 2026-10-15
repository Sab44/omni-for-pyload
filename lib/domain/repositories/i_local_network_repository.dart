import 'package:omni_for_pyload/domain/models/server.dart';

/// Interface for the platform's local network permission
abstract class ILocalNetworkRepository {
  /// Whether the app is not allowed to access [server] in the local network
  ///
  /// Only iOS restricts local network access. On first use this shows the
  /// system permission prompt and waits for the user's answer. Returns `false`
  /// if access is granted or could not be determined.
  Future<bool> isAccessDenied(Server server);

  /// Open the app's page in the system settings
  Future<void> openAppSettings();
}
