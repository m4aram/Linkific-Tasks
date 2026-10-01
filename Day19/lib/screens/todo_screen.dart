import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/todo_provider.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add() {
    context.read<TodoProvider>().add(_controller.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo (Provider)'),
        actions: [
          IconButton(
            tooltip: 'Clear completed',
            icon: const Icon(Icons.cleaning_services_outlined),
            onPressed: () => context.read<TodoProvider>().clearCompleted(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _add(),
                    decoration: const InputDecoration(
                      hintText: 'New task...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(onPressed: _add, child: const Icon(Icons.add)),
              ],
            ),
          ),
          const _FilterBar(),
          const _Stats(),
          const Divider(height: 1),
          const Expanded(child: _TodoList()),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar();

  @override
  Widget build(BuildContext context) {
    // Rebuilds only when the filter changes.
    final filter = context.select<TodoProvider, TodoFilter>((t) => t.filter);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SegmentedButton<TodoFilter>(
        segments: const [
          ButtonSegment(value: TodoFilter.all, label: Text('All')),
          ButtonSegment(value: TodoFilter.active, label: Text('Active')),
          ButtonSegment(value: TodoFilter.done, label: Text('Done')),
        ],
        selected: {filter},
        onSelectionChanged: (selection) =>
            context.read<TodoProvider>().setFilter(selection.first),
      ),
    );
  }
}

class _Stats extends StatelessWidget {
  const _Stats();

  @override
  Widget build(BuildContext context) {
    // Two separate selects: each one only listens to the value it needs.
    final active = context.select<TodoProvider, int>((t) => t.activeCount);
    final done = context.select<TodoProvider, int>((t) => t.doneCount);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$active remaining'),
          Text('$done completed'),
        ],
      ),
    );
  }
}

class _TodoList extends StatelessWidget {
  const _TodoList();

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, provider, _) {
        final todos = provider.visibleTodos;
        if (todos.isEmpty) {
          return const Center(child: Text('Nothing here'));
        }
        return ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, i) {
            final todo = todos[i];
            return Dismissible(
              key: ValueKey(todo.id),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Theme.of(context).colorScheme.errorContainer,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(Icons.delete_outline),
              ),
              onDismissed: (_) => provider.remove(todo.id),
              child: CheckboxListTile(
                value: todo.done,
                onChanged: (_) => provider.toggle(todo.id),
                title: Text(
                  todo.title,
                  style: todo.done
                      ? const TextStyle(decoration: TextDecoration.lineThrough)
                      : null,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
