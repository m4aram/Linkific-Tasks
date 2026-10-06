import 'dart:async';

import 'package:flutter/material.dart';

import '../debug/leak_tracker.dart';
import '../widgets/lab_card.dart';

class MemoryLabScreen extends StatefulWidget {
  const MemoryLabScreen({super.key});

  @override
  State<MemoryLabScreen> createState() => _MemoryLabScreenState();
}

class _MemoryLabScreenState extends State<MemoryLabScreen> {
  bool _fixed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Memory leak')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FixSwitch(fixed: _fixed, onChanged: (v) => setState(() => _fixed = v)),
          LabCard(
            title: 'Open and close the page several times',
            subtitle: 'The leaky page starts a Timer and a stream subscription and holds a 2 MB list.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: LeakTracker.activeTimers,
                  builder: (context, n, _) => Text('Timers still running: $n', style: Theme.of(context).textTheme.titleMedium),
                ),
                ValueListenableBuilder<int>(
                  valueListenable: LeakTracker.activeSubscriptions,
                  builder: (context, n, _) => Text('Subscriptions still listening: $n', style: Theme.of(context).textTheme.titleMedium),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    FilledButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(builder: (_) => LeakyPage(fixed: _fixed)),
                      ),
                      child: const Text('Open the page'),
                    ),
                    OutlinedButton(onPressed: LeakTracker.reset, child: const Text('Reset counters (display only)')),
                  ],
                ),
              ],
            ),
          ),
          const LabCard(
            title: 'How to find it with DevTools',
            child: Text(
              '1. Run in profile mode and open DevTools > Memory.\n'
                  '2. Open and close the page 5 times, then press the garbage-can icon (GC).\n'
                  '3. Take a snapshot and search for "_LeakyPageState": in the buggy version you still see 5 instances '
                  '(each one keeps a 2 MB list alive). In the fixed version there are 0.\n'
                  '4. The Dart console also prints "setState() called after dispose()" every second: the sign of a leaked Timer.',
            ),
          ),
        ],
      ),
    );
  }
}

class LeakyPage extends StatefulWidget {
  const LeakyPage({super.key, required this.fixed});

  final bool fixed;

  @override
  State<LeakyPage> createState() => _LeakyPageState();
}

class _LeakyPageState extends State<LeakyPage> {
  Timer? _timer;
  StreamSubscription<int>? _subscription;
  int _ticks = 0;
  int _events = 0;

  // About 2 MB. While the Timer or the subscription is alive, it keeps this State (and this list) in memory.
  final List<int> _bigData = List<int>.filled(250000, 1);

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      // BUG when the Timer is never cancelled: after the page closes this still runs and calls setState.
      setState(() => _ticks += _bigData.isEmpty ? 0 : 1);
    });
    LeakTracker.timerStarted();

    _subscription = LeakTracker.ticker.listen((_) => _events++);
    LeakTracker.subscriptionStarted();
  }

  @override
  void dispose() {
    if (widget.fixed) {
      // FIX: always cancel what you start.
      _timer?.cancel();
      LeakTracker.timerStopped();
      _subscription?.cancel();
      LeakTracker.subscriptionStopped();
    }
    // BUG (buggy version): nothing is cancelled, so both keep running and keep this State alive.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.fixed ? 'Fixed page' : 'Leaky page')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Ticks: $_ticks', style: Theme.of(context).textTheme.headlineMedium),
            Text('Stream events: $_events'),
            Text('Holding ${_bigData.length} integers (about 2 MB)'),
            const SizedBox(height: 16),
            const Text('Press back, then open the page again.'),
          ],
        ),
      ),
    );
  }
}