import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../widgets/cart_button.dart';
import 'auth_screen.dart';
import 'counter_screen.dart';
import 'patterns_screen.dart';
import 'posts_screen.dart';
import 'shop_screen.dart';
import 'todo_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _open(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    // context.select: rebuild only when the user's name changes.
    final userName = context.select<AuthProvider, String?>((auth) => auth.user?.name);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Demo'),
        actions: const [CartButton()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.person_outline),
              title: Text(userName == null ? 'Not signed in' : 'Signed in as $userName'),
              subtitle: const Text('Shared AuthProvider state, visible on every screen'),
            ),
          ),
          const SizedBox(height: 8),
          _FeatureTile(
            icon: Icons.compare_arrows,
            title: '1. Provider vs setState',
            subtitle: 'ChangeNotifier, Consumer, watch / read / select, scope',
            onTap: () => _open(context, const CounterScreen()),
          ),
          _FeatureTile(
            icon: Icons.checklist,
            title: '2. Todo app',
            subtitle: 'TodoProvider: add, toggle, delete, filter',
            onTap: () => _open(context, const TodoScreen()),
          ),
          _FeatureTile(
            icon: Icons.storefront_outlined,
            title: '3. Shopping cart',
            subtitle: 'CartProvider + ProxyProvider (summary and member discount)',
            onTap: () => _open(context, const ShopScreen()),
          ),
          _FeatureTile(
            icon: Icons.lock_outline,
            title: '4. Authentication state',
            subtitle: 'AuthProvider: login, loading, error, logout',
            onTap: () => _open(context, const AuthScreen()),
          ),
          _FeatureTile(
            icon: Icons.cloud_outlined,
            title: '5. REST API with Provider',
            subtitle: 'The previous API app converted: loading, error, retry, search',
            onTap: () => _open(context, const PostsScreen()),
          ),
          _FeatureTile(
            icon: Icons.hub_outlined,
            title: '6. Provider patterns',
            subtitle: 'FutureProvider, StreamProvider, ProxyProvider, MultiProvider',
            onTap: () => _open(context, const PatternsScreen()),
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
