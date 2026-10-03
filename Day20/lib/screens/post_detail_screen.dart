import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/post.dart';
import '../providers/api_providers.dart';
import '../services/api_service.dart';
import '../widgets/error_view.dart';

class PostDetailScreen extends ConsumerWidget {
  final Post post;

  const PostDetailScreen({super.key, required this.post});

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      await ref.read(apiServiceProvider).deletePost(post.id); // DELETE request
      if (!context.mounted) return;
      final deleted = ref.read(deletedPostIdsProvider);
      ref.read(deletedPostIdsProvider.notifier).state = {...deleted, post.id};
      navigator.pop();
      messenger.showSnackBar(const SnackBar(content: Text('Post deleted (DELETE request)')));
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // family: one provider per post id. Each id is fetched and cached separately.
    final comments = ref.watch(postCommentsProvider(post.id));

    return Scaffold(
      appBar: AppBar(
        title: Text('Post #${post.id}'),
        actions: [
          IconButton(
            tooltip: 'Delete',
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _delete(context, ref),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(post.title, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text(post.body, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 24),
          comments.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stackTrace) => SizedBox(
              height: 240,
              child: ErrorView(
                message: '$error',
                onRetry: () => ref.invalidate(postCommentsProvider(post.id)),
              ),
            ),
            data: (list) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Comments (${list.length})', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                for (final c in list)
                  Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(c.name),
                      subtitle: Text('${c.email}\n${c.body}'),
                      isThreeLine: true,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
