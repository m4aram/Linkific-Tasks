import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_providers.dart';
import '../providers/cart_providers.dart';
import '../utils/format.dart';
import 'auth_screen.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lines = ref.watch(cartLinesProvider);
    final summary = ref.watch(cartSummaryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: lines.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: lines.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final line = lines[i];
                      return ListTile(
                        leading: Text(line.product.emoji, style: const TextStyle(fontSize: 30)),
                        title: Text(line.product.name),
                        subtitle: Text('${money(line.product.price)} each'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () => ref.read(cartProvider.notifier).decrease(line.product.id),
                            ),
                            Text('${line.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () => ref.read(cartProvider.notifier).add(line.product),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => ref.read(cartProvider.notifier).remove(line.product.id),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                _SummaryCard(summary: summary, onCheckout: () => _checkout(context, ref, summary)),
              ],
            ),
    );
  }

  void _checkout(BuildContext context, WidgetRef ref, CartSummary summary) {
    final messenger = ScaffoldMessenger.of(context);

    if (!ref.read(authProvider).isLoggedIn) {
      messenger.showSnackBar(
        SnackBar(
          content: const Text('Please log in to checkout'),
          action: SnackBarAction(
            label: 'LOG IN',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AuthScreen()),
            ),
          ),
        ),
      );
      return;
    }

    final total = summary.total;
    ref.read(cartProvider.notifier).clear();
    messenger.showSnackBar(SnackBar(content: Text('Order placed: ${money(total)}')));
  }
}

class _SummaryCard extends StatelessWidget {
  final CartSummary summary;
  final VoidCallback onCheckout;

  const _SummaryCard({required this.summary, required this.onCheckout});

  Widget _row(String label, String value, {bool bold = false}) {
    final style = bold ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 18) : null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: style), Text(value, style: style)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _row('Subtotal', money(summary.subtotal)),
            if (summary.isMember) _row('Member discount (10%)', '-${money(summary.discount)}'),
            _row('Shipping', summary.shipping == 0 ? 'Free' : money(summary.shipping)),
            const Divider(),
            _row('Total', money(summary.total), bold: true),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton(onPressed: onCheckout, child: const Text('Checkout')),
            ),
            const SizedBox(height: 4),
            const Text('Free shipping from \$100', style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
