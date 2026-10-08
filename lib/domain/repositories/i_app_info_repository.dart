/// Interface for information about the installed app
abstract class IAppInfoRepository {
  /// Get the app version as shown to users, e.g. `0.2.1`
  Future<String> getAppVersion();
}
