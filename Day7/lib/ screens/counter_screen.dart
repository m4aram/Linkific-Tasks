import 'package:flutter/material.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _counter = 0;
  }

  void _increment() {
    setState(() {
      _counter++;
    });
  }

  void _decrement() {
    setState(() {
      if (_counter > 0) {
        _counter--;
      }
    });
  }

  void _reset() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Current Count', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 12),
            Text(
              '$_counter',
              style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filled(
                  onPressed: _decrement,
                  icon: const Icon(Icons.remove),
                  tooltip: 'Decrement',
                ),
                const SizedBox(width: 16),
                FilledButton(onPressed: _reset, child: const Text('Reset')),
                const SizedBox(width: 16),
                IconButton.filled(
                  onPressed: _increment,
                  icon: const Icon(Icons.add),
                  tooltip: 'Increment',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
