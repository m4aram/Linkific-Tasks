import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'calculator/calculator_screen.dart';
import 'form/login_form.dart';
import 'posts/posts_screen.dart';
import 'services/post_service.dart';
import 'state/counter_notifier.dart';
import 'state/counter_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final CounterNotifier counter = CounterNotifier();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Testing Tasks',
      home: HomeScreen(counter: counter),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.counter});

  final CounterNotifier counter;

  void _open(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (BuildContext context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Testing Tasks')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Calculator'),
            onTap: () => _open(context, const CalculatorScreen()),
          ),
          ListTile(
            title: const Text('Login Form'),
            onTap: () => _open(context, const LoginFormScreen()),
          ),
          ListTile(
            title: const Text('Counter'),
            onTap: () => _open(context, CounterScreen(notifier: counter)),
          ),
          ListTile(
            title: const Text('Posts'),
            onTap: () => _open(
              context,
              PostsScreen(service: PostService(http.Client())),
            ),
          ),
        ],
      ),
    );
  }
}
