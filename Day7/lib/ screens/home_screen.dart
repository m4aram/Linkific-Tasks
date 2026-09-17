import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('State Management'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Flutter State Management',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Interactive examples using StatefulWidget and setState.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          _AppCard(
            icon: Icons.exposure_plus_1,
            title: 'Counter App',
            description: 'Increment and decrement using setState.',
            onTap: () {
              Navigator.pushNamed(context, '/counter');
            },
          ),

          _AppCard(
            icon: Icons.check_circle_outline,
            title: 'Todo List',
            description:
                'Add, update, delete, toggle, search and filter tasks.',
            onTap: () {
              Navigator.pushNamed(context, '/todo');
            },
          ),

          _AppCard(
            icon: Icons.assignment_outlined,
            title: 'Interactive Form',
            description: 'Controllers, focus, validation and submit handling.',
            onTap: () {
              Navigator.pushNamed(context, '/form');
            },
          ),

          _AppCard(
            icon: Icons.quiz_outlined,
            title: 'Quiz App',
            description: 'Answer questions and track your score.',
            onTap: () {
              Navigator.pushNamed(context, '/quiz');
            },
          ),
          _AppCard(
            icon: Icons.calculate_outlined,
            title: 'Calculator',
            description: 'Interactive calculator using local state.',
            onTap: () {
              Navigator.pushNamed(context, '/calculator');
            },
          ),
        ],
      ),
    );
  }
}

class _AppCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _AppCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(description),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
