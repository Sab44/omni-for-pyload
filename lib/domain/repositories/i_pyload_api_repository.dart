import 'package:openapi_client/api.dart';
import 'package:omni_for_pyload/domain/models/server.dart';

enum Result { success, partial, failure }

/// Interface for PyLoad API interactions
abstract class IPyLoadApiRepository {
  /// Get the server status
  ///
  /// Returns a ServerStatus object with current server information.
  ///
  /// Throws: String with user-friendly error message on failure
  Future<ServerStatus> getServerStatus(Server server);

  /// Get the status of all currently running downloads
  ///
  /// Returns a list of DownloadInfo objects representing the current downloads.
  /// Returns an empty list if no downloads are active.
  ///
  /// Throws: String with user-friendly error message on failure
  Future<List<DownloadInfo>> getDownloadStatus(Server server);

  /// Get the queue data of all packages
  ///
  /// Returns a list of PackageData objects representing the packages in the queue.
  /// Returns an empty list if no packages are queued.
  ///
  /// Throws: String with user-friendly error message on failure
  Future<List<PackageData>> getQueueData(Server server);

  /// Get the collector data of all packages
  ///
  /// Returns a list of PackageData objects representing the packages in the collector.
  /// Returns an empty list if no packages are in the collector.
  ///
  /// Throws: String with user-friendly error message on failure
  Future<List<PackageData>> getCollectorData(Server server);

  /// Get the queue packages (without file details)
  ///
  /// Returns a list of PackageData objects representing the packages in the queue.
  /// Does not include file details - use getPackageData for full details.
  ///
  /// Throws: String with user-friendly error message on failure
  Future<List<PackageData>> getQueue(Server server);

  /// Get the collector packages (without file details)
  ///
  /// Returns a list of PackageData objects representing the packages in the collector.
  /// Does not include file details - use getPackageData for full details.
  ///
  /// Throws: String with user-friendly error message on failure
  Future<List<PackageData>> getCollector(Server server);

  /// Get complete information about a package, including files
  ///
  /// Returns PackageData with complete information including all files.
  ///
  /// Throws: String with user-friendly error message on failure
  Future<PackageData> getPackageData(Server server, int packageId);

  /// Deletes packages by their IDs
  ///
  /// Throws: String with user-friendly error message on failure
  Future<void> deletePackages(Server server, List<int> packageIds);

  /// Restarts packages by their IDs
  ///
  /// Returns a RestartResult indicating success, partial success, or failure.
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
  ///
  /// Throws: String with user-friendly error message on failure
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
  /// Throws: String with user-friendly error message on failure
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
