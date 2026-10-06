import 'package:flutter/material.dart';

/// Counts how many times its build() runs. Used to SEE unnecessary rebuilds.
/// A `const BuildCounter(...)` is not rebuilt when its parent rebuilds. A non-const one is.
class BuildCounter extends StatelessWidget {
  const BuildCounter(this.label, {super.key});

  final String label;

  static final Map<String, int> _counts = {};

  static int count(String label) => _counts[label] ?? 0;

  static void reset() => _counts.clear();

  @override
  Widget build(BuildContext context) {
    final next = count(label) + 1;
    _counts[label] = next;
    return Text('$label: built $next time(s)');
  }
}
