import 'package:flutter/material.dart';

class LoadingAnimationScreen extends StatefulWidget {
  const LoadingAnimationScreen({super.key});

  @override
  State<LoadingAnimationScreen> createState() => _LoadingAnimationScreenState();
}

class _LoadingAnimationScreenState extends State<LoadingAnimationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loading Animation')),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: _controller.value * 6.28,
              child: child,
            );
          },
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
