import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';
import 'details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _openDetails(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DetailsScreen(data: 'Data from Home'),
      ),
    );
    if (!context.mounted) return;

    if (result != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Returned: $result')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      // Navigation Drawer
      drawer: const AppDrawer(),

      body: Center(
        child: ElevatedButton(
          onPressed: () => _openDetails(context),
          child: const Text('Open Details with Data'),
        ),
      ),
    );
  }
}
