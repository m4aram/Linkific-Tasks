import 'package:flutter/material.dart';
import 'countries_screen.dart';
import '../models/post.dart';
import '../services/api_service.dart';

/// Create (POST) when [post] is null, otherwise edit (PUT).
class PostFormScreen extends StatefulWidget {
  final Post? post;
  const PostFormScreen({super.key, this.post});

  @override
  State<PostFormScreen> createState() => _PostFormScreenState();
}

class _PostFormScreenState extends State<PostFormScreen> {
  final _api = ApiService();
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _body;
  bool _saving = false;

  bool get _isEdit => widget.post != null;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.post?.title ?? '');
    _body = TextEditingController(text: widget.post?.body ?? '');
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final draft = Post(
      userId: widget.post?.userId ?? 1,
      id: widget.post?.id ?? 0,
      title: _title.text.trim(),
      body: _body.text.trim(),
    );

    try {
      final result = _isEdit ? await _api.updatePost(draft) : await _api.createPost(draft);
      if (!mounted) return;
      Navigator.pop(context, result);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit post' : 'New post')),

      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Title is required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _body,
              maxLines: 6,
              decoration: const InputDecoration(labelText: 'Body', border: OutlineInputBorder()),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Body is required' : null,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _submit,
              child: _saving
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(_isEdit ? 'Save (PUT)' : 'Create (POST)'),
            ),
          ],
        ),
      ),
    );
  }
}
