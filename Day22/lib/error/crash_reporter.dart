import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

class CrashRecord {
  const CrashRecord({
    required this.time,
    required this.source,
    required this.message,
    required this.stack,
    required this.fatal,
    this.count = 1,
  });

  final DateTime time;
  final String source;
  final String message;
  final String stack;
  final bool fatal;
  final int count;

  CrashRecord copyWith({int? count, DateTime? time}) => CrashRecord(
    time: time ?? this.time,
    source: source,
    message: message,
    stack: stack,
    fatal: fatal,
    count: count ?? this.count,
  );
}

/// The app talks to this interface only. To use Firebase Crashlytics, write a class that
/// implements it (see docs/CRASHLYTICS.md) and change the line at the bottom of this file.
abstract class CrashReporter {
  void recordFlutterError(FlutterErrorDetails details);

  void recordError(Object error, StackTrace? stack, {required String source, bool fatal = false});

  /// Breadcrumbs: short notes saved with the next crash report ("user opened screen X").
  void log(String message);
}

/// Keeps the reports in memory so you can see them on the Error screen.
class LocalCrashReporter implements CrashReporter {
  final ValueNotifier<List<CrashRecord>> records = ValueNotifier<List<CrashRecord>>(const []);
  final List<String> breadcrumbs = [];

  // The real list. `records` is only the published copy that the UI listens to.
  List<CrashRecord> _current = const [];
  bool _publishScheduled = false;

  /// An error can be reported while Flutter is building, laying out or painting a frame
  /// (a RenderFlex overflow is reported during layout). Changing a ValueNotifier at that moment
  /// makes listening widgets call setState during the frame, which throws "Build scheduled during frame".
  /// So during a frame we publish after the frame ends.
  bool get _insideFrame {
    try {
      return SchedulerBinding.instance.schedulerPhase != SchedulerPhase.idle;
    } catch (_) {
      return false; // no binding (plain unit tests): publish immediately
    }
  }

  void _publish() {
    if (!_insideFrame) {
      records.value = _current;
      return;
    }
    if (_publishScheduled) return;
    _publishScheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _publishScheduled = false;
      records.value = _current;
    });
  }

  void _add(CrashRecord record) {
    final current = _current;
    // The same error repeating (for example every second) is stored once with a counter.
    if (current.isNotEmpty && current.first.message == record.message && current.first.source == record.source) {
      _current = [current.first.copyWith(count: current.first.count + 1, time: record.time), ...current.skip(1)];
    } else {
      final next = [record, ...current];
      _current = next.length > 50 ? next.sublist(0, 50) : next;
    }
    _publish();
  }

  @override
  void recordFlutterError(FlutterErrorDetails details) {
    _add(CrashRecord(
      time: DateTime.now(),
      source: 'FlutterError.onError',
      message: details.exceptionAsString(),
      stack: (details.stack ?? StackTrace.empty).toString(),
      fatal: false,
    ));
  }

  @override
  void recordError(Object error, StackTrace? stack, {required String source, bool fatal = false}) {
    _add(CrashRecord(
      time: DateTime.now(),
      source: source,
      message: error.toString(),
      stack: (stack ?? StackTrace.empty).toString(),
      fatal: fatal,
    ));
  }

  @override
  void log(String message) {
    breadcrumbs.add('${DateTime.now().toIso8601String()} $message');
    if (breadcrumbs.length > 30) breadcrumbs.removeAt(0);
  }

  void clear() {
    _current = const [];
    _publish();
  }
}

/// The one reporter used by the whole app. Replace with CrashlyticsReporter() to use Firebase.
final LocalCrashReporter crashReporter = LocalCrashReporter();