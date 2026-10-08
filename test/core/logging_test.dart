import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:omni_for_pyload/core/logging.dart';

void main() {
  group('setupLogging', () {
    late List<String> lines;

    setUp(() => lines = []);

    tearDown(() => setupLogging(level: Level.OFF, output: (_) {}));

    test('forwards records at or above the configured level', () async {
      setupLogging(level: Level.WARNING, output: lines.add);
      final log = Logger('Test');

      log.info('hidden');
      log.warning('shown');
      await pumpEventQueue();

      expect(lines, hasLength(1));
      expect(lines.single, contains('WARNING [Test] shown'));
    });

    test('replaces the previous listener when called again', () async {
      final firstLines = <String>[];
      setupLogging(level: Level.ALL, output: firstLines.add);
      setupLogging(level: Level.ALL, output: lines.add);

      Logger('Test').info('message');
      await pumpEventQueue();

      expect(firstLines, isEmpty);
      expect(lines, hasLength(1));
    });
  });

  group('formatLogRecord', () {
    test('includes level, logger name and message', () {
      final record = LogRecord(
        Level.INFO,
        'Service started',
        'ClickNLoadService',
        null,
        null,
        null,
        null,
      );

      expect(
        formatLogRecord(record),
        matches(
          r'^\d{2}:\d{2}:\d{2}\.\d{3} INFO \[ClickNLoadService\] '
          r'Service started$',
        ),
      );
    });

    test('appends error and stack trace', () {
      final stackTrace = StackTrace.current;
      final record = LogRecord(
        Level.SEVERE,
        'Failed',
        'Test',
        StateError('crash'),
        stackTrace,
      );

      final formatted = formatLogRecord(record);

      expect(formatted, contains('SEVERE [Test] Failed\nBad state: crash\n'));
      expect(formatted, endsWith(stackTrace.toString()));
    });
  });
}
