import 'package:flutter/material.dart';

import '../debug/frame_monitor.dart';

/// A heads-up display with live frame statistics (a mini version of DevTools > Performance).
/// The spinner keeps frames coming, so it visibly stutters when the UI thread is blocked.
class FrameHud extends StatelessWidget {
  const FrameHud({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.inverseSurface,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: ValueListenableBuilder<FrameStats>(
          valueListenable: FrameMonitor.instance.stats,
          builder: (context, s, _) {
            final style = TextStyle(color: theme.colorScheme.onInverseSurface, fontFamily: 'monospace', fontSize: 12);
            return Row(
              children: [
                SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 3, color: theme.colorScheme.onInverseSurface),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'frames ${s.frames}   jank ${s.jankFrames} (${s.jankPercent.toStringAsFixed(0)}%)\n'
                    'avg ${s.avgMs.toStringAsFixed(1)} ms   worst ${s.worstMs.toStringAsFixed(0)} ms   budget ${FrameMonitor.budgetMs} ms',
                    style: style,
                  ),
                ),
                IconButton(
                  tooltip: 'Reset',
                  color: theme.colorScheme.onInverseSurface,
                  icon: const Icon(Icons.restart_alt),
                  onPressed: FrameMonitor.instance.reset,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
