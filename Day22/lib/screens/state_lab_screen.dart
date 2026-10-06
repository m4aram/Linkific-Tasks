import 'package:flutter/material.dart';

import '../widgets/lab_card.dart';

class StateLabScreen extends StatefulWidget {
  const StateLabScreen({super.key});

  @override
  State<StateLabScreen> createState() => _StateLabScreenState();
}

class _StateLabScreenState extends State<StateLabScreen> {
  bool _fixed = false;

  // ---- bug 1
  final List<String> _items = ['Milk', 'Eggs'];

  // ---- bug 2
  final ValueNotifier<List<int>> _numbers = ValueNotifier<List<int>>([1, 2]);

  // ---- bug 3
  final List<String> _people = ['Ann', 'Bob', 'Cid'];

  @override
  void dispose() {
    _numbers.dispose();
    super.dispose();
  }

  void _addItem() {
    final item = 'Item ${_items.length + 1}';
    if (_fixed) {
      setState(() => _items.add(item)); // FIX: setState tells Flutter to rebuild
    } else {
      _items.add(item); // BUG: the list changed, but nobody asked for a rebuild
    }
  }

  void _addNumber() {
    if (_fixed) {
      _numbers.value = [..._numbers.value, _numbers.value.length + 1]; // FIX: a NEW list
    } else {
      _numbers.value.add(_numbers.value.length + 1); // BUG: same list object, so no notification
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('State not updating')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FixSwitch(fixed: _fixed, onChanged: (v) => setState(() => _fixed = v)),
          LabCard(
            title: 'Bug 1: changing data without setState',
            subtitle: 'Press Add: in the buggy version nothing changes until something else rebuilds the screen.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Items (${_items.length}): ${_items.join(', ')}'),
                const SizedBox(height: 8),
                FilledButton.tonal(onPressed: _addItem, child: const Text('Add item')),
              ],
            ),
          ),
          LabCard(
            title: 'Bug 2: changing a ValueNotifier list in place',
            subtitle: 'A ValueNotifier notifies only when `value` is assigned a different object.',
            child: ValueListenableBuilder<List<int>>(
              valueListenable: _numbers,
              builder: (context, list, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Numbers (${list.length}): ${list.join(', ')}'),
                  const SizedBox(height: 8),
                  FilledButton.tonal(onPressed: _addNumber, child: const Text('Add number')),
                ],
              ),
            ),
          ),
          LabCard(
            title: 'Bug 3: missing Keys in a list of stateful widgets',
            subtitle: 'Tap + on Ann twice, then remove the first person. Whose counter does Bob now show?',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final name in _people)
                  // FIX: a Key ties each State to the person, not to the position in the list.
                  _CounterTile(key: _fixed ? ValueKey(name) : null, name: name),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: _people.isEmpty ? null : () => setState(() => _people.removeAt(0)),
                  child: const Text('Remove first'),
                ),
                TextButton(
                  onPressed: () => setState(() => _people
                    ..clear()
                    ..addAll(['Ann', 'Bob', 'Cid'])),
                  child: const Text('Reset people'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CounterTile extends StatefulWidget {
  const _CounterTile({super.key, required this.name});

  final String name;

  @override
  State<_CounterTile> createState() => _CounterTileState();
}

class _CounterTileState extends State<_CounterTile> {
  int _count = 0; // this value lives in the State object

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text('${widget.name}: $_count')),
        IconButton(onPressed: () => setState(() => _count++), icon: const Icon(Icons.add_circle_outline)),
      ],
    );
  }
}
