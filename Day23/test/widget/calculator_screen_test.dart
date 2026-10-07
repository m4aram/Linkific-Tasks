import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tasks/calculator/calculator_screen.dart';

void main() {
  Future<void> pumpCalculator(WidgetTester tester) {
    return tester.pumpWidget(const MaterialApp(home: CalculatorScreen()));
  }

  Future<void> enterNumbers(WidgetTester tester, String a, String b) async {
    await tester.enterText(find.byKey(const Key('firstNumberField')), a);
    await tester.enterText(find.byKey(const Key('secondNumberField')), b);
  }

  group('CalculatorScreen', () {
    testWidgets('renders two fields and four operation buttons',
        (WidgetTester tester) async {
      await pumpCalculator(tester);

      expect(find.text('Calculator'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsNWidgets(4));
      expect(find.text('+'), findsOneWidget);
      expect(find.text('-'), findsOneWidget);
      expect(find.text('*'), findsOneWidget);
      expect(find.text('/'), findsOneWidget);
    });

    testWidgets('shows the sum when + is tapped', (WidgetTester tester) async {
      await pumpCalculator(tester);

      await enterNumbers(tester, '2', '3');
      await tester.tap(find.text('+'));
      await tester.pump();

      expect(find.text('Result: 5.0'), findsOneWidget);
    });

    testWidgets('shows the difference when - is tapped',
        (WidgetTester tester) async {
      await pumpCalculator(tester);

      await enterNumbers(tester, '10', '4');
      await tester.tap(find.text('-'));
      await tester.pump();

      expect(find.text('Result: 6.0'), findsOneWidget);
    });

    testWidgets('shows the product when * is tapped',
        (WidgetTester tester) async {
      await pumpCalculator(tester);

      await enterNumbers(tester, '4', '5');
      await tester.tap(find.text('*'));
      await tester.pump();

      expect(find.text('Result: 20.0'), findsOneWidget);
    });

    testWidgets('shows the quotient when / is tapped',
        (WidgetTester tester) async {
      await pumpCalculator(tester);

      await enterNumbers(tester, '9', '3');
      await tester.tap(find.text('/'));
      await tester.pump();

      expect(find.text('Result: 3.0'), findsOneWidget);
    });

    testWidgets('shows an error message when dividing by zero',
        (WidgetTester tester) async {
      await pumpCalculator(tester);

      await enterNumbers(tester, '9', '0');
      await tester.tap(find.text('/'));
      await tester.pump();

      expect(find.text('Cannot divide by zero'), findsOneWidget);
    });

    testWidgets('shows "Invalid input" when a field is not a number',
        (WidgetTester tester) async {
      await pumpCalculator(tester);

      await enterNumbers(tester, 'abc', '3');
      await tester.tap(find.text('+'));
      await tester.pump();

      expect(find.text('Invalid input'), findsOneWidget);
    });
  });
}
