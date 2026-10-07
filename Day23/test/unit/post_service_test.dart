import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tasks/models/post.dart';
import 'package:flutter_testing_tasks/services/post_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('PostService.fetchPosts (mocked API)', () {
    test('returns a list of posts when the response is 200', () async {
      // MockClient replaces the real http.Client: no real network call.
      final MockClient mockClient = MockClient((http.Request request) async {
        return http.Response(
          jsonEncode([
            {'id': 1, 'title': 'First', 'body': 'First body'},
            {'id': 2, 'title': 'Second', 'body': 'Second body'},
          ]),
          200,
        );
      });
      final PostService service = PostService(mockClient);

      final List<Post> posts = await service.fetchPosts();

      expect(posts, hasLength(2));
      expect(posts.first.id, 1);
      expect(posts.first.title, 'First');
      expect(posts.last.title, 'Second');
    });

    test('sends a GET request to the posts endpoint', () async {
      late http.Request capturedRequest;
      final MockClient mockClient = MockClient((http.Request request) async {
        capturedRequest = request;
        return http.Response('[]', 200);
      });
      final PostService service = PostService(mockClient);

      await service.fetchPosts();

      expect(capturedRequest.method, 'GET');
      expect(capturedRequest.url.toString(), '${PostService.baseUrl}/posts');
    });

    test('returns an empty list when the API returns no posts', () async {
      final MockClient mockClient = MockClient((http.Request request) async {
        return http.Response('[]', 200);
      });
      final PostService service = PostService(mockClient);

      expect(await service.fetchPosts(), isEmpty);
    });

    test('throws an Exception when the response is not 200', () async {
      final MockClient mockClient = MockClient((http.Request request) async {
        return http.Response('Not Found', 404);
      });
      final PostService service = PostService(mockClient);

      await expectLater(service.fetchPosts(), throwsException);
    });
  });
}
