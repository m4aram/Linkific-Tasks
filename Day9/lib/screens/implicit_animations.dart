import 'package:flutter/material.dart';

class ImplicitAnimationsScreen extends StatefulWidget {
  const ImplicitAnimationsScreen({super.key});

  @override
  State<ImplicitAnimationsScreen> createState() =>
      _ImplicitAnimationsScreenState();
}

class _ImplicitAnimationsScreenState extends State<ImplicitAnimationsScreen> {
  bool isExpanded = false;
  bool isVisible = true;
  bool showFirst = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Implicit Animations')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'AnimatedContainer',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              width: isExpanded ? 280 : 150,
              height: isExpanded ? 180 : 100,
              decoration: BoxDecoration(
                color: isExpanded ? Colors.deepPurple : Colors.blue,
                borderRadius: BorderRadius.circular(isExpanded ? 30 : 10),
              ),
              child: const Center(
                child: Text(
                  'AnimatedContainer',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            FilledButton(
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: const Text('Animate Container'),
            ),

            const Divider(height: 40),

            const Text(
              'AnimatedOpacity',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: isVisible ? 1 : 0,
              child: Container(
                width: 180,
                height: 80,
                color: Colors.orange,
                alignment: Alignment.center,
                child: const Text(
                  'Fade',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),

            FilledButton(
              onPressed: () {
                setState(() {
                  isVisible = !isVisible;
                });
              },
              child: const Text('Toggle Opacity'),
            ),

            const Divider(height: 40),

            const Text(
              'AnimatedPositioned',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 180,
              width: double.infinity,
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOut,
                    left: isExpanded ? 180 : 20,
                    top: 50,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 40),

            const Text(
              'AnimatedCrossFade',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            AnimatedCrossFade(
              duration: const Duration(milliseconds: 500),
              firstChild: Container(
                width: 200,
                height: 80,
                color: Colors.blue,
                alignment: Alignment.center,
                child: const Text(
                  'First Widget',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              secondChild: Container(
                width: 200,
                height: 80,
                color: Colors.pink,
                alignment: Alignment.center,
                child: const Text(
                  'Second Widget',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              crossFadeState: showFirst
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
            ),

            FilledButton(
              onPressed: () {
                setState(() {
                  showFirst = !showFirst;
                });
              },
              child: const Text('Cross Fade'),
            ),

            const Divider(height: 40),

            const Text(
              'TweenAnimationBuilder',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(seconds: 1),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.scale(scale: value, child: child),
                );
              },
              child: const Icon(Icons.star, size: 80, color: Colors.amber),
            ),

            const Divider(height: 40),

            const Text(
              'Curves.bounceIn',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(seconds: 1),
              curve: Curves.bounceIn,
              builder: (context, value, child) {
                return Transform.scale(scale: value, child: child);
              },
              child: const Icon(Icons.sports_soccer, size: 70),
            ),

            const Divider(height: 40),

            const Text(
              'Custom Curve',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(seconds: 1),
              curve: const CustomEaseCurve(),
              builder: (context, value, child) {
                return Transform.scale(scale: value, child: child);
              },
              child: const Icon(Icons.favorite, size: 70, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomEaseCurve extends Curve {
  const CustomEaseCurve();

  @override
  double transformInternal(double t) {
    return t * t * (3 - 2 * t);
  }
}
