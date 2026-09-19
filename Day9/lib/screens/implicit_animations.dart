import 'package:flutter/material.dart';

class ImplicitAnimationsScreen extends StatefulWidget {
  const ImplicitAnimationsScreen({super.key});

  @override
  State<ImplicitAnimationsScreen> createState() =>
      _ImplicitAnimationsScreenState();
}

class _ImplicitAnimationsScreenState extends State<ImplicitAnimationsScreen> {
  // AnimatedContainer

  bool containerExpanded = false;

  // AnimatedOpacity

  bool visible = true;

  // AnimatedPositioned

  bool moved = false;

  // AnimatedCrossFade

  bool firstWidget = true;

  // TweenAnimationBuilder

  double tweenValue = 100;

  // Curves

  double easeInValue = 100;

  double easeOutValue = 100;

  double bounceValue = 100;

  // Custom Curve

  double customValue = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Implicit Animations')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            // ------------------------------------------------

            // AnimatedContainer

            // ------------------------------------------------
            const Text(
              'AnimatedContainer',

              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            AnimatedContainer(
              duration: const Duration(milliseconds: 700),

              curve: Curves.easeInOut,

              width: containerExpanded ? 220 : 120,

              height: containerExpanded ? 120 : 70,

              decoration: BoxDecoration(
                color: containerExpanded ? Colors.deepPurple : Colors.blue,

                borderRadius: BorderRadius.circular(
                  containerExpanded ? 30 : 12,
                ),
              ),

              child: const Center(
                child: Text('Container', style: TextStyle(color: Colors.white)),
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  containerExpanded = !containerExpanded;
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
              duration: const Duration(milliseconds: 700),

              opacity: visible ? 1.0 : 0.0,

              child: Container(
                width: 180,

                height: 80,

                color: Colors.green,

                child: const Center(
                  child: Text('Opacity', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  visible = !visible;
                });
              },

              child: const Text('Show / Hide'),
            ),

            const Divider(height: 40),

            // ------------------------------------------------

            // AnimatedPositioned

            // ------------------------------------------------
            const Text(
              'AnimatedPositioned',

              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 130,

              width: double.infinity,

              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 700),

                    curve: Curves.easeInOut,

                    left: moved ? 220 : 0,

                    top: moved ? 50 : 0,

                    child: Container(
                      width: 70,

                      height: 70,

                      decoration: const BoxDecoration(
                        color: Colors.orange,

                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  moved = !moved;
                });
              },

              child: const Text('Move'),
            ),

            const Divider(height: 40),

            // ------------------------------------------------

            // AnimatedCrossFade

            // ------------------------------------------------
            const Text(
              'AnimatedCrossFade',

              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            AnimatedCrossFade(
              duration: const Duration(milliseconds: 700),

              crossFadeState: firstWidget
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,

              firstChild: Container(
                width: 250,

                height: 100,

                color: Colors.blue,

                alignment: Alignment.center,

                child: const Text(
                  'First Widget',

                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),

              secondChild: Container(
                width: 250,

                height: 100,

                color: Colors.purple,

                alignment: Alignment.center,

                child: const Text(
                  'Second Widget',

                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  firstWidget = !firstWidget;
                });
              },

              child: const Text('Cross Fade'),
            ),

            const Divider(height: 40),
            const Text(
              'TweenAnimationBuilder',

              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 50, end: tweenValue),

              duration: const Duration(milliseconds: 800),

              curve: Curves.easeInOut,

              builder: (context, value, child) {
                return Container(
                  width: value,

                  height: value,

                  decoration: BoxDecoration(
                    color: Colors.amber,

                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: const Icon(Icons.star, color: Colors.white, size: 40),
                );
              },
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  tweenValue = tweenValue == 100 ? 180 : 100;
                });
              },

              child: const Text('Tween Animation'),
            ),

            const Divider(height: 40),

            // ------------------------------------------------

            // Curves.easeIn

            // ------------------------------------------------
            const Text(
              'Curves.easeIn',

              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 50, end: easeInValue),

              duration: const Duration(milliseconds: 800),

              curve: Curves.easeIn,

              builder: (context, value, child) {
                return Container(width: value, height: 50, color: Colors.red);
              },
            ),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  easeInValue = easeInValue == 100 ? 250 : 100;
                });
              },

              child: const Text('Ease In'),
            ),

            const SizedBox(height: 20),

            // ------------------------------------------------

            // Curves.easeOut

            // ------------------------------------------------
            const Text(
              'Curves.easeOut',

              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 50, end: easeOutValue),

              duration: const Duration(milliseconds: 800),

              curve: Curves.easeOut,

              builder: (context, value, child) {
                return Container(width: value, height: 50, color: Colors.green);
              },
            ),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  easeOutValue = easeOutValue == 100 ? 250 : 100;
                });
              },

              child: const Text('Ease Out'),
            ),

            const SizedBox(height: 20),

            // ------------------------------------------------

            // Curves.bounceIn

            // ------------------------------------------------
            const Text(
              'Curves.bounceIn',

              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 50, end: bounceValue),

              duration: const Duration(milliseconds: 1000),

              curve: Curves.bounceIn,

              builder: (context, value, child) {
                return Container(
                  width: value,

                  height: 50,

                  color: Colors.orange,
                );
              },
            ),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  bounceValue = bounceValue == 100 ? 250 : 100;
                });
              },

              child: const Text('Bounce In'),
            ),

            const SizedBox(height: 20),
            const Text(
              'Custom Curve',

              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 50, end: customValue),

              duration: const Duration(milliseconds: 900),

              curve: const Cubic(0.68, -0.55, 0.27, 1.55),

              builder: (context, value, child) {
                return Container(width: value, height: 50, color: Colors.pink);
              },
            ),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  customValue = customValue == 100 ? 250 : 100;
                });
              },

              child: const Text('Custom Curve'),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
