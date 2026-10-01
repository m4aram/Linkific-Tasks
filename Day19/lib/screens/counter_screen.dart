import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/counter_provider.dart';

/// Provider SCOPE demo:
/// this ChangeNotifierProvider is created here, so it only exists while this screen is open.
/// Leave the screen and come back: the counter starts from 0 again.
class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CounterProvider>(
      create: (_) => CounterProvider(),
      child: const _CounterView(),
    );
  }
}

class _CounterView extends StatelessWidget {
  const _CounterView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Provider vs setState')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _SetStateCard(),
          SizedBox(height: 12),
          _ProviderCard(),
          SizedBox(height: 12),
          _AccessStylesCard(),
          SizedBox(height: 12),
          _ScopeNote(),
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
            const Text('State lives inside this widget only. Other screens cannot use it.'),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// B) Provider + Consumer: only the Consumer part rebuilds.
// ---------------------------------------------------------------------------
class _ProviderCard extends StatefulWidget {
  const _ProviderCard();

  @override
  State<_ProviderCard> createState() => _ProviderCardState();
}

class _ProviderCardState extends State<_ProviderCard> {
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
            Text('B) Provider + Consumer', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            // Only this Consumer rebuilds when the counter changes.
            Consumer<CounterProvider>(
              builder: (context, counter, _) {
                _consumerBuilds++;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${counter.value}', style: theme.textTheme.displaySmall),
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
                // context.read: call a method, do not listen.
                FilledButton(
                  onPressed: () => context.read<CounterProvider>().increment(),
                  child: const Text('+1'),
                ),
                OutlinedButton(
                  onPressed: () => context.read<CounterProvider>().reset(),
                  child: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text('State lives in CounterProvider. Any widget below the provider can use it.'),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// C) The four ways to access a provider.
// ---------------------------------------------------------------------------
class _AccessStylesCard extends StatelessWidget {
  const _AccessStylesCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('C) Four ways to read the same state', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),

            // 1) Consumer widget
            Consumer<CounterProvider>(
              builder: (_, counter, __) => _StyleRow('Consumer<T>', '${counter.value}'),
            ),

            // 2) Provider.of<T>(context) - listens by default
            Builder(
              builder: (ctx) {
                final counter = Provider.of<CounterProvider>(ctx);
                return _StyleRow('Provider.of<T>(context)', '${counter.value}');
              },
            ),

            // 3) context.watch<T>() - same as Provider.of with listen: true
            Builder(
              builder: (ctx) => _StyleRow(
                'context.watch<T>()',
                '${ctx.watch<CounterProvider>().value}',
              ),
            ),

            // 4) context.select<T, R>() - rebuild only when the selected value changes
            Builder(
              builder: (ctx) {
                final isEven = ctx.select<CounterProvider, bool>((c) => c.value.isEven);
                return _StyleRow('context.select<T, R>()', isEven ? 'even' : 'odd');
              },
            ),

            const SizedBox(height: 8),
            const Text(
              'context.read<T>() and Provider.of<T>(context, listen: false) do not listen. '
              'Use them inside callbacks such as onPressed.',
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton(
                  onPressed: () => context.read<CounterProvider>().decrement(),
                  child: const Text('-1 (context.read)'),
                ),
                OutlinedButton(
                  onPressed: () => Provider.of<CounterProvider>(context, listen: false).increment(),
                  child: const Text('+1 (listen: false)'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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

class _ScopeNote extends StatelessWidget {
  const _ScopeNote();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Scope: CounterProvider is created by this screen, so it is disposed when you leave. '
          'The other providers (auth, cart, todos, posts) are created in main.dart, '
          'so their state survives navigation.',
        ),
      ),
    );
  }
}
