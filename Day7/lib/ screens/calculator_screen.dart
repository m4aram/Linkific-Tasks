import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  double? _firstNumber;
  String? _operator;
  bool _waitingForNumber = false;

  void _inputNumber(String number) {
    setState(() {
      if (_display == 'Error' ||
          _waitingForNumber ||
          _display == '0') {
        _display = number;
        _waitingForNumber = false;
      } else {
        _display += number;
      }
    });
  }

  void _inputDecimal() {
    setState(() {
      if (_display == 'Error' || _waitingForNumber) {
        _display = '0.';
        _waitingForNumber = false;
      } else if (!_display.contains('.')) {
        _display += '.';
      }
    });
  }

  void _selectOperator(String operator) {
    final number = double.tryParse(_display);
    if (number == null) return;

    setState(() {
      _firstNumber = number;
      _operator = operator;
      _waitingForNumber = true;
    });
  }

  void _calculate() {
    if (_firstNumber == null || _operator == null) return;
    final secondNumber = double.tryParse(_display);

    if (secondNumber == null) return;

    double result;

    switch (_operator) {
      case '+':
        result = _firstNumber! + secondNumber;
        break;

      case '-':
        result = _firstNumber! - secondNumber;
        break;

      case '×':
        result = _firstNumber! * secondNumber;
        break;

      case '÷':
        if (secondNumber == 0) {
          setState(() {
            _display = 'Error';
            _firstNumber = null;
            _operator = null;
            _waitingForNumber = true;
          });
          return;
        }

        result = _firstNumber! / secondNumber;
        break;

      default:
        return;
    }

    setState(() {
      _display = _formatResult(result);
      _firstNumber = null;
      _operator = null;
      _waitingForNumber = true;
    });
  }

  String _formatResult(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toString();
  }

  void _clear() {
    setState(() {
      _display = '0';
      _firstNumber = null;
      _operator = null;
      _waitingForNumber = false;
    });
  }

  @override Widget build(BuildContext context) {
    final buttons = [
      '7',
      '8',
      '9',
      '÷',
      '4',
      '5',
      '6',
      '×',
      '1',
      '2',
      '3',
      '-',
      '0',
      '.',
      '=',
      '+',
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              child: Text(
                _display,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _clear,
                child: const Text('CLEAR'),
              ),
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            flex: 2,
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: buttons.length,
              itemBuilder: (context, index) {
                final value = buttons[index];

                return FilledButton(
                  onPressed: () {
                    if ('0123456789'.contains(value)) {
                      _inputNumber(value);
                    } else if (value == '.') {
                      _inputDecimal();
                    } else if (value == '=') {
                      _calculate();
                    } else {
                      _selectOperator(value);
                    }
                  },
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 22),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}