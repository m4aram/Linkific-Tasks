import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' show debugDumpApp;

import '../debug/app_log.dart';
import '../debug/order_calculator.dart';
import '../widgets/lab_card.dart';

class LoggingLabScreen extends StatefulWidget {
  const LoggingLabScreen({super.key});

  @override
  State<LoggingLabScreen> createState() => _LoggingLabScreenState();
}

class _LoggingLabScreenState extends State<LoggingLabScreen> {
  static const List<OrderItem> _order = [
    OrderItem('Keyboard', 70, 1),
    OrderItem('Mouse', 20, 1),
    OrderItem('Cable', 10, 1),
  ];

  bool _fixed = false;
  double? _total;

  void _calculate() {
    // Put a BREAKPOINT on the next line (click the grey margin next to the line number),
    // run in debug mode, press the button, then step with F8 / Step Over.
    final total = _fixed
        ? OrderCalculator.total(_order, discountPercent: 10)
        : OrderCalculator.buggyTotal(_order, discountPercent: 10);
    AppLog.info('Order total = $total (expected 90.0)');
    setState(() => _total = total);
  }

  @override
  Widget build(BuildContext context) {
    final longText = List.generate(40, (i) => 'line $i of a very long message').join(' | ');

    return Scaffold(
      appBar: AppBar(title: const Text('Logging and breakpoints')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          LabCard(
            title: '1. print vs debugPrint vs developer.log',
            subtitle: 'Open the Run console, then DevTools > Logging, and compare where each message appears.',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonal(
                  // ignore: avoid_print
                  onPressed: () => print('print(): a plain message'),
                  child: const Text('print()'),
                ),
                FilledButton.tonal(
                  // debugPrint throttles long output so the OS does not drop lines. It is not printed in release.
                  onPressed: () => debugPrint(longText, wrapWidth: 120),
                  child: const Text('debugPrint() long'),
                ),
                FilledButton.tonal(
                  onPressed: () => developer.log('a warning with a name and a level', name: 'DebugLab', level: 900),
                  child: const Text('developer.log()'),
                ),
                FilledButton.tonal(
                  onPressed: () => AppLog.error('Something failed', StateError('demo'), StackTrace.current),
                  child: const Text('log with error'),
                ),
                OutlinedButton(
                  onPressed: () => debugPrintStack(label: 'Who called me?', maxFrames: 6),
                  child: const Text('debugPrintStack()'),
                ),
                OutlinedButton(
                  onPressed: () => debugDumpApp(),
                  child: const Text('debugDumpApp()'),
                ),
              ],
            ),
          ),
          LabCard(
            title: '2. Breakpoint exercise',
            subtitle: 'Order: 70 + 20 + 10 with a 10% discount. The expected total is 90.0.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FixSwitch(fixed: _fixed, onChanged: (v) => setState(() {
                  _fixed = v;
                  _total = null; // clear the old result: press Calculate again
                })),
                FilledButton(onPressed: _calculate, child: const Text('Calculate total')),
                const SizedBox(height: 8),
                if (_total != null)
                  Text(
                    'Total: $_total  ${_total == 90.0 ? '(correct)' : '(WRONG: find the bug with a breakpoint)'}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
              ],
            ),
          ),
          LabCard(
            title: '3. assert (debug mode only)',
            subtitle: 'assert() runs only in debug mode. You see a message here, and the AssertionError in the console.',
            child: FilledButton.tonal(
              onPressed: () {
                // This trick detects debug mode: the code inside assert() runs only when asserts are enabled.
                var assertsEnabled = false;
                assert(() {
                  assertsEnabled = true;
                  return true;
                }());
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      assertsEnabled
                          ? 'Asserts are ON (debug mode): the next line throws AssertionError. Look at the console.'
                          : 'Asserts are OFF (profile/release): nothing is thrown.',
                    ),
                  ),
                );

                assert(_order.isEmpty, 'The order should be empty (it is not)'); // throws in debug only
                AppLog.info('assert did not run, so you are NOT in debug mode');
              },
              child: const Text('assert(order.isEmpty)'),
            ),
          ),
          LabCard(
            title: 'In-app console (AppLog)',
            subtitle: 'Mode: ${kDebugMode ? 'debug' : (kProfileMode ? 'profile' : 'release')}',
            child: ValueListenableBuilder<List<LogEntry>>(
              valueListenable: AppLog.entries,
              builder: (context, entries, _) {
                if (entries.isEmpty) return const Text('No logs yet.');
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final e in entries.take(12))
                      Text('${e.level}  ${e.message}', style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
                    TextButton(onPressed: AppLog.clear, child: const Text('Clear')),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}