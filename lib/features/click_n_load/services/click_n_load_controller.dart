import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:omni_for_pyload/core/utils/http_client_factory.dart';
import 'package:omni_for_pyload/domain/models/clicknload_server.dart';
import 'package:omni_for_pyload/domain/models/server.dart';
import 'package:omni_for_pyload/domain/models/server_id.dart';
import 'package:omni_for_pyload/domain/repositories/i_server_repository.dart';
import 'package:omni_for_pyload/features/click_n_load/services/click_n_load_platform.dart';
import 'package:omni_for_pyload/features/click_n_load/services/click_n_load_proxy.dart';

/// Result of attempting to start Click'N'Load
enum ClickNLoadStartResult {
  started,
  alreadyRunning,
  failed,
  notConfigured,
  unsupported,
}

/// What Click'N'Load is currently doing
sealed class ClickNLoadState {
  const ClickNLoadState();
}

final class ClickNLoadStopped extends ClickNLoadState {
  const ClickNLoadStopped();

  @override
  bool operator ==(Object other) => other is ClickNLoadStopped;

  @override
  int get hashCode => (ClickNLoadStopped).hashCode;
}

/// Forwarding requests for the server [serverId] to [target]
final class ClickNLoadRunning extends ClickNLoadState {
  final ServerId serverId;
  final ClickNLoadServer target;

  const ClickNLoadRunning(this.serverId, this.target);

  @override
  bool operator ==(Object other) =>
      other is ClickNLoadRunning &&
      serverId == other.serverId &&
      target == other.target;

  @override
  int get hashCode => Object.hash(serverId, target);
}

final class ClickNLoadUnsupported extends ClickNLoadState {
  const ClickNLoadUnsupported();

  @override
  bool operator ==(Object other) => other is ClickNLoadUnsupported;

  @override
  int get hashCode => (ClickNLoadUnsupported).hashCode;
}

typedef ClickNLoadProxyFactory = ClickNLoadProxy Function(
  ClickNLoadServer target,
);

ClickNLoadProxy _defaultProxyFactory(ClickNLoadServer target) =>
    ClickNLoadProxy(
      target: target,
      client: HttpClientFactory.createClient(target.allowInsecureConnections),
    );

/// The one Click'N'Load instance of the app: owns the local proxy, the native
/// service and the "forwarding to target X" state
class ClickNLoadController extends ChangeNotifier {
  static final _log = Logger('ClickNLoadController');

  final ClickNLoadPlatform _platform;
  final IServerRepository _serverRepository;
  final ClickNLoadProxyFactory _proxyFactory;
  ClickNLoadProxy? _proxy;
  late ClickNLoadState _state;
  Future<void> _lastOperation = Future.value();

  ClickNLoadController({
    required this._platform,
    required this._serverRepository,
    this._proxyFactory = _defaultProxyFactory,
  }) {
    _state = _platform.isSupported
        ? const ClickNLoadStopped()
        : const ClickNLoadUnsupported();
    _platform.onServiceStopped = _onServiceStopped;
  }

  ClickNLoadState get state => _state;

  /// Whether Click'N'Load can run on this platform at all
  bool get isSupported => _platform.isSupported;

  /// Start forwarding to the Click'N'Load target stored for the server
  /// [serverId]
  ///
  /// The configuration is read from the server repository, so a removed
  /// server or a cleared configuration reports
  /// [ClickNLoadStartResult.notConfigured]. If it already forwards to another
  /// target, it switches over.
  Future<ClickNLoadStartResult> start(ServerId serverId) =>
      _serialized(() async {
        final server = await _serverRepository.getServer(serverId);
        if (server == null) return ClickNLoadStartResult.notConfigured;
        return _start(server);
      });

  /// Stop forwarding and the native service
  Future<void> stop() => _serialized(_stop);

  /// Stop if running for the server [serverId], e.g. because it is removed
  Future<void> stopFor(ServerId serverId) => _serialized(() async {
    if (isRunningFor(serverId)) await _stop();
  });

  /// Whether it currently forwards requests for the server [serverId]
  bool isRunningFor(ServerId serverId) => switch (_state) {
    ClickNLoadRunning(serverId: final runningId) => runningId == serverId,
    _ => false,
  };

  /// Save [clickNLoad] (null clears it) as the configuration of the server
  /// [serverId]
  ///
  /// If Click'N'Load is running for that server, it is stopped before saving
  /// and restarted against the new target. Returns the saved server, or null
  /// if the server no longer exists.
  Future<Server?> reconfigure(
    ServerId serverId,
    ClickNLoadServer? clickNLoad,
  ) => _serialized(() async {
    final server = await _serverRepository.getServer(serverId);
    if (server == null) {
      _log.warning('Cannot configure Click\'N\'Load of removed server');
      return null;
    }

    final wasRunning = isRunningFor(serverId);
    if (wasRunning) await _stop();

    final updated = server.copyWith(clickNLoad: () => clickNLoad);
    await _serverRepository.updateServer(updated);

    if (wasRunning && clickNLoad != null) {
      final result = await _start(updated);
      if (result != ClickNLoadStartResult.started) {
        _log.warning('Could not restart Click\'N\'Load: $result');
      }
    }
    return updated;
  });

  /// Run [operation] after all previously requested operations finished, so
  /// e.g. a double tap cannot start two proxies
  Future<T> _serialized<T>(Future<T> Function() operation) {
    final result = _lastOperation.then((_) => operation());
    _lastOperation = result.then((_) {}, onError: (_) {});
    return result;
  }

  Future<ClickNLoadStartResult> _start(Server server) async {
    if (!_platform.isSupported) return ClickNLoadStartResult.unsupported;
    final target = server.clickNLoad;
    if (target == null) return ClickNLoadStartResult.notConfigured;

    if (_state == ClickNLoadRunning(server.id, target)) {
      if (await _isServiceRunning()) {
        return ClickNLoadStartResult.alreadyRunning;
      }
      _log.info('Native service is gone, restarting');
    }
    await _stopProxy();

    final proxy = _proxyFactory(target);
    try {
      await _platform.startService();
      await proxy.start();
    } catch (e, stackTrace) {
      _log.severe('Error starting Click\'N\'Load', e, stackTrace);
      await proxy.stop();
      await _stopService();
      return ClickNLoadStartResult.failed;
    }
    _proxy = proxy;
    _setState(ClickNLoadRunning(server.id, target));
    _log.info('Click\'N\'Load started for ${target.baseUrl}');
    return ClickNLoadStartResult.started;
  }

  Future<bool> _isServiceRunning() async {
    try {
      return await _platform.isServiceRunning();
    } catch (e, stackTrace) {
      _log.warning('Error checking native service status', e, stackTrace);
      return false;
    }
  }

  Future<void> _stopService() async {
    try {
      await _platform.stopService();
    } catch (e, stackTrace) {
      _log.warning('Error stopping native service', e, stackTrace);
    }
  }

  Future<void> _stop() async {
    if (_state is! ClickNLoadRunning) return;
    await _stopProxy();
    await _stopService();
    _log.info('Click\'N\'Load stopped');
  }

  void _onServiceStopped() {
    _log.info('Native service stopped, stopping proxy');
    _serialized(_stopProxy);
  }

  Future<void> _stopProxy() async {
    final proxy = _proxy;
    _proxy = null;
    await proxy?.stop();
    if (_state is ClickNLoadRunning) _setState(const ClickNLoadStopped());
  }

  void _setState(ClickNLoadState state) {
    if (state == _state) return;
    _state = state;
    notifyListeners();
  }
}
