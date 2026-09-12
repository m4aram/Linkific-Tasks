import 'package:flutter/material.dart';
class ProductsScreen extends StatelessWidget { const ProductsScreen({super.key});
@override Widget build(BuildContext context) { return Scaffold( appBar: AppBar( title: const Text('E-commerce Products'), centerTitle: true, ), body: LayoutBuilder( builder: (context, constraints) { final columns = constraints.maxWidth > 700 ? 4 : 2;
return GridView.builder(
  padding: const EdgeInsets.all(16),
  itemCount: 30,
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: columns,
    crossAxisSpacing: 12,
    mainAxisSpacing: 12,
    childAspectRatio: 0.75,
  ),
  itemBuilder: (context, index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest,
                ),
                child: const Icon(
                  Icons.shopping_bag,
                  size: 55,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Product ${index + 1}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text('\$${(index + 1) * 10}'),
          ],
        ),
      ),
    );
  },
);
},
),
);
} }