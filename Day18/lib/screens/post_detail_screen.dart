import 'package:flutter/material.dart';

import '../models/comment.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../widgets/error_view.dart';
import 'post_form_screen.dart';

/// What the detail screen tells the list screen when it closes.
class PostResult {
  final Post? updated;
  final bool deleted;
  const PostResult({this.updated, this.deleted = false});
}

class PostDetailScreen extends StatefulWidget {
  final Post post;
  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final _api = ApiService();

  late Post _post;
  bool _changed = false;

  User? _author;
  List<Comment> _comments = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      // Two requests in parallel.
      final results = await Future.wait([
        _api.getUser(_post.userId),
        _api.getComments(_post.id),
      ]);
      if (!mounted) return;
      setState(() {
        _author = results[0] as User;
        _comments = results[1] as List<Comment>;
        _loading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _loading = false;
      });
    }
  }

  void _toast(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  /// PUT: full update through the form screen.
  Future<void> _edit() async {
    final updated = await Navigator.push<Post>(
      context,
      MaterialPageRoute(builder: (_) => PostFormScreen(post: _post)),
    );
    if (updated != null && mounted) {
      setState(() {
        _post = updated;
        _changed = true;
      });
      _toast('Post updated (PUT)');
    }
  }

  /// PATCH: change only the title.
  Future<void> _rename() async {
    final controller = TextEditingController(text: _post.title);
    final newTitle = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Quick rename (PATCH)'),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (newTitle == null || newTitle.isEmpty) return;
    try {
      final patched = await _api.patchPostTitle(_post.id, newTitle);
      if (!mounted) return;
      setState(() {
        _post = _post.copyWith(title: patched.title);
        _changed = true;
      });
      _toast('Title updated (PATCH)');
    } on ApiException catch (e) {
      if (mounted) _toast(e.message);
    }
  }

  /// DELETE
  Future<void> _delete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete post?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await _api.deletePost(_post.id);
      if (!mounted) return;
      Navigator.pop(context, const PostResult(deleted: true));
    } on ApiException catch (e) {
      if (mounted) _toast(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          Navigator.pop(context, PostResult(updated: _changed ? _post : null));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Post #${_post.id}'),
          actions: [
            PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'edit') _edit();
                if (v == 'rename') _rename();
                if (v == 'delete') _delete();
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit (PUT)')),
                PopupMenuItem(value: 'rename', child: Text('Rename (PATCH)')),
                PopupMenuItem(value: 'delete', child: Text('Delete (DELETE)')),
              ],
            ),
          ],
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    final theme = Theme.of(context);
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          Text(_post.title, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text(_post.body, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 24),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_error != null)
            SizedBox(height: 260, child: ErrorView(message: _error!, onRetry: _load))
          else ...[
            _authorCard(_author!),
            const SizedBox(height: 24),
            Text('Comments (${_comments.length})', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            for (final c in _comments)
              Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(c.name),
                  subtitle: Text('${c.email}\n${c.body}'),
                  isThreeLine: true,
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _authorCard(User u) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Author', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Text(u.name, style: Theme.of(context).textTheme.titleMedium),
            Text('@${u.username} · ${u.email}'),
            const SizedBox(height: 8),
            // Nested JSON: user.address.city, user.company.name
            Text('📍 ${u.address.city}, ${u.address.street}'),
            Text('🏢 ${u.company.name}'),
            Text('📞 ${u.phone}'),
          ],
        ),
      ),
    );
  }
}
