import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

StreamSubscription<LogRecord>? _subscription;

/// Configures the root logger. Call once at app start.
///
/// Debug and profile builds log everything; release builds log only
/// [Level.WARNING] and above, so request details (URLs, Click'N'Load payloads)
/// never reach the device log of a release build.
void setupLogging({
  Level level = kReleaseMode ? Level.WARNING : Level.ALL,
  void Function(String line) output = _debugPrintLines,
}) {
  Logger.root.level = level;
  _subscription?.cancel();
  _subscription = Logger.root.onRecord.listen(
    (record) => output(formatLogRecord(record)),
  );
}

/// Formats a record as `HH:mm:ss.SSS LEVEL [logger] message`, followed by the
/// error and stack trace if present.
String formatLogRecord(LogRecord record) {
  final time = record.time.toIso8601String().substring(11, 23);
  final buffer = StringBuffer(
    '$time ${record.level.name} [${record.loggerName}] ${record.message}',
  );
  if (record.error != null) buffer.write('\n${record.error}');
  if (record.stackTrace != null) buffer.write('\n${record.stackTrace}');
  return buffer.toString();
}

void _debugPrintLines(String line) => debugPrint(line);
