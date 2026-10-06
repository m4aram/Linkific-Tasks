import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import '../error/crash_reporter.dart';
import '../widgets/lab_card.dart';

class ErrorLabScreen extends StatefulWidget {
  const ErrorLabScreen({super.key});

  @override
  State<ErrorLabScreen> createState() => _ErrorLabScreenState();
}

class _ErrorLabScreenState extends State<ErrorLabScreen> {
  bool _showBomb = false;

  void _handledError() {
    try {
      int.parse('not a number');
    } catch (e, stack) {
      // 1) try/catch: you expected the problem, so you handle it and tell the user.
      // 2) You can still REPORT it as a non-fatal error so you see how often it happens.
      crashReporter.recordError(e, stack, source: 'try/catch (handled)');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid number: handled and reported')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error handling')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          LabCard(
            title: 'Cause an error',
            subtitle: 'Each button is caught by a different hook (see lib/error/error_handling.dart).',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonal(
                  onPressed: _handledError,
                  child: const Text('try/catch'),
                ),
                FilledButton.tonal(
                  // Thrown inside a callback: Flutter catches it and calls FlutterError.onError.
                  onPressed: () => throw StateError('Error thrown inside onPressed'),
                  child: const Text('Throw in onPressed'),
                ),
                FilledButton.tonal(
                  // Nobody awaits this Future and nobody catches it: PlatformDispatcher.onError receives it.
                  onPressed: () => Future<void>.delayed(
                    const Duration(milliseconds: 200),
                        () => throw Exception('Async error nobody caught'),
                  ),
                  child: const Text('Uncaught async error'),
                ),
                FilledButton.tonal(
                  onPressed: () => setState(() => _showBomb = !_showBomb),
                  child: Text(_showBomb ? 'Remove broken widget' : 'Break build()'),
                ),
                FilledButton(
                  // A handled error reported to Firebase. It is sent when the app starts the next time.
                  onPressed: () {
                    FirebaseCrashlytics.instance.recordError(
                      Exception('Test error from Debug Lab'),
                      StackTrace.current,
                      reason: 'manual Crashlytics test',
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sent to Crashlytics. Restart the app so it uploads.')),
                    );
                  },
                  child: const Text('Send test error to Crashlytics'),
                ),
                OutlinedButton(
                  // A real crash: the app closes. The report is sent when you open the app again.
                  onPressed: () => FirebaseCrashlytics.instance.crash(),
                  child: const Text('Force a test crash'),
                ),
              ],
            ),
          ),
          if (_showBomb)
            const LabCard(
              title: 'A widget whose build() throws',
              subtitle: 'ErrorWidget.builder replaces it with a friendly widget instead of the red error screen.',
              child: _Bomb(),
            ),
          LabCard(
            title: 'Crash log (LocalCrashReporter)',
            subtitle: 'This is the list Crashlytics would receive. The same error repeating is stored once with a counter.',
            child: ValueListenableBuilder<List<CrashRecord>>(
              valueListenable: crashReporter.records,
              builder: (context, records, _) {
                if (records.isEmpty) return const Text('No errors yet.');
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final r in records.take(10))
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${r.fatal ? 'FATAL' : 'non-fatal'}  x${r.count}  ${r.source}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            Text(r.message, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    TextButton(onPressed: crashReporter.clear, child: const Text('Clear')),
                  ],
                );
              },
            ),
          ),
          const LabCard(
            title: 'Crashlytics',
            child: Text(
              'The app only talks to the CrashReporter interface. docs/CRASHLYTICS.md shows the Firebase setup and the '
                  'CrashlyticsReporter class to plug in. Crashlytics needs a Firebase project and a real build, '
                  'so it is documented here and enabled with one line.',
            ),
          ),
        ],
      ),
    );
  }
}

class _Bomb extends StatelessWidget {
  const _Bomb();

  @override
  Widget build(BuildContext context) {
    throw StateError('build() threw on purpose');
  }
}