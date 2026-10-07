import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tasks/posts/posts_screen.dart';
import 'package:flutter_testing_tasks/services/post_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  // Mocked API that returns [count] posts: "Post 1" ... "Post N".
  PostService serviceWithPosts(int count) {
    final MockClient mockClient = MockClient((http.Request request) async {
      final List<Map<String, dynamic>> posts = List.generate(
        count,
        (int i) => {'id': i + 1, 'title': 'Post ${i + 1}', 'body': 'Body'},
      );
      return http.Response(jsonEncode(posts), 200);
    });
    return PostService(mockClient);
  }

  group('PostsScreen', () {
    testWidgets('shows a loading indicator, then the list of posts',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: PostsScreen(service: serviceWithPosts(3))),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(ListTile), findsNWidgets(3));
      expect(find.text('Post 1'), findsOneWidget);
      expect(find.text('Post 3'), findsOneWidget);
    });

    testWidgets('scrolls down to reach the last post',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: PostsScreen(service: serviceWithPosts(30))),
      );
      await tester.pumpAndSettle();

      expect(find.text('Post 1'), findsOneWidget);
      expect(find.text('Post 30'), findsNothing);

      await tester.scrollUntilVisible(
        find.text('Post 30'),
        300,
        scrollable: find.byType(Scrollable),
      );

      expect(find.text('Post 30'), findsOneWidget);
    });

    testWidgets('shows an error message when the API call fails',
        (WidgetTester tester) async {
      final MockClient mockClient = MockClient((http.Request request) async {
        return http.Response('Server error', 500);
      });

      await tester.pumpWidget(
        MaterialApp(home: PostsScreen(service: PostService(mockClient))),
      );
      await tester.pumpAndSettle();

      expect(find.text('Failed to load posts'), findsOneWidget);
      expect(find.byType(ListTile), findsNothing);
    });
  });
}
