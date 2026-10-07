import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post.dart';

/// The http.Client is injected so it can be replaced with a mock in tests.
class PostService {
  PostService(this.client);

  final http.Client client;

  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<Post>> fetchPosts() async {
    final http.Response response =
        await client.get(Uri.parse('$baseUrl/posts'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((dynamic item) => Post.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Failed to load posts');
  }
}
