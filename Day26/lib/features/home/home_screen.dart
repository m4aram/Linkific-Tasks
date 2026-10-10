import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/stat_card.dart';
import '../../core/widgets/state_views.dart';
import '../../core/widgets/task_tile.dart';
import '../../models/app_user.dart';
import '../../models/task.dart';
import '../../services/auth_service.dart';
import '../../services/task_repository.dart';
import '../../services/user_repository.dart';
import '../tasks/task_form_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = authService.uid;
    if (uid == null) return const SizedBox.shrink(); // brief moment during sign-out
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: StreamBuilder<List<Task>>(
        stream: taskRepository.watchTasks(uid),
        builder: (context, snap) {
          if (snap.hasError) {
            return const EmptyState(
              icon: Icons.error_outline,
              title: 'Could not load data',
              subtitle: 'Check your connection and the Firestore rules',
            );
          }
          if (!snap.hasData) return const LoadingView();

          final tasks = snap.data!;
          final done = tasks.where((t) => t.done).length;
          final pending = tasks.where((t) => !t.done).toList();
          final progress = tasks.isEmpty ? 0.0 : done / tasks.length;

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              // Greeting: the name comes live from the user document
              StreamBuilder<AppUser?>(
                stream: userRepository.watchUser(uid),
                builder: (context, userSnap) {
                  final name = userSnap.data?.name ?? '';
                  return Text(
                    name.isEmpty ? 'Hello 👋' : 'Hello, $name 👋',
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: StatCard(label: 'All', value: '${tasks.length}', icon: Icons.list_alt),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: StatCard(
                      label: 'Pending',
                      value: '${pending.length}',
                      icon: Icons.pending_actions,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: StatCard(label: 'Done', value: '$done', icon: Icons.task_alt),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text('Progress ${(progress * 100).round()}%', style: theme.textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.sm),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(value: progress, minHeight: 10),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(child: Text('Upcoming tasks', style: theme.textTheme.titleMedium)),
                  TextButton(onPressed: () => context.go('/tasks'), child: const Text('View all')),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              if (pending.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: AppSpacing.lg),
                  child: EmptyState(
                    icon: Icons.celebration_outlined,
                    title: 'No pending tasks',
                    subtitle: 'Add a new task from the Tasks tab',
                  ),
                )
              else
                for (final task in pending.take(5))
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: TaskTile(
                      task: task,
                      onToggle: (v) => taskRepository.setDone(uid, task.id, v),
                      onTap: () => showTaskForm(context, task: task),
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }
}
