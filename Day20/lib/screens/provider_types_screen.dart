import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/api_providers.dart';
import '../providers/auth_providers.dart';
import '../providers/cart_providers.dart';
import '../providers/clock_provider.dart';
import '../providers/todo_providers.dart';
import '../utils/format.dart';

/// One screen that shows every provider type used in the app, with live values.
class ProviderTypesScreen extends ConsumerWidget {
  const ProviderTypesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(cartSummaryProvider);
    final filter = ref.watch(todoFilterProvider);
    final stats = ref.watch(todoStatsProvider);
    final cartCount = ref.watch(cartCountProvider);
    final auth = ref.watch(authProvider);
    final clock = ref.watch(clockProvider);
    final daily = ref.watch(postByIdProvider(1));

    return Scaffold(
      appBar: AppBar(title: const Text('All provider types')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _TypeCard(
            title: 'Provider<T>',
            subtitle: 'Read-only value. Here: cartSummaryProvider, computed from the cart and the login state.',
            child: Text(
              'items: ${summary.itemCount}   total: ${money(summary.total)}   member: ${summary.isMember}',
            ),
          ),
          _TypeCard(
            title: 'StateProvider<T>',
            subtitle: 'Simple state. Here: todoFilterProvider.',
            child: Row(
              children: [
                Expanded(child: Text('Current filter: ${filter.name}')),
                FilledButton.tonal(
                  onPressed: () => ref.read(todoFilterProvider.notifier).state =
                      TodoFilter.values[(filter.index + 1) % TodoFilter.values.length],
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
          _TypeCard(
            title: 'StateNotifierProvider<N, S>',
            subtitle: 'Complex state with methods. Here: todosProvider (TodoNotifier).',
            child: Text('${stats.active} remaining, ${stats.done} completed'),
          ),
          _TypeCard(
            title: 'NotifierProvider<N, S>',
            subtitle: 'The modern replacement of StateNotifier. Here: cartProvider and authProvider.',
            child: Text('cart items: $cartCount   auth: ${auth.status.name}'),
          ),
          _TypeCard(
            title: 'FutureProvider.family<T, Arg>',
            subtitle: 'Async data with a parameter. Here: postByIdProvider(1) loads one post from the API.',
            child: daily.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Text('Could not load: $error'),
              data: (post) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(post.body),
                ],
              ),
            ),
          ),
          _TypeCard(
            title: 'StreamProvider<T>',
            subtitle: 'Values that keep coming. Here: a clock that ticks every second.',
            child: clock.when(
              loading: () => const Text('...'),
              error: (error, stackTrace) => Text('$error'),
              data: (now) => Text(
                '${two(now.hour)}:${two(now.minute)}:${two(now.second)}',
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _TypeCard({required this.title, required this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium?.copyWith(fontFamily: 'monospace')),
            const SizedBox(height: 4),
            Text(subtitle, style: theme.textTheme.bodySmall),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
