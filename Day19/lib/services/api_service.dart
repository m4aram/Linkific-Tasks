import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/post.dart';

/// One exception type for the UI: it always carries a readable message.
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

  void dispose() => _client.close();

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
    if (code == 404) return 'Not found (404).';
    if (code >= 500) return 'Server error ($code). Try again later.';
    return 'Unexpected error ($code).';
  }

  Uri _uri(String path, [Map<String, String>? query]) =>
      Uri.parse('$_baseUrl$path').replace(queryParameters: query);

  Future<List<Post>> getPosts({int page = 1, int limit = 50}) async {
    final data = await _send(() => _client.get(
          _uri('/posts', {'_page': '$page', '_limit': '$limit'}),
          headers: _headers,
        ));
    return (data as List).map((e) => Post.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Post> getPost(int id) async {
    final data = await _send(() => _client.get(_uri('/posts/$id'), headers: _headers));
    return Post.fromJson(data as Map<String, dynamic>);
  }

  Future<void> deletePost(int id) async {
    await _send(() => _client.delete(_uri('/posts/$id'), headers: _headers));
  }
}
