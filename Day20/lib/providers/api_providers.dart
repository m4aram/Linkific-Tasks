import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/comment.dart';
import '../models/post.dart';
import '../services/api_service.dart';

/// Provider = a service object. Easy to replace with a fake in tests (overrides).
final apiServiceProvider = Provider<ApiService>((ref) {
  final api = ApiService();
  ref.onDispose(api.dispose); // clean up when the provider is destroyed
  return api;
});

/// FutureProvider = runs an async function and exposes AsyncValue:
/// loading -> data, or loading -> error. No _loading / _error variables needed.
final postsProvider = FutureProvider<List<Post>>((ref) async {
  final api = ref.watch(apiServiceProvider);
  return api.getPosts();
});

/// StateProvider = the search text.
final postsQueryProvider = StateProvider<String>((ref) => '');

/// StateProvider = ids of deleted posts (the demo API does not really delete).
final deletedPostIdsProvider = StateProvider<Set<int>>((ref) => <int>{});

/// Provider that combines three providers: the API data + the search + the deleted ids.
final visiblePostsProvider = Provider<AsyncValue<List<Post>>>((ref) {
  final posts = ref.watch(postsProvider);
  final query = ref.watch(postsQueryProvider).trim().toLowerCase();
  final deleted = ref.watch(deletedPostIdsProvider);

  return posts.whenData((list) {
    return list.where((post) {
      if (deleted.contains(post.id)) return false;
      if (query.isEmpty) return true;
      return post.title.toLowerCase().contains(query) || post.body.toLowerCase().contains(query);
    }).toList();
  });
});

/// FutureProvider.family = a provider that takes a parameter (the post id).
/// Each id gets its own cached state.
final postByIdProvider = FutureProvider.family<Post, int>((ref, id) {
  return ref.watch(apiServiceProvider).getPost(id);
});

final postCommentsProvider = FutureProvider.family<List<Comment>, int>((ref, postId) {
  return ref.watch(apiServiceProvider).getComments(postId);
});
