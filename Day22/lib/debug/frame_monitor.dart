import 'dart:ui' show FrameTiming;

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

@immutable
class FrameStats {
  const FrameStats({
    required this.frames,
    required this.jankFrames,
    required this.avgMs,
    required this.worstMs,
  });

  final int frames;
  final int jankFrames;
  final double avgMs;
  final double worstMs;

  static const FrameStats empty = FrameStats(frames: 0, jankFrames: 0, avgMs: 0, worstMs: 0);

  double get jankPercent => frames == 0 ? 0 : jankFrames * 100 / frames;

  /// A frame is "jank" when it took longer than the budget (16.7 ms is the budget at 60 Hz;
  /// at 120 Hz the budget is only 8.3 ms).
  factory FrameStats.fromDurations(List<double> ms, {double budgetMs = FrameMonitor.budgetMs}) {
    if (ms.isEmpty) return empty;
    var total = 0.0;
    var worst = 0.0;
    var jank = 0;
    for (final value in ms) {
      total += value;
      if (value > worst) worst = value;
      if (value > budgetMs) jank++;
    }
    return FrameStats(frames: ms.length, jankFrames: jank, avgMs: total / ms.length, worstMs: worst);
  }
}

/// A tiny profiler built into the app. It listens to the engine's frame timings
/// (the same data DevTools shows in the Performance tab) and counts slow frames.
class FrameMonitor {
  FrameMonitor._();

  static final FrameMonitor instance = FrameMonitor._();
  static const double budgetMs = 16.7;

  final ValueNotifier<FrameStats> stats = ValueNotifier<FrameStats>(FrameStats.empty);
  final List<double> _frames = [];
  bool _running = false;
  DateTime _lastPublish = DateTime.fromMillisecondsSinceEpoch(0);

  void start() {
    if (_running) return;
    _running = true;
    SchedulerBinding.instance.addTimingsCallback(_onTimings);
  }

  void reset() {
    _frames.clear();
    stats.value = FrameStats.empty;
  }

  void _onTimings(List<FrameTiming> timings) {
    for (final timing in timings) {
      _frames.add(timing.totalSpan.inMicroseconds / 1000.0);
    }
    if (_frames.length > 3000) _frames.removeRange(0, _frames.length - 3000);

    // Publish at most twice per second. Publishing rebuilds the HUD, which creates a new frame:
    // without this limit we would measure our own measuring.
    final now = DateTime.now();
    if (now.difference(_lastPublish).inMilliseconds < 500) return;
    _lastPublish = now;
    stats.value = FrameStats.fromDurations(_frames);
  }
}
