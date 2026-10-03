import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/api_providers.dart';
import '../widgets/error_view.dart';
import 'post_detail_screen.dart';

/// The REST API screen. There is no setState and no _loading/_error variable:
/// the FutureProvider gives us an AsyncValue with three cases (loading, error, data).
class PostsScreen extends ConsumerWidget {
  const PostsScreen({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(postsProvider); // throw away the old result and fetch again
    try {
      await ref.read(postsProvider.future); // wait, so the refresh indicator stays until done
    } catch (_) {
      // The error is shown by the AsyncValue.when below.
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(visiblePostsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts (FutureProvider)'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SearchBar(
              hintText: 'Search posts...',
              leading: const Icon(Icons.search),
              onChanged: (value) => ref.read(postsQueryProvider.notifier).state = value,
            ),
          ),
        ),
      ),
      body: posts.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => ErrorView(
          message: '$error',
          onRetry: () => ref.invalidate(postsProvider),
        ),
        data: (list) => RefreshIndicator(
          onRefresh: () => _refresh(ref),
          child: list.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 120),
                    Center(child: Text('No posts found')),
                  ],
                )
              : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final post = list[i];
                    return ListTile(
                      leading: CircleAvatar(child: Text('${post.id}')),
                      title: Text(post.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text(post.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => PostDetailScreen(post: post)),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
