import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/post.dart';
import '../providers/cart_provider.dart';
import '../services/api_service.dart';
import '../utils/format.dart';

/// Wraps the result of a Future so FutureProvider can show loading / data / error.
class DailyPost {
  final Post? post;
  final String? error;
  final bool isLoading;

  const DailyPost.loading()
      : post = null,
        error = null,
        isLoading = true;

  const DailyPost.ready(Post value)
      : post = value,
        error = null,
        isLoading = false;

  const DailyPost.failed(String message)
      : post = null,
        error = message,
        isLoading = false;
}

/// Provider SCOPE + MultiProvider demo:
/// FutureProvider and StreamProvider are created here, so they exist only while this screen is open.
/// The stream is cancelled automatically when you leave.
class PatternsScreen extends StatelessWidget {
  const PatternsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // FutureProvider: runs a Future once and rebuilds the UI when it completes.
        FutureProvider<DailyPost>(
          create: (ctx) =>
              ctx.read<ApiService>().getPost(1).then((post) => DailyPost.ready(post)),
          initialData: const DailyPost.loading(),
          catchError: (_, error) => DailyPost.failed('$error'),
        ),
        // StreamProvider: listens to a Stream and rebuilds the UI on every new value.
        StreamProvider<DateTime>(
          create: (_) => Stream<DateTime>.periodic(
            const Duration(seconds: 1),
            (_) => DateTime.now(),
          ),
          initialData: DateTime.now(),
        ),
      ],
      child: const _PatternsView(),
    );
  }
}

class _PatternsView extends StatelessWidget {
  const _PatternsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Provider patterns')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _ClockCard(),
          SizedBox(height: 12),
          _DailyPostCard(),
          SizedBox(height: 12),
          _ProxyCard(),
          SizedBox(height: 12),
          _MultiProviderNote(),
        ],
      ),
    );
  }
}

class _PatternCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _PatternCard({required this.title, required this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
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

// ---- StreamProvider ----
class _ClockCard extends StatelessWidget {
  const _ClockCard();

  @override
  Widget build(BuildContext context) {
    final now = context.watch<DateTime>();
    return _PatternCard(
      title: 'StreamProvider<DateTime>',
      subtitle: 'A Stream emits a new time every second. No setState, no Timer in the widget.',
      child: Text(
        '${two(now.hour)}:${two(now.minute)}:${two(now.second)}',
        style: Theme.of(context).textTheme.displaySmall,
      ),
    );
  }
}

// ---- FutureProvider ----
class _DailyPostCard extends StatelessWidget {
  const _DailyPostCard();

  @override
  Widget build(BuildContext context) {
    final daily = context.watch<DailyPost>();

    Widget content;
    if (daily.isLoading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (daily.error != null) {
      content = Text('Could not load: ${daily.error}');
    } else {
      final post = daily.post!;
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(post.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(post.body),
        ],
      );
    }

    return _PatternCard(
      title: 'FutureProvider<DailyPost>',
      subtitle: 'Loads one post from the API when the screen opens (one-time Future).',
      child: content,
    );
  }
}

// ---- ProxyProvider + ChangeNotifierProxyProvider ----
class _ProxyCard extends StatelessWidget {
  const _ProxyCard();

  @override
  Widget build(BuildContext context) {
    // ProxyProvider<CartProvider, CartSummary> -> derived read-only value.
    final summary = context.watch<CartSummary>();
    // ChangeNotifierProxyProvider<AuthProvider, CartProvider> -> cart knows the auth state.
    final isMember = context.select<CartProvider, bool>((cart) => cart.isMember);

    return _PatternCard(
      title: 'ProxyProvider / ChangeNotifierProxyProvider',
      subtitle: 'Add items in the Shop, or log in, then come back to see these values change.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('CartSummary.itemCount: ${summary.itemCount}'),
          Text('CartSummary.total: ${money(summary.total)}'),
          Text('CartProvider.isMember (from AuthProvider): $isMember'),
        ],
      ),
    );
  }
}

class _MultiProviderNote extends StatelessWidget {
  const _MultiProviderNote();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'MultiProvider: main.dart registers 7 providers in one list (ApiService, ProductCatalog, '
          'AuthProvider, TodoProvider, PostsProvider, CartProvider, CartSummary). '
          'This screen adds 2 more (FutureProvider and StreamProvider) in its own MultiProvider. '
          'Those 2 are scoped: they are disposed when you leave the screen.',
        ),
      ),
    );
  }
}
