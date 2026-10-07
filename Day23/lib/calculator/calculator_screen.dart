import 'package:flutter/material.dart';

import 'calculator.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final Calculator _calculator = Calculator();
  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _secondController = TextEditingController();
  String _result = '';

  void _calculate(double Function(double, double) operation) {
    final double? a = double.tryParse(_firstController.text);
    final double? b = double.tryParse(_secondController.text);

    setState(() {
      if (a == null || b == null) {
        _result = 'Invalid input';
        return;
      }
      try {
        _result = 'Result: ${operation(a, b)}';
      } on ArgumentError catch (e) {
        _result = e.message.toString();
      }
    });
  }

  @override
  void dispose() {
    _firstController.dispose();
    _secondController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              key: const Key('firstNumberField'),
              controller: _firstController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'First number'),
            ),
            TextField(
              key: const Key('secondNumberField'),
              controller: _secondController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Second number'),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => _calculate(_calculator.add),
                  child: const Text('+'),
                ),
                ElevatedButton(
                  onPressed: () => _calculate(_calculator.subtract),
                  child: const Text('-'),
                ),
                ElevatedButton(
                  onPressed: () => _calculate(_calculator.multiply),
                  child: const Text('*'),
                ),
                ElevatedButton(
                  onPressed: () => _calculate(_calculator.divide),
                  child: const Text('/'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(_result, key: const Key('resultText')),
          ],
        ),
      ),
    );
  }
}
