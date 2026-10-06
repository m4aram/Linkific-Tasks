import 'dart:async';

import 'package:flutter/foundation.dart';

/// Counts the timers and subscriptions that are STILL running.
/// A leaky screen never decrements them, so the numbers keep growing.
class LeakTracker {
  static final ValueNotifier<int> activeTimers = ValueNotifier<int>(0);
  static final ValueNotifier<int> activeSubscriptions = ValueNotifier<int>(0);

  // The real counters. The notifiers above are only the copy that the screen listens to.
  static int _timers = 0;
  static int _subscriptions = 0;

  static void timerStarted() {
    _timers++;
    _publish();
  }

  static void timerStopped() {
    _timers--;
    _publish();
  }

  static void subscriptionStarted() {
    _subscriptions++;
    _publish();
  }

  static void subscriptionStopped() {
    _subscriptions--;
    _publish();
  }

  /// initState() and dispose() run while Flutter is building or tearing down the widget tree.
  /// Changing a ValueNotifier at that moment makes the listening screen call setState in a forbidden
  /// phase, so the update fails silently and the old number stays on the screen.
  /// A microtask runs after the current frame work is finished, which is safe.
  static void _publish() {
    scheduleMicrotask(() {
      activeTimers.value = _timers;
      activeSubscriptions.value = _subscriptions;
    });
  }

  /// Resets the numbers on the screen. It does NOT stop the timers that are really running.
  static void reset() {
    _timers = 0;
    _subscriptions = 0;
    activeTimers.value = 0;
    activeSubscriptions.value = 0;
  }

  static final StreamController<int> _controller = StreamController<int>.broadcast();
  static Timer? _driver;

  /// A global stream (it lives as long as the app), like a socket or a location stream.
  static Stream<int> get ticker {
    _driver ??= Timer.periodic(const Duration(seconds: 1), (t) => _controller.add(t.tick));
    return _controller.stream;
  }
}