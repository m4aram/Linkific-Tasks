import 'package:flutter/material.dart';

class TodoItem extends StatefulWidget {
  final String title;
  final bool completed;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TodoItem({
    super.key,
    required this.title,
    required this.completed,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  bool _showHighlight = false;

  @override
  void initState() {
    super.initState();
    _showHighlight = widget.completed;
  }

  @override
  void didUpdateWidget(covariant TodoItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.completed != widget.completed) {
      setState(() {
        _showHighlight = widget.completed;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Checkbox(
          value: widget.completed,
          onChanged: (_) {
            widget.onToggle();
          },
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            decoration: widget.completed ? TextDecoration.lineThrough : null,
            fontWeight: _showHighlight ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              widget.onEdit();
            } else if (value == 'delete') {
              widget.onDelete();
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ),
    );
  }
}
