import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/comment.dart';
import '../models/post.dart';
import '../models/user.dart';

/// A single exception type the UI can catch and show to the user.
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  const ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  static const Duration _timeout = Duration(seconds: 10);
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
  };

  final http.Client _client;
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  // ---------------------------------------------------------------- core

  /// Runs a request, applies the timeout, checks the status code,
  /// decodes JSON and converts every failure into an [ApiException].
  Future<dynamic> _send(Future<http.Response> Function() request) async {
    try {
      final response = await request().timeout(_timeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isEmpty) return null;
        return jsonDecode(utf8.decode(response.bodyBytes));
      }
      throw ApiException(_messageForStatus(response.statusCode), response.statusCode);
    } on TimeoutException {
      throw const ApiException('The request timed out. Please try again.');
    } on SocketException {
      throw const ApiException('No internet connection.');
    } on http.ClientException {
      throw const ApiException('Network error. Check your connection.');
    } on FormatException {
      throw const ApiException('Received invalid data from the server.');
    }
  }

  String _messageForStatus(int code) {
    if (code == 400) return 'Bad request (400).';
    if (code == 401 || code == 403) return 'Not authorized ($code).';
    if (code == 404) return 'Not found (404).';
    if (code >= 500) return 'Server error ($code). Try again later.';
    return 'Unexpected error ($code).';
  }

  Uri _uri(String path, [Map<String, String>? query]) =>
      Uri.parse('$_baseUrl$path').replace(queryParameters: query);

  // ----------------------------------------------------------------- GET

  /// GET /posts?_page=1&_limit=100  (query parameters example)
  Future<List<Post>> getPosts({int page = 1, int limit = 100}) async {
    final data = await _send(() => _client.get(
          _uri('/posts', {'_page': '$page', '_limit': '$limit'}),
          headers: _headers,
        ));
    return (data as List)
        .map((e) => Post.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /users/{id}  (nested JSON)
  Future<User> getUser(int id) async {
    final data = await _send(() => _client.get(_uri('/users/$id'), headers: _headers));
    return User.fromJson(data as Map<String, dynamic>);
  }

  /// GET /comments?postId={id}  (filtering with query parameters)
  Future<List<Comment>> getComments(int postId) async {
    final data = await _send(() => _client.get(
          _uri('/comments', {'postId': '$postId'}),
          headers: _headers,
        ));
    return (data as List)
        .map((e) => Comment.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ---------------------------------------------------------------- POST

  Future<Post> createPost(Post post) async {
    final data = await _send(() => _client.post(
          _uri('/posts'),
          headers: _headers,
          body: jsonEncode({
            'title': post.title,
            'body': post.body,
            'userId': post.userId,
          }),
        ));
    return Post.fromJson(data as Map<String, dynamic>);
  }

  // ----------------------------------------------------------------- PUT

  /// Replaces the whole resource.
  Future<Post> updatePost(Post post) async {
    final data = await _send(() => _client.put(
          _uri('/posts/${post.id}'),
          headers: _headers,
          body: jsonEncode(post.toJson()),
        ));
    return Post.fromJson(data as Map<String, dynamic>);
  }

  // --------------------------------------------------------------- PATCH

  /// Updates only the fields you send.
  Future<Post> patchPostTitle(int id, String title) async {
    final data = await _send(() => _client.patch(
          _uri('/posts/$id'),
          headers: _headers,
          body: jsonEncode({'title': title}),
        ));
    return Post.fromJson(data as Map<String, dynamic>);
  }

  // -------------------------------------------------------------- DELETE

  Future<void> deletePost(int id) async {
    await _send(() => _client.delete(_uri('/posts/$id'), headers: _headers));
  }
}
