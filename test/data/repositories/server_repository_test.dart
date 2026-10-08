import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:omni_for_pyload/data/repositories/server_repository.dart';
import 'package:omni_for_pyload/domain/models/server.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ServerRepository repository;
  const secureStorage = FlutterSecureStorage();

  Server server(String ip, {int port = 8000}) => Server(
    ip: ip,
    port: port,
    apiKey: 'key-$ip:$port',
    protocol: 'http',
    allowInsecure: false,
  );

  Future<List<dynamic>> storedServers() async {
    final prefs = await SharedPreferences.getInstance();
    return jsonDecode(prefs.getString('servers')!) as List<dynamic>;
  }

  Future<String?> storedApiKey(String ip, int port) async {
    final value = await secureStorage.read(key: 'server_credentials:$ip:$port');
    if (value == null) return null;
    return (jsonDecode(value) as Map<String, dynamic>)['apiKey'] as String?;
  }

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    repository = ServerRepository();
  });

  group('API keys', () {
    test('are never written to shared preferences', () async {
      await repository.addServer(server('a'));
      await repository.addServer(server('b'));
      await repository.updateServer(server('a').copyWith(name: 'A'));
      await repository.addServer(server('c'));
      await repository.removeServer('c', 8000);

      for (final json in await storedServers()) {
        expect((json as Map<String, dynamic>)['apiKey'], isEmpty);
      }
    });

    test('are moved out of shared preferences when loading', () async {
      // Plain text key as written by earlier versions; secure storage has
      // a key for 'a' but not for 'b'
      SharedPreferences.setMockInitialValues({
        'servers': jsonEncode([server('a').toJson(), server('b').toJson()]),
      });
      FlutterSecureStorage.setMockInitialValues({
        'server_credentials:a:8000': jsonEncode({'apiKey': 'secure-key-a'}),
      });

      final servers = await repository.getAllServers();

      expect(servers.map((s) => s.apiKey), ['secure-key-a', 'key-b:8000']);
      expect(await storedApiKey('b', 8000), 'key-b:8000');
      for (final json in await storedServers()) {
        expect((json as Map<String, dynamic>)['apiKey'], isEmpty);
      }
    });
  });

  group('replaceServer', () {
    test('keeps the position and settings of the server', () async {
      await repository.addServer(server('a'));
      await repository.addServer(server('b'));
      await repository.addServer(server('c'));

      final updated = server('b').copyWith(name: 'Renamed', apiKey: 'new');
      await repository.replaceServer(server('b'), updated);

      final servers = await repository.getAllServers();
      expect(servers.map((s) => s.ip), ['a', 'b', 'c']);
      expect(servers[1], updated);
    });

    test('moves the API key when IP and port change', () async {
      await repository.addServer(server('a'));

      final updated = server('a2', port: 9000).copyWith(apiKey: 'moved');
      await repository.replaceServer(server('a'), updated);

      expect(await storedApiKey('a2', 9000), 'moved');
      expect(await storedApiKey('a', 8000), isNull);
      expect(await repository.getAllServers(), [updated]);
    });

    test('keeps the API key entry when IP and port are unchanged', () async {
      await repository.addServer(server('a'));

      await repository.replaceServer(
        server('a'),
        server('a').copyWith(apiKey: 'rotated'),
      );

      expect(await storedApiKey('a', 8000), 'rotated');
    });

    test('throws if the original server does not exist', () async {
      await expectLater(
        repository.replaceServer(server('missing'), server('other')),
        throwsStateError,
      );
    });
  });
}
