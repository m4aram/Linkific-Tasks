import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../debug/build_counter.dart';
import '../widgets/frame_hud.dart';
import '../widgets/lab_card.dart';

/// Pure CPU work. About 40-100 ms in debug mode for 6 million steps.
double heavyWork([int steps = 6000000]) {
  var sum = 0.0;
  for (var i = 1; i < steps; i++) {
    sum += math.sqrt(i);
  }
  return sum;
}

/// Top-level function: compute() needs one so it can run in another isolate.
double sumInIsolate(int steps) => heavyWork(steps);

class PerfLabScreen extends StatefulWidget {
  const PerfLabScreen({super.key});

  @override
  State<PerfLabScreen> createState() => _PerfLabScreenState();
}

class _PerfLabScreenState extends State<PerfLabScreen> {
  bool _fixed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Performance and jank')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const FrameHud(),
          FixSwitch(fixed: _fixed, onChanged: (v) => setState(() => _fixed = v)),
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'Debug mode is slow on purpose. For real numbers run: flutter run --profile (best on a real phone). '
              'In DevTools > Performance, a red frame is a slow frame.',
            ),
          ),
          LabCard(
            title: 'A) Expensive work inside build()',
            subtitle: 'Every tap rebuilds the screen, and the buggy build() repeats 6 million steps.',
            child: _HeavyBuildDemo(fixed: _fixed),
          ),
          LabCard(
            title: 'B) Column in a scroll view vs ListView.builder',
            subtitle: '2000 rows. Count how many rows were really built.',
            child: _ListDemo(fixed: _fixed),
          ),
          LabCard(
            title: 'C) Heavy computation: main thread vs compute()',
            subtitle: 'Watch the spinner at the top. It freezes when the UI thread is blocked.',
            child: const _IsolateDemo(),
          ),
          LabCard(
            title: 'D) Rebuild storm: const widgets',
            subtitle: 'Tap the button. The child does not depend on the counter, so it should not rebuild.',
            child: _StormDemo(fixed: _fixed),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------- A
class _HeavyBuildDemo extends StatefulWidget {
  const _HeavyBuildDemo({required this.fixed});

  final bool fixed;

  @override
  State<_HeavyBuildDemo> createState() => _HeavyBuildDemoState();
}

class _HeavyBuildDemoState extends State<_HeavyBuildDemo> {
  int _taps = 0;

  // FIX: computed once, the first time it is needed, and reused.
  late final double _cached = heavyWork();

  @override
  Widget build(BuildContext context) {
    // BUG: this runs on the UI thread at EVERY rebuild.
    final value = widget.fixed ? _cached : heavyWork();
    return Row(
      children: [
        FilledButton(onPressed: () => setState(() => _taps++), child: Text('Rebuild ($_taps)')),
        const SizedBox(width: 12),
        Expanded(child: Text('result: ${value.toStringAsFixed(0)}')),
      ],
    );
  }
}

// ---------------------------------------------------------------------------- B
class _RowTile extends StatelessWidget {
  const _RowTile(this.index);

  final int index;
  static int built = 0;

  @override
  Widget build(BuildContext context) {
    built++;
    return ListTile(dense: true, leading: CircleAvatar(radius: 12, child: Text('$index')), title: Text('Row $index'));
  }
}

class _ListDemo extends StatefulWidget {
  const _ListDemo({required this.fixed});

  final bool fixed;

  @override
  State<_ListDemo> createState() => _ListDemoState();
}

class _ListDemoState extends State<_ListDemo> {
  // The label has its own notifier, so updating it does NOT rebuild the rows (and recount them).
  final ValueNotifier<int> _builtLabel = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _RowTile.built = 0;
    _scheduleLabelUpdate();
  }

  @override
  void didUpdateWidget(covariant _ListDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
    _RowTile.built = 0;
    _scheduleLabelUpdate();
  }

  @override
  void dispose() {
    _builtLabel.dispose();
    super.dispose();
  }

  // The counter changes while building, so the label is refreshed after the frame.
  void _scheduleLabelUpdate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _builtLabel.value = _RowTile.built;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget list = widget.fixed
        // FIX: builds only the rows that are on the screen.
        ? ListView.builder(itemCount: 2000, itemBuilder: (context, i) => _RowTile(i))
        // BUG: a Column builds ALL 2000 rows immediately, even those that are far off screen.
        : SingleChildScrollView(child: Column(children: [for (var i = 0; i < 2000; i++) _RowTile(i)]));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ValueListenableBuilder<int>(
              valueListenable: _builtLabel,
              builder: (context, n, _) =>
                  Text('Rows built: $n of 2000', style: Theme.of(context).textTheme.titleSmall),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => _builtLabel.value = _RowTile.built,
              child: const Text('Update count'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(height: 200, child: list),
      ],
    );
  }
}

// ---------------------------------------------------------------------------- C
class _IsolateDemo extends StatefulWidget {
  const _IsolateDemo();

  @override
  State<_IsolateDemo> createState() => _IsolateDemoState();
}

class _IsolateDemoState extends State<_IsolateDemo> {
  static const int _steps = 60000000;
  String _text = 'Idle';
  bool _busy = false;

  Future<void> _onMainThread() async {
    setState(() {
      _busy = true;
      _text = 'Calculating on the main thread...';
    });
    await Future<void>.delayed(const Duration(milliseconds: 100)); // let the label appear first
    final watch = Stopwatch()..start();
    final result = sumInIsolate(_steps); // BLOCKS the UI thread: the spinner freezes
    if (!mounted) return;
    setState(() {
      _busy = false;
      _text = 'Main thread: ${watch.elapsedMilliseconds} ms (${result.toStringAsFixed(0)})';
    });
  }

  Future<void> _inIsolate() async {
    setState(() {
      _busy = true;
      _text = 'Calculating in another isolate...';
    });
    final watch = Stopwatch()..start();
    // FIX: compute() runs the function in a separate isolate. The UI keeps running.
    final result = await compute(sumInIsolate, _steps);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _text = 'compute(): ${watch.elapsedMilliseconds} ms (${result.toStringAsFixed(0)})';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_text),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            FilledButton(onPressed: _busy ? null : _onMainThread, child: const Text('Main thread')),
            FilledButton.tonal(onPressed: _busy ? null : _inIsolate, child: const Text('compute()')),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------- D
class _StormDemo extends StatefulWidget {
  const _StormDemo({required this.fixed});

  final bool fixed;

  @override
  State<_StormDemo> createState() => _StormDemoState();
}

class _StormDemoState extends State<_StormDemo> {
  int _taps = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FilledButton(onPressed: () => setState(() => _taps++), child: Text('Tap ($_taps)')),
            TextButton(onPressed: () => setState(BuildCounter.reset), child: const Text('Reset count')),
          ],
        ),
        // FIX: const. Flutter sees the SAME instance and skips rebuilding it.
        // BUG: without const, a new instance is created at every tap, so build() runs again.
        if (widget.fixed)
          const BuildCounter('Child')
        else
          // ignore: prefer_const_constructors
          BuildCounter('Child'),
      ],
    );
  }
}
