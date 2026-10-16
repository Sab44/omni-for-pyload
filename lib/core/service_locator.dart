import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:omni_for_pyload/data/repositories/app_info_repository.dart';
import 'package:omni_for_pyload/data/repositories/local_network_repository.dart';
import 'package:omni_for_pyload/data/repositories/pyload_api_repository.dart';
import 'package:omni_for_pyload/data/repositories/server_repository.dart';
import 'package:omni_for_pyload/data/repositories/settings_repository.dart';
import 'package:omni_for_pyload/domain/repositories/i_app_info_repository.dart';
import 'package:omni_for_pyload/domain/repositories/i_local_network_repository.dart';
import 'package:omni_for_pyload/domain/repositories/i_pyload_api_repository.dart';
import 'package:omni_for_pyload/domain/repositories/i_server_repository.dart';
import 'package:omni_for_pyload/domain/repositories/i_settings_repository.dart';
import 'package:omni_for_pyload/features/click_n_load/services/click_n_load_controller.dart';
import 'package:omni_for_pyload/features/click_n_load/services/click_n_load_platform.dart';

final getIt = GetIt.instance;

/// Registers all dependencies for the application
Future<void> setupServiceLocator() async {
  // Register repositories
  getIt.registerSingleton<IServerRepository>(ServerRepository());

  getIt.registerSingleton<IPyLoadApiRepository>(PyLoadApiRepository());

  getIt.registerSingleton<ISettingsRepository>(SettingsRepository());

  getIt.registerSingleton<IAppInfoRepository>(AppInfoRepository());

  getIt.registerSingleton<ILocalNetworkRepository>(LocalNetworkRepository());

  // The only place deciding whether Click'N'Load is available
  getIt.registerSingleton<ClickNLoadController>(
    ClickNLoadController(
      platform: Platform.isAndroid
          ? AndroidClickNLoadPlatform()
          : const UnsupportedClickNLoadPlatform(),
      serverRepository: getIt<IServerRepository>(),
    ),
  );
}
