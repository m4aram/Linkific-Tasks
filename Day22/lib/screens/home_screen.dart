import 'package:flutter/material.dart';

import '../error/crash_reporter.dart';
import '../main.dart' show showPerformanceOverlay;
import 'error_lab_screen.dart';
import 'layout_lab_screen.dart';
import 'logging_lab_screen.dart';
import 'memory_lab_screen.dart';
import 'network_lab_screen.dart';
import 'perf_lab_screen.dart';
import 'state_lab_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _open(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug Lab')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Each lab contains an intentional bug and its fix. Find the bug with DevTools first, '
                'then switch to the FIXED version.\n\n'
                'Run with: flutter run  (debugging)\nRun with: flutter run --profile  (performance numbers)',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: showPerformanceOverlay,
            builder: (context, value, _) => SwitchListTile(
              title: const Text('Performance overlay'),
              subtitle: const Text('Two graphs on top of the app: raster thread and UI thread. A red bar is a slow frame.'),
              value: value,
              onChanged: (v) => showPerformanceOverlay.value = v,
            ),
          ),
          const SizedBox(height: 8),
          _Tile(Icons.terminal, '1. Logging and breakpoints', 'print, debugPrint, developer.log, a wrong total to debug',
              () => _open(context, const LoggingLabScreen())),
          _Tile(Icons.straighten, '2. Layout overflow', 'RenderFlex overflowed: yellow and black stripes',
              () => _open(context, const LayoutLabScreen())),
          _Tile(Icons.sync_problem, '3. State not updating', 'setState, in-place changes, missing keys',
              () => _open(context, const StateLabScreen())),
          _Tile(Icons.speed, '4. Performance and jank', 'expensive build, lists, isolates, rebuilds',
              () => _open(context, const PerfLabScreen())),
          _Tile(Icons.memory, '5. Memory leak', 'a timer and a subscription that never stop',
              () => _open(context, const MemoryLabScreen())),
          _Tile(Icons.network_check, '6. Network errors', '200, 404, no host, timeout, invalid JSON',
              () => _open(context, const NetworkLabScreen())),
          ValueListenableBuilder<List<CrashRecord>>(
            valueListenable: crashReporter.records,
            builder: (context, records, _) => _Tile(
              Icons.report_gmailerrorred,
              '7. Error handling and crash reports',
              '${records.length} error(s) caught so far',
              () => _open(context, const ErrorLabScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _Tile(this.icon, this.title, this.subtitle, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
