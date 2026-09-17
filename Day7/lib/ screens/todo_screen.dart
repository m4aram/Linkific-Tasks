import 'package:flutter/material.dart';

import '../widgets/todo_item.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _Todo {
  String title;
  bool completed;

  _Todo({required this.title, this.completed = false});
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _todoController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final List<_Todo> _todos = [
    _Todo(title: 'Learn StatefulWidget'),
    _Todo(title: 'Practice setState'),
    _Todo(title: 'Build interactive UI'),
  ];
  String _filter = 'All';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _todoController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _addTodo() {
    final title = _todoController.text.trim();
    if (title.isEmpty) {
      return;
    }

    setState(() {
      _todos.add(_Todo(title: title));
      _todoController.clear();
    });
  }

  void _editTodo(int index) {
    final controller = TextEditingController(text: _todos[index].title);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Task title'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final newTitle = controller.text.trim();

                if (newTitle.isNotEmpty) {
                  setState(() {
                    _todos[index].title = newTitle;
                  });
                }

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  void _toggleTodo(int index) {
    setState(() {
      _todos[index].completed = !_todos[index].completed;
    });
  }

  List<MapEntry<int, _Todo>> get _filteredTodos {
    final query = _searchController.text.toLowerCase().trim();
    final entries = _todos.asMap().entries.where((entry) {
      final todo = entry.value;

      final matchesSearch = todo.title.toLowerCase().contains(query);

      final matchesFilter = switch (_filter) {
        'Completed' => todo.completed,
        'Pending' => !todo.completed,
        _ => true,
      };

      return matchesSearch && matchesFilter;
    }).toList();

    return entries;
  }

  @override
  Widget build(BuildContext context) {
    final visibleTodos = _filteredTodos;
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _todoController,
                    onSubmitted: (_) => _addTodo(),
                    decoration: const InputDecoration(
                      labelText: 'New task',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _addTodo,
                  icon: const Icon(Icons.add),
                  tooltip: 'Add task',
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search tasks',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text('Filter:'),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _filter,
                  items: const [
                    DropdownMenuItem(value: 'All', child: Text('All')),
                    DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                    DropdownMenuItem(
                      value: 'Completed',
                      child: Text('Completed'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == null) return;

                    setState(() {
                      _filter = value;
                    });
                  },
                ),
              ],
            ),
          ),

          const Divider(),

          Expanded(
            child: visibleTodos.isEmpty
                ? const Center(child: Text('No tasks found.'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: visibleTodos.length,
                    itemBuilder: (context, index) {
                      final entry = visibleTodos[index];
                      final originalIndex = entry.key;
                      final todo = entry.value;

                      return TodoItem(
                        key: ValueKey(originalIndex),
                        title: todo.title,
                        completed: todo.completed,
                        onToggle: () {
                          _toggleTodo(originalIndex);
                        },
                        onEdit: () {
                          _editTodo(originalIndex);
                        },
                        onDelete: () {
                          _deleteTodo(originalIndex);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
