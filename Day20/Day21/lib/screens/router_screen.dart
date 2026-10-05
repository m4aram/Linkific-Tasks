import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app_router.dart';

class RouterScreen extends StatelessWidget {
  const RouterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GoRouter Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'GoRouter Typed Routes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: () {
                const ProductDetailsRoute(id: '42').go(context);
              },
              child: const Text('Open Product 42'),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: () {
                const ProductDetailsRoute(id: '99').go(context);
              },
              child: const Text('Open Product 99'),
            ),
          ],
        ),
      ),
    );
  }
}