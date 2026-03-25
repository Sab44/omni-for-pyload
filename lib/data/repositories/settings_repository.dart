import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:omni_for_pyload/domain/models/app_settings.dart';
import 'package:omni_for_pyload/domain/repositories/i_settings_repository.dart';

class SettingsRepository implements ISettingsRepository {
  static const String _settingsKey = 'app_settings';

  @override
  Future<AppSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_settingsKey);
    if (jsonString == null) {
      return const AppSettings();
    }
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return AppSettings.fromJson(json);
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(settings.toJson());
    await prefs.setString(_settingsKey, jsonString);
  }
}
