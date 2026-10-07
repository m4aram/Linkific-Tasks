import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/post_service.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key, required this.service});

  final PostService service;

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  late final Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = widget.service.fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Failed to load posts'));
          }
          final List<Post> posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (BuildContext context, int index) {
              final Post post = posts[index];
              return ListTile(
                title: Text(post.title),
                subtitle: Text(post.body),
              );
            },
          );
        },
      ),
    );
  }
}
