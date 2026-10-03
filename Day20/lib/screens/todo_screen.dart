import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/todo_providers.dart';

class TodoScreen extends ConsumerWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo (StateNotifier)'),
        actions: [
          IconButton(
            tooltip: 'Clear completed',
            icon: const Icon(Icons.cleaning_services_outlined),
            onPressed: () => ref.read(todosProvider.notifier).clearCompleted(),
          ),
        ],
      ),
      body: const Column(
        children: [
          AddTodoForm(),
          _FilterBar(),
          _Stats(),
          Divider(height: 1),
          Expanded(child: _TodoList()),
        ],
      ),
    );
  }
}

/// HookConsumerWidget = ConsumerWidget + hooks (from hooks_riverpod and flutter_hooks).
/// useTextEditingController creates the controller and disposes it automatically,
/// so we do not need a StatefulWidget with initState and dispose.
class AddTodoForm extends HookConsumerWidget {
  const AddTodoForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    // Rebuilds this widget when the text changes, to enable/disable the Add button.
    final value = useValueListenable(controller);
    final canAdd = value.text.trim().isNotEmpty;

    void submit() {
      if (!canAdd) return;
      ref.read(todosProvider.notifier).add(controller.text);
      controller.clear();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => submit(),
              decoration: const InputDecoration(
                hintText: 'New task...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(onPressed: canAdd ? submit : null, child: const Icon(Icons.add)),
        ],
      ),
    );
  }
}

class _FilterBar extends ConsumerWidget {
  const _FilterBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(todoFilterProvider);

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
            ref.read(todoFilterProvider.notifier).state = selection.first,
      ),
    );
  }
}

class _Stats extends ConsumerWidget {
  const _Stats();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(todoStatsProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${stats.active} remaining'),
          Text('${stats.done} completed'),
        ],
      ),
    );
  }
}

class _TodoList extends ConsumerWidget {
  const _TodoList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(filteredTodosProvider);

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
          onDismissed: (_) => ref.read(todosProvider.notifier).remove(todo.id),
          child: CheckboxListTile(
            value: todo.done,
            onChanged: (_) => ref.read(todosProvider.notifier).toggle(todo.id),
            title: Text(
              todo.title,
              style: todo.done ? const TextStyle(decoration: TextDecoration.lineThrough) : null,
            ),
          ),
        );
      },
    );
  }
}
