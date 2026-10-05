import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const items = [
    ('GetX', '/getx', 'State management, navigation, dependency injection'),
    ('Freezed', '/freezed', 'Immutable data classes, unions, JSON'),
    ('GoRouter', '/router', 'Declarative routing and deep links'),
    ('Dio', '/dio', 'HTTP, interceptors, cancellation and download'),
    ('Hive', '/hive', 'Local NoSQL CRUD storage'),
    ('Utilities', '/utilities', 'intl, URL launcher, sharing, connectivity'),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Package Explorer')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Package Learning App',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Practical demonstrations of the required Flutter packages.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ...items.map(
            (item) => Card(
              child: ListTile(
                leading: const Icon(Icons.extension_outlined),
                title: Text(item.$1),
                subtitle: Text(item.$3),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.go(item.$2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
