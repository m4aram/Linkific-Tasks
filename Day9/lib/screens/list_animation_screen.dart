import 'package:flutter/material.dart';

import '../widgets/animated_list_item.dart';

class ListAnimationScreen extends StatelessWidget {
  const ListAnimationScreen({super.key});

  final List<String> items = const [
    'Flutter',
    'Dart',
    'Animations',
    'Widgets',
    'Navigation',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animated List Items')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return AnimatedListItem(index: index, title: items[index]);
        },
      ),
    );
  }
}
