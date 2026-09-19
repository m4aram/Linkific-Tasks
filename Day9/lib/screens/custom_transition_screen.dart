import 'package:flutter/material.dart';

class CustomTransitionScreen extends StatelessWidget {
  const CustomTransitionScreen({super.key});

  void openNextPage(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) {
          return const TransitionDetailsScreen();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slideAnimation = Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
          return SlideTransition(position: slideAnimation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Transition')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => openNextPage(context),
          child: const Text('Open Custom Transition'),
        ),
      ),
    );
  }
}

class TransitionDetailsScreen extends StatelessWidget {
  const TransitionDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transition Details')),
      body: const Center(
        child: Text(
          'Custom Page Transition',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
