import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/state_views.dart';
import '../../core/widgets/task_tile.dart';
import '../../models/task.dart';
import '../../services/auth_service.dart';
import '../../services/task_repository.dart';
import 'task_form_sheet.dart';

enum _Filter { all, pending, done }

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  _Filter _filter = _Filter.all;

  Future<bool> _confirmAndDelete(String uid, Task task) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete task'),
        content: Text('Delete "${task.title}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true) return false;
    try {
      await taskRepository.deleteTask(uid, task);
    } catch (_) {
      if (mounted) showMessage(context, 'Could not delete the task');
    }
    // Always return false: the row disappears when the Firestore listener fires
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final uid = authService.uid;
    if (uid == null) return const SizedBox.shrink();

    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showTaskForm(context),
        icon: const Icon(Icons.add),
        label: const Text('New task'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            child: SegmentedButton<_Filter>(
              segments: const [
                ButtonSegment(value: _Filter.all, label: Text('All')),
                ButtonSegment(value: _Filter.pending, label: Text('Pending')),
                ButtonSegment(value: _Filter.done, label: Text('Done')),
              ],
              selected: {_filter},
              onSelectionChanged: (s) => setState(() => _filter = s.first),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Task>>(
              stream: taskRepository.watchTasks(uid),
              builder: (context, snap) {
                if (snap.hasError) {
                  return const EmptyState(
                    icon: Icons.error_outline,
                    title: 'Could not load tasks',
                  );
                }
                if (!snap.hasData) return const LoadingView();

                final tasks = snap.data!.where((t) {
                  switch (_filter) {
                    case _Filter.all:
                      return true;
                    case _Filter.pending:
                      return !t.done;
                    case _Filter.done:
                      return t.done;
                  }
                }).toList();

                if (tasks.isEmpty) {
                  return const EmptyState(
                    icon: Icons.inbox_outlined,
                    title: 'No tasks here',
                    subtitle: 'Tap "New task" to get started',
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md, AppSpacing.sm, AppSpacing.md, 96),
                  itemCount: tasks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, i) {
                    final task = tasks[i];
                    return Dismissible(
                      key: ValueKey(task.id),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (_) => _confirmAndDelete(uid, task),
                      background: Container(
                        alignment: AlignmentDirectional.centerEnd,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.delete_outline,
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                      child: TaskTile(
                        task: task,
                        onToggle: (v) => taskRepository.setDone(uid, task.id, v),
                        onTap: () => showTaskForm(context, task: task),
                      ),
                    );
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
