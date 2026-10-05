import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/product.dart';

class FreezedScreen extends StatelessWidget {
  const FreezedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const product = Product(
      id: 1,
      title: 'Demo Product',
      price: 19.99,
      description: 'Immutable model',
    );
    final copy = product.copyWith(price: 24.99);
    const result = ProductResult.loading();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Freezed Example'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Original: ${product.title} — ${product.price}'),
          Text('copyWith: ${copy.title} — ${copy.price}'),
          const SizedBox(height: 12),
          Text('JSON: ${product.toJson()}'),
          const SizedBox(height: 12),
          Text('Union type: ${result.runtimeType}'),
          const SizedBox(height: 20),
          const Text(
            'Freezed provides immutable models, value equality, copyWith, '
            'union/sealed states and JSON serialization.',
          ),
        ],
      ),
    );
  }
}
