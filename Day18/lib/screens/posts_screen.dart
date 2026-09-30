import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/api_service.dart';
import '../widgets/error_view.dart';
import 'countries_screen.dart';
import 'post_detail_screen.dart';
import 'post_form_screen.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final _api = ApiService();

  List<Post> _posts = [];
  String _query = '';
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  /// [showSpinner] is false for pull-to-refresh (the refresh indicator is the spinner).
  Future<void> _load({bool showSpinner = true}) async {
    if (showSpinner) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }
    try {
      final posts = await _api.getPosts();
      if (!mounted) return;
      setState(() {
        _posts = posts;
        _error = null;
        _loading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      if (_posts.isEmpty) {
        setState(() => _error = e.message);
      } else {
        // Keep showing old data, just tell the user the refresh failed.
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  List<Post> get _filtered {
    if (_query.trim().isEmpty) return _posts;
    final q = _query.toLowerCase();
    return _posts
        .where((p) => p.title.toLowerCase().contains(q) || p.body.toLowerCase().contains(q))
        .toList();
  }

  Future<void> _openDetail(Post post) async {
    final result = await Navigator.push<PostResult>(
      context,
      MaterialPageRoute(builder: (_) => PostDetailScreen(post: post)),
    );
    if (result == null || !mounted) return;
    setState(() {
      if (result.deleted) {
        _posts.removeWhere((p) => p.id == post.id);
      } else if (result.updated != null) {
        final i = _posts.indexWhere((p) => p.id == post.id);
        if (i != -1) _posts[i] = result.updated!;
      }
    });
  }

  Future<void> _createPost() async {
    final created = await Navigator.push<Post>(
      context,
      MaterialPageRoute(builder: (_) => const PostFormScreen()),
    );
    if (created != null && mounted) {
      setState(() => _posts.insert(0, created));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.public),
            tooltip: 'Countries',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CountriesScreen()),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SearchBar(
              hintText: 'Search posts...',
              leading: const Icon(Icons.search),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createPost,
        child: const Icon(Icons.add),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return ErrorView(message: _error!, onRetry: _load);

    final items = _filtered;
    return RefreshIndicator(
      onRefresh: () => _load(showSpinner: false),
      child: items.isEmpty
          ? ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 120),
          Center(child: Text('No posts found')),
        ],
      )
          : ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final post = items[i];
          return ListTile(
            leading: CircleAvatar(child: Text('${post.id}')),
            title: Text(post.title, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text(post.body, maxLines: 2, overflow: TextOverflow.ellipsis),
            onTap: () => _openDetail(post),
          );
        },
      ),
    );
  }
}