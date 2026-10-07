import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tasks/calculator/calculator_screen.dart';
import 'package:flutter_testing_tasks/form/login_form.dart';
import 'package:flutter_testing_tasks/main.dart';
import 'package:flutter_testing_tasks/state/counter_screen.dart';

void main() {
  group('HomeScreen', () {
    testWidgets('renders the four menu items', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());

      expect(find.byType(ListTile), findsNWidgets(4));
      expect(find.text('Calculator'), findsOneWidget);
      expect(find.text('Login Form'), findsOneWidget);
      expect(find.text('Counter'), findsOneWidget);
      expect(find.text('Posts'), findsOneWidget);
    });

    testWidgets('tapping Calculator opens the calculator screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());

      await tester.tap(find.text('Calculator'));
      await tester.pumpAndSettle();

      expect(find.byType(CalculatorScreen), findsOneWidget);
    });

    testWidgets('tapping Login Form opens the form screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());

      await tester.tap(find.text('Login Form'));
      await tester.pumpAndSettle();

      expect(find.byType(LoginFormScreen), findsOneWidget);
    });

    testWidgets('tapping Counter opens the counter screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());

      await tester.tap(find.text('Counter'));
      await tester.pumpAndSettle();

      expect(find.byType(CounterScreen), findsOneWidget);
    });
  });
}
