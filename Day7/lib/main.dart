import 'package:flutter/material.dart';

import ' screens/calculator_screen.dart';
import ' screens/counter_screen.dart';
import ' screens/form_screen.dart';
import ' screens/home_screen.dart';
import ' screens/quiz_screen.dart';
import ' screens/todo_screen.dart';

void main() {
  runApp(const StateManagementApp());
}

class StateManagementApp extends StatelessWidget {
  const StateManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter State Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/counter': (context) => const CounterScreen(),
        '/todo': (context) => const TodoScreen(),
        '/form': (context) => const FormScreen(),
        '/quiz': (context) => const QuizScreen(),
        '/calculator': (context) => const CalculatorScreen(),
      },
    );
  }
}
