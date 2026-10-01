import 'package:flutter/foundation.dart';

import '../models/post.dart';
import '../services/api_service.dart';

enum PostsStatus { loading, ready, error }

/// The REST API app converted to Provider.
/// All the state that used to live in setState (_loading, _error, _posts, _query)
/// now lives here, so any screen can use it.
class PostsProvider extends ChangeNotifier {
  PostsProvider(this._api);

  final ApiService _api;

  PostsStatus _status = PostsStatus.loading;
  List<Post> _posts = [];
  String _query = '';
  String? _error;

  PostsStatus get status => _status;
  String? get error => _error;

  List<Post> get visiblePosts {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return _posts;
    return _posts
        .where((p) => p.title.toLowerCase().contains(q) || p.body.toLowerCase().contains(q))
        .toList();
  }

  /// Loads the posts. Returns an error message (or null on success)
  /// so the screen can decide how to show it (for example a SnackBar on refresh).
  Future<String?> load({bool showSpinner = true}) async {
    if (showSpinner) {
      _status = PostsStatus.loading;
      _error = null;
      notifyListeners();
    }
    try {
      _posts = await _api.getPosts();
      _status = PostsStatus.ready;
      _error = null;
      notifyListeners();
      return null;
    } on ApiException catch (e) {
      if (_posts.isEmpty) {
        // nothing to show -> full error screen with Retry
        _status = PostsStatus.error;
        _error = e.message;
        notifyListeners();
      }
      return e.message;
    }
  }

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  /// DELETE request, then remove the post from the local list.
  Future<String?> deletePost(Post post) async {
    try {
      await _api.deletePost(post.id);
      _posts = _posts.where((p) => p.id != post.id).toList();
      notifyListeners();
      return null;
    } on ApiException catch (e) {
      return e.message;
    }
  }
}
