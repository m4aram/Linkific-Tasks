import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tasks/models/post.dart';

void main() {
  group('Post model', () {
    test('fromJson creates a Post from a JSON map', () {
      final Map<String, dynamic> json = {
        'id': 1,
        'title': 'Hello',
        'body': 'World',
      };

      final Post post = Post.fromJson(json);

      expect(post.id, 1);
      expect(post.title, 'Hello');
      expect(post.body, 'World');
    });

    test('toJson converts a Post to a JSON map', () {
      const Post post = Post(id: 2, title: 'Title', body: 'Body');

      expect(post.toJson(), {'id': 2, 'title': 'Title', 'body': 'Body'});
    });

    test('fromJson and toJson are consistent with each other', () {
      const Post original = Post(id: 3, title: 'A', body: 'B');

      final Post copy = Post.fromJson(original.toJson());

      expect(copy.id, original.id);
      expect(copy.title, original.title);
      expect(copy.body, original.body);
    });
  });
}
