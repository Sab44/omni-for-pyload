import 'package:flutter_test/flutter_test.dart';
import 'package:omni_for_pyload/domain/models/clicknload_server.dart';
import 'package:omni_for_pyload/domain/models/server.dart';
import 'package:omni_for_pyload/domain/models/server_id.dart';

void main() {
  Server server({String ip = '192.168.1.1', int port = 8000}) => Server(
    ip: ip,
    port: port,
    apiKey: 'key',
    protocol: 'http',
    allowInsecure: false,
  );

  group('ServerId', () {
    test('is equal for the same IP and port', () {
      expect(const ServerId('host', 8000), const ServerId('host', 8000));
      expect(
        const ServerId('host', 8000).hashCode,
        const ServerId('host', 8000).hashCode,
      );
    });

    test('differs when IP or port differ', () {
      expect(
        const ServerId('host', 8000),
        isNot(const ServerId('other', 8000)),
      );
      expect(const ServerId('host', 8000), isNot(const ServerId('host', 8001)));
    });

    test('identifies a server regardless of its other settings', () {
      final edited = server().copyWith(
        name: 'Renamed',
        apiKey: 'other',
        protocol: 'https',
      );

      expect(edited.id, server().id);
      expect(edited.id, const ServerId('192.168.1.1', 8000));
      expect(server(port: 9000).id, isNot(server().id));
    });
  });

  const clickNLoad = ClickNLoadServer(
    ip: '192.168.1.5',
    port: 9666,
    protocol: 'https',
    allowInsecureConnections: true,
  );

  group('copyWith', () {
    test('sets the Click\'N\'Load configuration', () {
      final configured = server().copyWith(clickNLoad: () => clickNLoad);

      expect(configured.clickNLoad, clickNLoad);
      expect(configured.hasClickNLoad, isTrue);
    });

    test('keeps the Click\'N\'Load configuration when not given', () {
      final configured = server().copyWith(clickNLoad: () => clickNLoad);

      expect(configured.copyWith(name: 'Renamed').clickNLoad, clickNLoad);
    });

    test('clears the Click\'N\'Load configuration', () {
      final configured = server().copyWith(clickNLoad: () => clickNLoad);

      final cleared = configured.copyWith(clickNLoad: () => null);

      expect(cleared.clickNLoad, isNull);
      expect(cleared.hasClickNLoad, isFalse);
      expect(configured.clickNLoad, clickNLoad);
    });
  });

  group('JSON', () {
    test('round-trips a server with Click\'N\'Load', () {
      final configured = server().copyWith(
        name: 'Home',
        clickNLoad: () => clickNLoad,
      );

      expect(Server.fromJson(configured.toJson()), configured);
    });

    test('round-trips a server with cleared Click\'N\'Load', () {
      final cleared = server()
          .copyWith(clickNLoad: () => clickNLoad)
          .copyWith(clickNLoad: () => null);

      final restored = Server.fromJson(cleared.toJson());

      expect(restored, cleared);
      expect(restored.clickNLoad, isNull);
    });

    test('reads servers saved by earlier versions', () {
      final restored = Server.fromJson({
        'ip': '192.168.1.1',
        'port': 8000,
        'apiKey': '',
        'protocol': 'http',
        'name': 'Home',
        'allowInsecure': true,
        'clickNLoadIp': '192.168.1.5',
        'clickNLoadPort': 9666,
        'clickNLoadProtocol': 'https',
        'clickNLoadAllowInsecure': true,
      });

      expect(restored.id, const ServerId('192.168.1.1', 8000));
      expect(restored.name, 'Home');
      expect(restored.allowInsecure, isTrue);
      expect(restored.clickNLoad, clickNLoad);
    });

    test('reads servers saved by earlier versions without Click\'N\'Load', () {
      final restored = Server.fromJson({
        'ip': '192.168.1.1',
        'port': 8000,
        'apiKey': '',
        'protocol': 'http',
        'clickNLoadIp': null,
        'clickNLoadPort': null,
        'clickNLoadProtocol': null,
        'clickNLoadAllowInsecure': null,
      });

      expect(restored.clickNLoad, isNull);
      expect(restored.name, 'pyLoad');
      expect(restored.allowInsecure, isFalse);
    });

    test('writes the same keys as earlier versions', () {
      final json = server().copyWith(clickNLoad: () => clickNLoad).toJson();

      expect(json, {
        'ip': '192.168.1.1',
        'port': 8000,
        'apiKey': 'key',
        'protocol': 'http',
        'name': 'pyLoad',
        'allowInsecure': false,
        'clickNLoadIp': '192.168.1.5',
        'clickNLoadPort': 9666,
        'clickNLoadProtocol': 'https',
        'clickNLoadAllowInsecure': true,
      });
    });
  });
}
