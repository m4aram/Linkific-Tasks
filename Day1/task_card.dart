import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final bool completed;
  final ValueChanged<bool?> onChanged;

  const TaskCard({
    super.key,
    required this.title,
    required this.completed,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: Row(
          children: [
            Checkbox(
              value: completed,
              onChanged: onChanged,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  decoration:
                  completed ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            Icon(
              completed ? Icons.check_circle : Icons.circle_outlined,
              color: completed
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}