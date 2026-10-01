import 'package:flutter/foundation.dart';

import '../models/todo.dart';

enum TodoFilter { all, active, done }

class TodoProvider extends ChangeNotifier {
  TodoProvider() {
    _todos.addAll([
      Todo(id: _nextId++, title: 'Read the Provider docs'),
      Todo(id: _nextId++, title: 'Create a ChangeNotifier'),
      Todo(id: _nextId++, title: 'Use Consumer and context.select', done: true),
    ]);
  }

  final List<Todo> _todos = [];
  int _nextId = 1;
  TodoFilter _filter = TodoFilter.all;

  // ---- read-only state exposed to the UI ----
  TodoFilter get filter => _filter;
  int get total => _todos.length;
  int get activeCount => _todos.where((t) => !t.done).length;
  int get doneCount => _todos.where((t) => t.done).length;

  List<Todo> get visibleTodos {
    switch (_filter) {
      case TodoFilter.active:
        return _todos.where((t) => !t.done).toList();
      case TodoFilter.done:
        return _todos.where((t) => t.done).toList();
      case TodoFilter.all:
        return List.unmodifiable(_todos);
    }
  }

  // ---- actions: change state, then notify ----
  void add(String title) {
    final text = title.trim();
    if (text.isEmpty) return;
    _todos.insert(0, Todo(id: _nextId++, title: text));
    notifyListeners();
  }

  void toggle(int id) {
    final index = _todos.indexWhere((t) => t.id == id);
    if (index == -1) return;
    _todos[index] = _todos[index].copyWith(done: !_todos[index].done);
    notifyListeners();
  }

  void remove(int id) {
    _todos.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void clearCompleted() {
    _todos.removeWhere((t) => t.done);
    notifyListeners();
  }

  void setFilter(TodoFilter value) {
    if (_filter == value) return;
    _filter = value;
    notifyListeners();
  }
}
