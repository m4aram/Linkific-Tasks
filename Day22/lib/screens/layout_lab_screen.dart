import 'package:flutter/material.dart';

import '../widgets/lab_card.dart';

/// Three classic "RenderFlex overflowed" bugs. In debug mode an overflow paints yellow and black
/// stripes and prints "A RenderFlex overflowed by N pixels" in the console.
class LayoutLabScreen extends StatefulWidget {
  const LayoutLabScreen({super.key, this.initialFixed = false});

  final bool initialFixed;

  @override
  State<LayoutLabScreen> createState() => _LayoutLabScreenState();
}

class _LayoutLabScreenState extends State<LayoutLabScreen> {
  late bool _fixed = widget.initialFixed;

  static const String _title = 'Wireless noise cancelling headphones with a very long product name';

  @override
  Widget build(BuildContext context) {
    // ---- A) a Row with a long Text
    final Widget rowA = _fixed
        ? const Row(
            children: [
              Icon(Icons.headphones),
              SizedBox(width: 8),
              // FIX: Expanded gives the Text the remaining width, so it wraps instead of overflowing.
              Expanded(child: Text(_title, maxLines: 2, overflow: TextOverflow.ellipsis)),
              SizedBox(width: 8),
              Text(r'$129'),
            ],
          )
        : const Row(
            children: [
              Icon(Icons.headphones),
              SizedBox(width: 8),
              Text(_title), // BUG: a Row gives its children unlimited width
              SizedBox(width: 8),
              Text(r'$129'),
            ],
          );

    // ---- B) a Column taller than its parent
    final Widget column = Column(
      children: [
        for (var i = 1; i <= 4; i++)
          Container(
            height: 50,
            margin: const EdgeInsets.only(bottom: 4),
            color: Colors.orange.shade100,
            alignment: Alignment.center,
            child: Text('Box $i'),
          ),
      ],
    );
    final Widget columnB = SizedBox(
      height: 120,
      // FIX: SingleChildScrollView lets the Column scroll when it is taller than 120.
      child: _fixed ? SingleChildScrollView(child: column) : column,
    );

    // ---- C) a Row of chips
    final chips = [
      for (final name in ['Electronics', 'Headphones', 'Wireless', 'Black', 'Sale'])
        Chip(label: Text(name)),
    ];
    // FIX: Wrap moves the chips to the next line when there is no space.
    final Widget chipsC = _fixed ? Wrap(spacing: 8, runSpacing: 4, children: chips) : Row(children: chips);

    return Scaffold(
      appBar: AppBar(title: const Text('Layout overflow')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FixSwitch(fixed: _fixed, onChanged: (v) => setState(() => _fixed = v)),
          const LabCard(
            title: 'How to debug it',
            child: Text(
              '1. Read the console: the message says which Row or Column and by how many pixels.\n'
              '2. DevTools > Inspector: select the widget and open the Layout Explorer.\n'
              '3. Click "Debug paint" in the Inspector toolbar to see the box of every widget.\n'
              '4. Fix: Expanded or Flexible (Row/Column), Wrap (many items), SingleChildScrollView (too tall).',
            ),
          ),
          LabCard(title: 'A) Row with a long Text', child: rowA),
          LabCard(title: 'B) Column taller than its parent (120 px)', child: columnB),
          LabCard(title: 'C) Row of chips', child: chipsC),
        ],
      ),
    );
  }
}
