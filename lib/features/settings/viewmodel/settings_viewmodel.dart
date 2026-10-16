import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:omni_for_pyload/domain/models/app_settings.dart' as app_models;
import 'package:omni_for_pyload/domain/models/clicknload_server.dart';
import 'package:omni_for_pyload/domain/models/server.dart';
import 'package:omni_for_pyload/domain/repositories/i_app_info_repository.dart';
import 'package:omni_for_pyload/domain/repositories/i_settings_repository.dart';
import 'package:omni_for_pyload/domain/repositories/i_server_repository.dart';
import 'package:omni_for_pyload/features/app.dart' show themeNotifier;

class SettingsViewModel extends ChangeNotifier {
  static final _log = Logger('SettingsViewModel');

  final ISettingsRepository _settingsRepository;
  final IAppInfoRepository _appInfoRepository;
  final IServerRepository? _serverRepository;
  final Future<void> Function()? _onClickNLoadConfigChanged;
  app_models.AppSettings _settings = const app_models.AppSettings();
  Server? _server;
  String? _appVersion;
  bool _isDisposed = false;

  SettingsViewModel({
    required this._settingsRepository,
    required this._appInfoRepository,
    this._serverRepository,
    this._server,
    this._onClickNLoadConfigChanged,
  }) {
    _loadSettings();
    _loadAppVersion();
  }

  app_models.AppSettings get settings => _settings;
  app_models.ThemeMode get themeMode => _settings.themeMode;
  bool get skipSelectionScreenIfOnlyOneServer =>
      _settings.skipSelectionScreenIfOnlyOneServer;

  /// The installed app version, or null while loading or if it could not be read
  String? get appVersion => _appVersion;

  /// The server being configured, if any
  Server? get server => _server;

  /// Whether this settings screen has a server context (opened from ServerScreen)
  bool get hasServerContext => _server != null;

  Future<void> _loadSettings() async {
    _settings = await _settingsRepository.loadSettings();
    if (!_isDisposed) notifyListeners();
  }

  Future<void> _loadAppVersion() async {
    try {
      _appVersion = await _appInfoRepository.getAppVersion();
    } catch (e, stackTrace) {
      _log.warning('Could not read app version', e, stackTrace);
      return;
    }
    if (!_isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> setThemeMode(app_models.ThemeMode themeMode) async {
    _settings = _settings.copyWith(themeMode: themeMode);
    await _settingsRepository.saveSettings(_settings);
    notifyListeners();
    // Update the global theme notifier to trigger theme change in the app
    themeNotifier.value = themeMode;
  }

  Future<void> setSkipSelectionScreenIfOnlyOneServer(bool value) async {
    _settings = _settings.copyWith(skipSelectionScreenIfOnlyOneServer: value);
    await _settingsRepository.saveSettings(_settings);
    notifyListeners();
  }

  /// Update the Click'N'Load configuration for the server
  ///
  /// This will also stop the Click'N'Load service if running, so it can be
  /// restarted with the new configuration
  Future<void> updateClickNLoadConfig(
    String ip,
    int port,
    String protocol,
    bool allowInsecureConnections,
  ) async {
    await _saveClickNLoad(
      ClickNLoadServer(
        ip: ip,
        port: port,
        protocol: protocol,
        allowInsecureConnections: allowInsecureConnections,
      ),
    );
  }

  /// Remove the Click'N'Load configuration from the server
  Future<void> removeClickNLoadConfig() => _saveClickNLoad(null);

  /// Persist [clickNLoad] (null clears it) as the server's configuration
  Future<void> _saveClickNLoad(ClickNLoadServer? clickNLoad) async {
    final server = _server;
    final serverRepository = _serverRepository;
    if (server == null || serverRepository == null) return;

    // Stop the Click'N'Load service so it is restarted with the new config
    await _onClickNLoadConfigChanged?.call();

    final updated = server.copyWith(clickNLoad: () => clickNLoad);
    await serverRepository.updateServer(updated);
    _server = updated;
    notifyListeners();
  }
}
