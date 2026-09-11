import 'package:flutter/material.dart';
class ItemsScreen extends StatelessWidget
{ const ItemsScreen({super.key});

@override Widget build(BuildContext context)
{ final items = [ 'Flutter', 'Dart', 'Firebase', 'REST APIs', 'Git', ];
return Scaffold(
  appBar: AppBar(
    title: const Text('List of Items'),
    centerTitle: true,
  ),
  body: Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Items',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.check_circle_outline),
                  title: Text(items[index]),
                ),
              );
            },
          ),
        ),
      ],
    ),
  ),
);
} }