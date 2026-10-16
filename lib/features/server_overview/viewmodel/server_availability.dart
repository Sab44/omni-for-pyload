/// Whether a server answered its last status check
enum ServerAvailability {
  /// Not checked yet, e.g. right after it was added or edited
  fetching,
  online,
  offline,
}
