import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tasks/state/counter_notifier.dart';
import 'package:flutter_testing_tasks/state/counter_screen.dart';

void main() {
  late CounterNotifier notifier;

  setUp(() {
    notifier = CounterNotifier();
  });

  tearDown(() {
    notifier.dispose();
  });

  Future<void> pumpCounter(WidgetTester tester) {
    return tester.pumpWidget(
      MaterialApp(home: CounterScreen(notifier: notifier)),
    );
  }

  group('CounterScreen (state management)', () {
    testWidgets('renders the initial count and the buttons',
        (WidgetTester tester) async {
      await pumpCounter(tester);

      expect(find.text('0'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.remove), findsOneWidget);
      expect(find.text('Reset'), findsOneWidget);
    });

    testWidgets('tapping + increments the displayed count',
        (WidgetTester tester) async {
      await pumpCounter(tester);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
      expect(notifier.count, 1);
    });

    testWidgets('tapping - decrements the displayed count',
        (WidgetTester tester) async {
      await pumpCounter(tester);

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      expect(find.text('-1'), findsOneWidget);
      expect(notifier.count, -1);
    });

    testWidgets('tapping Reset sets the displayed count back to 0',
        (WidgetTester tester) async {
      await pumpCounter(tester);

      await tester.tap(find.byIcon(Icons.add));
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
      expect(find.text('2'), findsOneWidget);

      await tester.tap(find.text('Reset'));
      await tester.pump();

      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('UI rebuilds when the state changes outside the widget',
        (WidgetTester tester) async {
      await pumpCounter(tester);

      notifier.increment();
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
    });
  });
}
