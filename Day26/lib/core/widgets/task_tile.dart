import 'package:flutter/material.dart';

import '../../models/task.dart';
import '../utils/validators.dart';

/// A single task row, used on the home screen and in the task list.
class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task, required this.onToggle, this.onTap});

  final Task task;
  final ValueChanged<bool> onToggle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final overdue = !task.done &&
        task.dueDate != null &&
        task.dueDate!.isBefore(DateUtils.dateOnly(DateTime.now()));

    return Material(
      color: theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        leading: Checkbox(value: task.done, onChanged: (v) => onToggle(v ?? false)),
        title: Text(
          task.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            decoration: task.done ? TextDecoration.lineThrough : null,
            color: task.done ? theme.colorScheme.outline : null,
          ),
        ),
        subtitle: task.dueDate == null
            ? null
            : Text(
                'Due: ${formatDate(task.dueDate!)}',
                style: TextStyle(color: overdue ? theme.colorScheme.error : null),
              ),
        trailing: task.attachmentUrl == null ? null : const Icon(Icons.attach_file, size: 20),
      ),
    );
  }
}
