import 'package:openapi_client/api.dart';
import 'package:omni_for_pyload/domain/models/pyload_api_failure.dart';
import 'package:omni_for_pyload/domain/models/server.dart';

enum Result { success, partial, failure }

/// Interface for PyLoad API interactions
///
/// Every method fails only with a [PyLoadApiFailure]; show its
/// [PyLoadApiFailure.message] to the user. Bulk actions report failed
/// packages through their [Result] instead.
abstract class IPyLoadApiRepository {
  /// Get the server status
  ///
  /// Returns a ServerStatus object with current server information.
  Future<ServerStatus> getServerStatus(Server server);

  /// Get the status of all currently running downloads
  ///
  /// Returns a list of DownloadInfo objects representing the current downloads.
  /// Returns an empty list if no downloads are active.
  Future<List<DownloadInfo>> getDownloadStatus(Server server);

  /// Get the queue packages (without file details)
  ///
  /// Returns a list of PackageData objects representing the packages in the queue.
  /// Does not include file details - use getPackageData for full details.
  Future<List<PackageData>> getQueue(Server server);

  /// Get the collector packages (without file details)
  ///
  /// Returns a list of PackageData objects representing the packages in the collector.
  /// Does not include file details - use getPackageData for full details.
  Future<List<PackageData>> getCollector(Server server);

  /// Get complete information about a package, including files
  ///
  /// Returns PackageData with complete information including all files.
  Future<PackageData> getPackageData(Server server, int packageId);

  /// Deletes packages by their IDs
  Future<void> deletePackages(Server server, List<int> packageIds);

  /// Restarts packages by their IDs
  ///
  /// Returns whether all, some or none of the packages were restarted.
  Future<Result> restartPackages(Server server, List<int> packageIds);

  /// Moves packages to a different destination (Queue or Collector)
  Future<Result> movePackages(
    Server server,
    List<int> packageIds,
    Destination destination,
  );

  /// Triggers archive extraction for given packages
  Future<Result> extractPackages(Server server, List<int> packageIds);

  /// Pauses the server (pauses all downloads)
  Future<void> pauseServer(Server server);

  /// Unpauses the server (resumes downloads)
  Future<void> unpauseServer(Server server);

  /// Stops all downloads
  Future<void> stopAllDownloads(Server server);

  /// Deletes all finished packages
  Future<void> deleteFinished(Server server);

  /// Restarts all failed packages
  Future<void> restartFailed(Server server);

  /// Uploads a container file (.dlc) to the server
  ///
  /// Parameters:
  /// - [server]: The server configuration
  /// - [fileName]: The name of the file (extension is important for decryption)
  /// - [fileBytes]: The file content as bytes
  Future<void> uploadContainer(
    Server server,
    String fileName,
    List<int> fileBytes,
    Destination destination,
  );

  /// Adds a new package with links to the server
  ///
  /// Parameters:
  /// - [server]: The server configuration
  /// - [name]: The name of the new package
  /// - [links]: List of URLs to add to the package
  /// - [destination]: Where to add the package (Queue or Collector)
  ///
  /// Returns the package ID of the created package
  Future<int> addPackage(
    Server server,
    String name,
    List<String> links,
    Destination destination,
  );

  /// Sets or updates the password for a specific package
  Future<void> setPackagePassword(
    Server server,
    int packageId,
    String password,
  );
}
