import 'dart:io';

import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:omni_for_pyload/domain/models/server.dart';
import 'package:omni_for_pyload/domain/repositories/i_local_network_repository.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;

class LocalNetworkRepository implements ILocalNetworkRepository {
  static final _log = Logger('LocalNetworkRepository');

  static const MethodChannel _channel = MethodChannel(
    'com.downloader.omni_for_pyload/local_network',
  );

  @override
  Future<bool> isAccessDenied(Server server) async {
    if (!Platform.isIOS) return false;

    try {
      final result = await _channel.invokeMethod<String>('checkAccess', {
        'host': server.ip,
        'port': server.port,
      });
      _log.fine(
        'Local network access for ${server.ip}:${server.port}: $result',
      );
      return result == 'denied';
    } on PlatformException catch (e, stackTrace) {
      _log.warning('Failed to check local network access', e, stackTrace);
      return false;
    }
  }

  @override
  Future<void> openAppSettings() async {
    final opened = await permission_handler.openAppSettings();
    if (!opened) {
      _log.warning('Failed to open app settings');
    }
  }
}
