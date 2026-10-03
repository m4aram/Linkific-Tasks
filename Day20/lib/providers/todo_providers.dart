import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/todo.dart';

enum TodoFilter { all, active, done }

/// StateNotifier = a class that holds COMPLEX state (a list) and the methods that change it.
/// The state is immutable: every change creates a NEW list and assigns it to `state`.
/// (Assigning to `state` is what notifies the widgets, so there is no notifyListeners().)
class TodoNotifier extends StateNotifier<List<Todo>> {
  TodoNotifier()
      : super(const [
          Todo(id: 1, title: 'Read the Riverpod docs'),
          Todo(id: 2, title: 'Create a StateNotifier'),
          Todo(id: 3, title: 'Use ref.watch and ref.read', done: true),
        ]);

  int _nextId = 4;

  void add(String title) {
    final text = title.trim();
    if (text.isEmpty) return;
    state = [Todo(id: _nextId++, title: text), ...state];
  }

  void toggle(int id) {
    state = [
      for (final todo in state)
        if (todo.id == id) todo.copyWith(done: !todo.done) else todo,
    ];
  }

  void remove(int id) {
    state = state.where((todo) => todo.id != id).toList();
  }

  void clearCompleted() {
    state = state.where((todo) => !todo.done).toList();
  }
}

/// StateNotifierProvider = creates the notifier and exposes its state.
final todosProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) => TodoNotifier());

/// StateProvider = simple state (the selected filter).
final todoFilterProvider = StateProvider<TodoFilter>((ref) => TodoFilter.all);

/// Provider = read-only value COMPUTED from other providers.
/// It recalculates only when todosProvider or todoFilterProvider change.
final filteredTodosProvider = Provider<List<Todo>>((ref) {
  final todos = ref.watch(todosProvider);
  final filter = ref.watch(todoFilterProvider);
  switch (filter) {
    case TodoFilter.active:
      return todos.where((t) => !t.done).toList();
    case TodoFilter.done:
      return todos.where((t) => t.done).toList();
    case TodoFilter.all:
      return todos;
  }
});

class TodoStats {
  final int active;
  final int done;
  const TodoStats({required this.active, required this.done});

  // Riverpod 3 filters updates with ==, so widgets that watch the stats
  // rebuild only when the numbers really change.
  @override
  bool operator ==(Object other) =>
      other is TodoStats && other.active == active && other.done == done;

  @override
  int get hashCode => Object.hash(active, done);
}

final todoStatsProvider = Provider<TodoStats>((ref) {
  final todos = ref.watch(todosProvider);
  return TodoStats(
    active: todos.where((t) => !t.done).length,
    done: todos.where((t) => t.done).length,
  );
});
