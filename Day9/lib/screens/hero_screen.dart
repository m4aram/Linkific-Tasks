import 'package:flutter/material.dart';

class HeroAnimationScreen extends StatelessWidget {
  const HeroAnimationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hero Animation')),
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HeroDetailsScreen()),
            );
          },
          child: Hero(
            tag: 'animationHero',
            createRectTween: (begin, end) {
              return MaterialRectCenterArcTween(begin: begin, end: end);
            },
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.animation, size: 60, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class HeroDetailsScreen extends StatelessWidget {
  const HeroDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hero Details')),
      body: Center(
        child: Hero(
          tag: 'animationHero',
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(Icons.animation, size: 120, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
