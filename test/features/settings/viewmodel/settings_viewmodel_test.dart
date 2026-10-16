import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:omni_for_pyload/domain/models/app_settings.dart';
import 'package:omni_for_pyload/domain/models/clicknload_server.dart';
import 'package:omni_for_pyload/domain/models/server.dart';
import 'package:omni_for_pyload/domain/repositories/i_app_info_repository.dart';
import 'package:omni_for_pyload/domain/repositories/i_server_repository.dart';
import 'package:omni_for_pyload/domain/repositories/i_settings_repository.dart';
import 'package:omni_for_pyload/features/click_n_load/services/click_n_load_controller.dart';
import 'package:omni_for_pyload/features/click_n_load/services/click_n_load_proxy.dart';
import 'package:omni_for_pyload/features/settings/viewmodel/settings_viewmodel.dart';

import '../../click_n_load/fake_click_n_load_platform.dart';
import 'settings_viewmodel_test.mocks.dart';

@GenerateMocks([ISettingsRepository, IAppInfoRepository, IServerRepository])
void main() {
  group('SettingsViewModel', () {
    late MockISettingsRepository mockSettingsRepository;
    late MockIAppInfoRepository mockAppInfoRepository;
    late MockIServerRepository mockServerRepository;

    setUp(() {
      mockSettingsRepository = MockISettingsRepository();
      mockAppInfoRepository = MockIAppInfoRepository();
      mockServerRepository = MockIServerRepository();
      when(mockSettingsRepository.loadSettings())
          .thenAnswer((_) async => const AppSettings());
      when(mockAppInfoRepository.getAppVersion())
          .thenAnswer((_) async => '1.2.3');
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

    group('Click\'N\'Load configuration', () {
      const clickNLoad = ClickNLoadServer(
        ip: '192.168.1.5',
        port: 9666,
        protocol: 'https',
        allowInsecureConnections: true,
      );
      const server = Server(
        ip: '192.168.1.1',
        port: 8000,
        apiKey: 'key',
        protocol: 'http',
        allowInsecure: false,
      );

      late FakeClickNLoadPlatform platform;
      late ClickNLoadController controller;

      setUp(() {
        platform = FakeClickNLoadPlatform();
        controller = ClickNLoadController(
          platform: platform,
          serverRepository: mockServerRepository,
          proxyFactory: (target) => ClickNLoadProxy(
            target: target,
            client: MockClient((_) async => http.Response('ok', 200)),
            port: 0,
          ),
        );
      });

      tearDown(() => controller.stop());

      SettingsViewModel createServerViewModel(Server server) {
        when(mockServerRepository.getServer(server.id))
            .thenAnswer((_) async => server);
        return SettingsViewModel(
          settingsRepository: mockSettingsRepository,
          appInfoRepository: mockAppInfoRepository,
          clickNLoadController: controller,
          server: server,
        );
      }

      test('offers Click\'N\'Load only where it is supported', () {
        expect(createServerViewModel(server).isClickNLoadSupported, isTrue);

        controller = ClickNLoadController(
          platform: FakeClickNLoadPlatform(isSupported: false),
          serverRepository: mockServerRepository,
        );
        expect(createServerViewModel(server).isClickNLoadSupported, isFalse);
      });

      test('saving persists and exposes the new configuration', () async {
        final viewModel = createServerViewModel(server);

        await viewModel.updateClickNLoadConfig(
          '192.168.1.5',
          9666,
          'https',
          true,
        );

        final expected = server.copyWith(clickNLoad: () => clickNLoad);
        verify(mockServerRepository.updateServer(expected)).called(1);
        expect(viewModel.server, expected);
        viewModel.dispose();
      });

      test('saving while running restarts against the new target', () async {
        const oldTarget = ClickNLoadServer(
          ip: '192.168.1.4',
          port: 9666,
          protocol: 'http',
          allowInsecureConnections: false,
        );
        final running = server.copyWith(clickNLoad: () => oldTarget);
        final viewModel = createServerViewModel(running);
        await controller.start(running.id);

        await viewModel.updateClickNLoadConfig(
          '192.168.1.5',
          9666,
          'https',
          true,
        );

        expect(controller.state, ClickNLoadRunning(server.id, clickNLoad));
        expect(platform.isRunning, isTrue);
        viewModel.dispose();
      });

      test('removing persists and exposes the cleared configuration', () async {
        final configured = server.copyWith(clickNLoad: () => clickNLoad);
        final viewModel = createServerViewModel(configured);
        await controller.start(configured.id);

        await viewModel.removeClickNLoadConfig();

        verify(mockServerRepository.updateServer(server)).called(1);
        expect(viewModel.server, server);
        expect(viewModel.server!.hasClickNLoad, isFalse);
        expect(controller.state, const ClickNLoadStopped());
        viewModel.dispose();
      });
    });
  });
}
