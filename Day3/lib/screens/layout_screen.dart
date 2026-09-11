import 'package:flutter/material.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Layout Widgets'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest,
                  ),
                ),
                const Icon(
                  Icons.widgets,
                  size: 70,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Flexible(
                  child: Text(
                    'Flutter UI uses widgets to build layouts and interfaces.',
                  ),
                ),
                const Spacer(),
                const Icon(Icons.widgets),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  children: [
                    TextSpan(text: 'Flutter '),
                    TextSpan(
                      text: 'Widgets',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}