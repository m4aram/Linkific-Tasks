import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/post.dart';
import '../providers/posts_provider.dart';
import '../widgets/error_view.dart';

/// The REST API screen, now a StatelessWidget.
/// There is no setState and no _loading/_error variables here: everything comes from PostsProvider.
class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts (REST + Provider)'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SearchBar(
              hintText: 'Search posts...',
              leading: const Icon(Icons.search),
              onChanged: (value) => context.read<PostsProvider>().setQuery(value),
            ),
          ),
        ),
      ),
      body: Consumer<PostsProvider>(
        builder: (context, provider, _) {
          switch (provider.status) {
            case PostsStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case PostsStatus.error:
              return ErrorView(
                message: provider.error ?? 'Something went wrong',
                onRetry: () => provider.load(),
              );
            case PostsStatus.ready:
              return _list(context, provider);
          }
        },
      ),
    );
  }

  Widget _list(BuildContext context, PostsProvider provider) {
    final posts = provider.visiblePosts;
    final messenger = ScaffoldMessenger.of(context);

    return RefreshIndicator(
      onRefresh: () async {
        final error = await provider.load(showSpinner: false);
        if (error != null) {
          messenger.showSnackBar(SnackBar(content: Text(error)));
        }
      },
      child: posts.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 120),
                Center(child: Text('No posts found')),
              ],
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: posts.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final post = posts[i];
                return ListTile(
                  leading: CircleAvatar(child: Text('${post.id}')),
                  title: Text(post.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text(post.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                  onTap: () => _showPost(context, post),
                );
              },
            ),
    );
  }

  void _showPost(BuildContext context, Post post) {
    final provider = context.read<PostsProvider>();
    final messenger = ScaffoldMessenger.of(context);

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.title, style: Theme.of(sheetContext).textTheme.titleLarge),
            const SizedBox(height: 12),
            Text(post.body),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () async {
                Navigator.pop(sheetContext);
                final error = await provider.deletePost(post);
                messenger.showSnackBar(
                  SnackBar(content: Text(error ?? 'Post deleted (DELETE request)')),
                );
              },
              icon: const Icon(Icons.delete_outline),
              label: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
