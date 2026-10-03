import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_providers.dart';
import '../widgets/cart_button.dart';
import 'auth_screen.dart';
import 'compare_screen.dart';
import 'posts_screen.dart';
import 'provider_types_screen.dart';
import 'shop_screen.dart';
import 'todo_screen.dart';

/// ConsumerWidget = a StatelessWidget that receives `ref` in build().
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _open(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // select: rebuild only when the user's name changes.
    final userName = ref.watch(authProvider.select((auth) => auth.user?.name));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod Demo'),
        actions: const [CartButton()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.person_outline),
              title: Text(userName == null ? 'Not signed in' : 'Signed in as $userName'),
              subtitle: const Text('Shared auth state, visible on every screen'),
            ),
          ),
          const SizedBox(height: 8),
          _FeatureTile(
            icon: Icons.compare_arrows,
            title: '1. setState vs Riverpod',
            subtitle: 'StateProvider, Consumer, ref.watch / read / listen / select',
            onTap: () => _open(context, const CompareScreen()),
          ),
          _FeatureTile(
            icon: Icons.checklist,
            title: '2. Todo app',
            subtitle: 'StateNotifierProvider, hooks, computed providers',
            onTap: () => _open(context, const TodoScreen()),
          ),
          _FeatureTile(
            icon: Icons.storefront_outlined,
            title: '3. Shopping cart',
            subtitle: 'NotifierProvider + a provider that depends on two others',
            onTap: () => _open(context, const ShopScreen()),
          ),
          _FeatureTile(
            icon: Icons.lock_outline,
            title: '4. Authentication state',
            subtitle: 'Notifier with loading, error, logout, and ref.listen',
            onTap: () => _open(context, const AuthScreen()),
          ),
          _FeatureTile(
            icon: Icons.cloud_outlined,
            title: '5. REST API with FutureProvider',
            subtitle: 'AsyncValue.when, family, search, refresh, retry',
            onTap: () => _open(context, const PostsScreen()),
          ),
          _FeatureTile(
            icon: Icons.hub_outlined,
            title: '6. All provider types',
            subtitle: 'Provider, StateProvider, StateNotifier, Future, Stream',
            onTap: () => _open(context, const ProviderTypesScreen()),
          ),
        ],
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

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
