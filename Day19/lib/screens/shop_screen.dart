import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../utils/format.dart';
import '../widgets/cart_button.dart';
import 'auth_screen.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Plain Provider value: read once, it never changes.
    final products = context.read<ProductCatalog>().products;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        actions: const [CartButton()],
      ),
      body: Column(
        children: [
          const _MemberBanner(),
          Expanded(
            child: ListView.separated(
              itemCount: products.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) => _ProductTile(product: products[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _MemberBanner extends StatelessWidget {
  const _MemberBanner();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return Container(
          width: double.infinity,
          color: Theme.of(context).colorScheme.primaryContainer,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  auth.isLoggedIn
                      ? 'Member discount (10%) is active'
                      : 'Log in to get 10% member discount',
                ),
              ),
              if (!auth.isLoggedIn)
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AuthScreen()),
                  ),
                  child: const Text('Log in'),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ProductTile extends StatelessWidget {
  final Product product;

  const _ProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    // Rebuilds only when THIS product's quantity changes.
    final qty = context.select<CartProvider, int>((cart) => cart.quantityOf(product.id));

    return ListTile(
      leading: Text(product.emoji, style: const TextStyle(fontSize: 32)),
      title: Text(product.name),
      subtitle: Text(money(product.price)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (qty > 0)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text('x$qty', style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          IconButton.filled(
            tooltip: 'Add to cart',
            onPressed: () => context.read<CartProvider>().add(product),
            icon: const Icon(Icons.add_shopping_cart),
          ),
        ],
      ),
    );
  }
}
