import 'package:flutter/material.dart';
import 'package:omni_for_pyload/core/logging.dart';
import 'package:omni_for_pyload/core/service_locator.dart';
import 'package:omni_for_pyload/domain/repositories/i_settings_repository.dart';

import 'features/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLogging();
  await setupServiceLocator();

  // Load settings before starting the app
  final settingsRepository = getIt<ISettingsRepository>();
  final settings = await settingsRepository.loadSettings();

  runApp(App(initialSettings: settings));
}
