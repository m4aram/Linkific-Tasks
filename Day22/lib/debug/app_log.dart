import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

class LogEntry {
  const LogEntry(this.time, this.level, this.message);

  final DateTime time;
  final String level;
  final String message;
}

/// One place for logging. Each call writes to THREE places:
///  1) the console / IDE (debugPrint)
///  2) the DevTools Logging view (developer.log, with a name and a severity level)
///  3) the in-app console (the list shown on the Logging screen)
class AppLog {
  static const String name = 'DebugLab';

  static final ValueNotifier<List<LogEntry>> entries = ValueNotifier<List<LogEntry>>(const []);

  static void _add(String level, String message) {
    final next = [LogEntry(DateTime.now(), level, message), ...entries.value];
    entries.value = next.length > 60 ? next.sublist(0, 60) : next;
  }

  static void info(String message) {
    debugPrint('[INFO] $message');
    developer.log(message, name: name, level: 800);
    _add('INFO', message);
  }

  static void warning(String message) {
    debugPrint('[WARNING] $message');
    developer.log(message, name: name, level: 900);
    _add('WARNING', message);
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    debugPrint('[ERROR] $message ${error ?? ''}');
    developer.log(message, name: name, level: 1000, error: error, stackTrace: stackTrace);
    _add('ERROR', error == null ? message : '$message ($error)');
  }

  static void clear() => entries.value = const [];
}
