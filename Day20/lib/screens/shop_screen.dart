import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';
import '../providers/auth_providers.dart';
import '../providers/cart_providers.dart';
import '../utils/format.dart';
import '../widgets/cart_button.dart';
import 'auth_screen.dart';

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productCatalogProvider);

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

class _MemberBanner extends ConsumerWidget {
  const _MemberBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // isMemberProvider only changes between true and false.
    final isMember = ref.watch(isMemberProvider);

    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.primaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(isMember ? 'Member discount (10%) is active' : 'Log in to get 10% member discount'),
          ),
          if (!isMember)
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
  }
}

class _ProductTile extends ConsumerWidget {
  final Product product;

  const _ProductTile({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // select: rebuild only when THIS product's quantity changes.
    final qty = ref.watch(cartProvider.select((cart) => cart[product.id]?.quantity ?? 0));

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
            onPressed: () => ref.read(cartProvider.notifier).add(product),
            icon: const Icon(Icons.add_shopping_cart),
          ),
        ],
      ),
    );
  }
}
