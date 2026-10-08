import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:omni_for_pyload/domain/models/app_settings.dart';
import 'package:omni_for_pyload/domain/repositories/i_app_info_repository.dart';
import 'package:omni_for_pyload/domain/repositories/i_settings_repository.dart';
import 'package:omni_for_pyload/features/settings/viewmodel/settings_viewmodel.dart';

import 'settings_viewmodel_test.mocks.dart';

@GenerateMocks([ISettingsRepository, IAppInfoRepository])
void main() {
  group('SettingsViewModel', () {
    late MockISettingsRepository mockSettingsRepository;
    late MockIAppInfoRepository mockAppInfoRepository;

    setUp(() {
      mockSettingsRepository = MockISettingsRepository();
      mockAppInfoRepository = MockIAppInfoRepository();
      when(mockSettingsRepository.loadSettings())
          .thenAnswer((_) async => const AppSettings());
    });

    SettingsViewModel createViewModel() => SettingsViewModel(
      settingsRepository: mockSettingsRepository,
      appInfoRepository: mockAppInfoRepository,
    );

    group('appVersion', () {
      test('is null until the version is loaded', () {
        final completer = Completer<String>();
        when(mockAppInfoRepository.getAppVersion())
            .thenAnswer((_) => completer.future);

        final viewModel = createViewModel();

        expect(viewModel.appVersion, isNull);
        viewModel.dispose();
      });

      test('exposes the app version and notifies listeners', () async {
        when(mockAppInfoRepository.getAppVersion())
            .thenAnswer((_) async => '1.2.3');

        final viewModel = createViewModel();
        var notified = false;
        viewModel.addListener(() => notified = true);
        await pumpEventQueue();

        expect(viewModel.appVersion, '1.2.3');
        expect(notified, isTrue);
        viewModel.dispose();
      });

      test('stays null if the version cannot be read', () async {
        when(mockAppInfoRepository.getAppVersion())
            .thenThrow(Exception('platform error'));

        final viewModel = createViewModel();
        await pumpEventQueue();

        expect(viewModel.appVersion, isNull);
        viewModel.dispose();
      });

      test('does not notify after dispose', () async {
        final completer = Completer<String>();
        when(mockAppInfoRepository.getAppVersion())
            .thenAnswer((_) => completer.future);

        final viewModel = createViewModel();
        await pumpEventQueue();
        viewModel.dispose();

        completer.complete('1.2.3');
        await pumpEventQueue();
      });
    });
  });
}
