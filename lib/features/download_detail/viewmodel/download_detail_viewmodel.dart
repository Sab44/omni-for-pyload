import 'package:flutter/material.dart';
import 'package:openapi_client/api.dart';
import 'package:omni_for_pyload/domain/models/server.dart';
import 'package:omni_for_pyload/domain/repositories/i_pyload_api_repository.dart';

class DownloadDetailViewModel extends ChangeNotifier {
  final IPyLoadApiRepository _pyLoadApiRepository;
  final Server server;
  final int packageId;

  PackageData? _packageData;
  String? _error;
  bool _isLoading = false;

  DownloadDetailViewModel({
    required this.server,
    required this.packageId,
    required this._pyLoadApiRepository,
  }) {
    _fetchPackageData();
  }

  PackageData? get packageData => _packageData;
  String? get error => _error;
  bool get isLoading => _isLoading;

  /// Fetch the package data from the server
  Future<void> _fetchPackageData() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _packageData = await _pyLoadApiRepository.getPackageData(
        server,
        packageId,
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
