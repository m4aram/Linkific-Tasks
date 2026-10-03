import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/counter_providers.dart';

class CompareScreen extends StatelessWidget {
  const CompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('setState vs Riverpod')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _SetStateCard(),
          SizedBox(height: 12),
          _RiverpodCard(),
          SizedBox(height: 12),
          _AccessStylesCard(),
          SizedBox(height: 12),
          _SummaryNote(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// A) setState: the whole widget rebuilds, and the state cannot be shared.
// ---------------------------------------------------------------------------
class _SetStateCard extends StatefulWidget {
  const _SetStateCard();

  @override
  State<_SetStateCard> createState() => _SetStateCardState();
}

class _SetStateCardState extends State<_SetStateCard> {
  int _count = 0;
  int _builds = 0;

  @override
  Widget build(BuildContext context) {
    _builds++;
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('A) setState', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('$_count', style: theme.textTheme.displaySmall),
            Text('Whole card built: $_builds time(s)'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                FilledButton(onPressed: () => setState(() => _count++), child: const Text('+1')),
                OutlinedButton(onPressed: () => setState(() => _count = 0), child: const Text('Reset')),
              ],
            ),
            const SizedBox(height: 8),
            const Text('The state lives inside this widget. Other screens cannot use it.'),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// B) Riverpod: only the Consumer part rebuilds.
// ---------------------------------------------------------------------------
class _RiverpodCard extends ConsumerStatefulWidget {
  const _RiverpodCard();

  @override
  ConsumerState<_RiverpodCard> createState() => _RiverpodCardState();
}

class _RiverpodCardState extends ConsumerState<_RiverpodCard> {
  int _cardBuilds = 0;
  int _consumerBuilds = 0;

  @override
  Widget build(BuildContext context) {
    _cardBuilds++;
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('B) Riverpod StateProvider', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            // Only this Consumer rebuilds when the counter changes.
            Consumer(
              builder: (context, ref, _) {
                _consumerBuilds++;
                final count = ref.watch(counterProvider);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$count', style: theme.textTheme.displaySmall),
                    Text('Consumer built: $_consumerBuilds time(s)'),
                  ],
                );
              },
            ),
            Text('Outer card built: $_cardBuilds time(s) (stays at 1)'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                // ref.read: change the state from a callback, without listening.
                FilledButton(
                  onPressed: () => ref.read(counterProvider.notifier).state++,
                  child: const Text('+1'),
                ),
                OutlinedButton(
                  onPressed: () => ref.read(counterProvider.notifier).state = 0,
                  child: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'The state lives in a provider. Any widget can use it, and no BuildContext is needed to define it.',
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// C) The ways to use `ref`.
// ---------------------------------------------------------------------------
class _AccessStylesCard extends ConsumerWidget {
  const _AccessStylesCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // ref.listen: run a side effect (a SnackBar) when the value changes. It does not rebuild.
    ref.listen<int>(counterProvider, (previous, next) {
      if (next != 0 && next % 5 == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Counter reached $next (ref.listen)')),
        );
      }
    });

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('C) Ways to use ref', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Consumer(
              builder: (context, ref, _) =>
                  _StyleRow('Consumer + ref.watch', '${ref.watch(counterProvider)}'),
            ),
            const _WatchRow(),
            const _SelectRow(),
            const SizedBox(height: 8),
            const Text(
              'ref.read changes state from callbacks. ref.listen runs a side effect: '
              'press +1 until the counter reaches 5 and a SnackBar appears.',
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton(
                  onPressed: () => ref.read(counterProvider.notifier).state--,
                  child: const Text('-1 (ref.read)'),
                ),
                OutlinedButton(
                  onPressed: () => ref.read(counterProvider.notifier).state++,
                  child: const Text('+1 (ref.read)'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WatchRow extends ConsumerWidget {
  const _WatchRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return _StyleRow('ConsumerWidget + ref.watch', '$count');
  }
}

class _SelectRow extends ConsumerWidget {
  const _SelectRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // select: rebuild only when even/odd changes, not on every increment.
    final isEven = ref.watch(counterProvider.select((value) => value.isEven));
    return _StyleRow('ref.watch(...select)', isEven ? 'even' : 'odd');
  }
}

class _StyleRow extends StatelessWidget {
  final String label;
  final String value;

  const _StyleRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontFamily: 'monospace'))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _SummaryNote extends StatelessWidget {
  const _SummaryNote();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'The counter provider is autoDispose: leave this screen and come back, and it starts from 0. '
          'The other providers (todos, cart, auth, posts) keep their state while the app is open. '
          'See COMPARISON.md for setState vs Provider vs Riverpod.',
        ),
      ),
    );
  }
}
