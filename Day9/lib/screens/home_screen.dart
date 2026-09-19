import 'package:flutter/material.dart';

import 'explicit_animation.dart';
import 'hero_screen.dart';
import 'implicit_animations.dart';
import 'list_animation_screen.dart';
import 'loading_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Animations')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildButton(
            context,
            'Implicit Animations',
            const ImplicitAnimationsScreen(),
          ),
          _buildButton(
            context,
            'Explicit Animation',
            const ExplicitAnimationScreen(),
          ),

          _buildButton(context, 'Hero Animation', const HeroAnimationScreen()),

          _buildButton(context, 'Loading Animation', const LoadingAnimationScreen()),

          _buildButton(context, 'Animated List', const ListAnimationScreen()),

          _buildButton(context, 'Animated Login', const LoginAnimationScreen()),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String title, Widget screen) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => screen),
            );
          },
          child: Text(title),
        ),
      ),
    );
  }
}
