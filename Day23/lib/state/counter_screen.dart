import 'package:flutter/material.dart';

import 'counter_notifier.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key, required this.notifier});

  final CounterNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListenableBuilder(
              listenable: notifier,
              builder: (BuildContext context, Widget? child) {
                return Text(
                  '${notifier.count}',
                  key: const Key('counterText'),
                );
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: notifier.decrement,
                  icon: const Icon(Icons.remove),
                ),
                IconButton(
                  onPressed: notifier.increment,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            TextButton(
              onPressed: notifier.reset,
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
