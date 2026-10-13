import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/providers/auth_provider.dart';
import 'package:expense_tracker/providers/expense_provider.dart';
import 'package:expense_tracker/providers/theme_provider.dart';
import 'package:expense_tracker/screens/expense_form_screen.dart';
import 'package:expense_tracker/screens/home_screen.dart';
import 'package:expense_tracker/theme/app_theme.dart';
import 'package:expense_tracker/widgets/loading_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'fakes.dart';

Widget _app({
  required ExpenseProvider expenses,
  required Widget home,
  ThemeMode mode = ThemeMode.light,
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => AuthProvider(FakeAuthService())),
      ChangeNotifierProvider.value(value: expenses),
    ],
    child: MaterialApp(
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: mode,
      home: home,
    ),
  );
}

/// Opens the form from a first screen, the same way the app does.
Widget _formLauncher() {
  return Builder(
    builder: (context) => Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ExpenseFormScreen()),
          ),
          child: const Text('open form'),
        ),
      ),
    ),
  );
}

void main() {
  group('LoadingButton', () {
    testWidgets('shows a spinner and blocks taps while loading', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingButton(
              label: 'Save',
              isLoading: true,
              onPressed: () => taps++,
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.tap(find.byType(LoadingButton));
      expect(taps, 0);
    });
  });

  group('HomeScreen', () {
    late FakeExpenseService service;

    setUp(() {
      service = FakeExpenseService(
        initial: [
          sampleExpense(id: '1', title: 'Coffee', date: DateTime.now()),
          sampleExpense(
            id: '2',
            title: 'Bus pass',
            amount: 30,
            category: 'Transport',
            date: DateTime.now(),
          ),
        ],
      );
    });

    testWidgets('shows summary and expenses after loading', (tester) async {
      await tester.pumpWidget(
        _app(expenses: ExpenseProvider(service), home: const HomeScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Spent in'), findsOneWidget);
      expect(find.text('Coffee'), findsOneWidget);
      expect(find.text('Bus pass'), findsOneWidget);
    });

    testWidgets('search filters the list and can be cleared', (tester) async {
      await tester.pumpWidget(
        _app(expenses: ExpenseProvider(service), home: const HomeScreen()),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'bus');
      await tester.pumpAndSettle();
      expect(find.text('Coffee'), findsNothing);
      expect(find.text('Bus pass'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'pizza');
      await tester.pumpAndSettle();
      expect(find.text('No matching expenses'), findsOneWidget);

      await tester.ensureVisible(find.text('Clear filters').first);
      await tester.tap(find.text('Clear filters').first);
      await tester.pumpAndSettle();
      expect(find.text('Coffee'), findsOneWidget);
    });

    testWidgets('shows the empty state for a new user', (tester) async {
      await tester.pumpWidget(
        _app(
          expenses: ExpenseProvider(FakeExpenseService()),
          home: const HomeScreen(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('No expenses yet'), findsOneWidget);
    });

    testWidgets('shows an error with a retry button when offline',
            (tester) async {
          service.failFetch = true;
          await tester.pumpWidget(
            _app(expenses: ExpenseProvider(service), home: const HomeScreen()),
          );
          await tester.pumpAndSettle();
          expect(find.text('Could not load your expenses'), findsOneWidget);

          service.failFetch = false;
          await tester.tap(find.text('Try again'));
          await tester.pumpAndSettle();
          expect(find.text('Coffee'), findsOneWidget);
        });

    testWidgets('swipe to delete offers undo', (tester) async {
      await tester.pumpWidget(
        _app(expenses: ExpenseProvider(service), home: const HomeScreen()),
      );
      await tester.pumpAndSettle();

      await tester.drag(find.text('Coffee'), const Offset(-600, 0));
      await tester.pumpAndSettle();
      expect(find.text('Coffee'), findsNothing);
      expect(find.text('Undo'), findsOneWidget);

      await tester.tap(find.text('Undo'));
      await tester.pumpAndSettle();
      expect(find.text('Coffee'), findsOneWidget);
    });

    testWidgets('works in dark mode on a small phone', (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _app(
          expenses: ExpenseProvider(service),
          home: const HomeScreen(),
          mode: ThemeMode.dark,
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Coffee'), findsOneWidget);
    });

    testWidgets('works on a tablet-size screen', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _app(expenses: ExpenseProvider(service), home: const HomeScreen()),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });

  group('ExpenseFormScreen', () {
    testWidgets('shows validation errors for an empty form', (tester) async {
      await tester.pumpWidget(
        _app(
          expenses: ExpenseProvider(FakeExpenseService()),
          home: _formLauncher(),
        ),
      );
      await tester.tap(find.text('open form'));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(LoadingButton));
      await tester.pumpAndSettle();
      expect(find.text('Title is required'), findsOneWidget);
      expect(find.text('Amount is required'), findsOneWidget);
    });

    testWidgets('adds an expense and closes', (tester) async {
      final service = FakeExpenseService();
      await tester.pumpWidget(
        _app(expenses: ExpenseProvider(service), home: _formLauncher()),
      );
      await tester.tap(find.text('open form'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), 'Lunch');
      await tester.enterText(find.byType(TextFormField).at(1), '12,50');
      await tester.tap(find.text('Health'));
      await tester.tap(find.byType(LoadingButton));
      await tester.pumpAndSettle();

      expect(service.items, hasLength(1));
      expect(service.items.first.amount, 12.5);
      expect(service.items.first.category, 'Health');
      expect(find.text('Expense added'), findsOneWidget);
      expect(find.byType(ExpenseFormScreen), findsNothing);
    });

    testWidgets('asks before discarding unsaved changes', (tester) async {
      await tester.pumpWidget(
        _app(
          expenses: ExpenseProvider(FakeExpenseService()),
          home: _formLauncher(),
        ),
      );
      await tester.tap(find.text('open form'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), 'Half typed');
      await tester.pump();
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('Discard changes?'), findsOneWidget);

      await tester.tap(find.text('Discard'));
      await tester.pumpAndSettle();
      expect(find.byType(ExpenseFormScreen), findsNothing);
    });

    testWidgets('unknown category from the database does not crash',
            (tester) async {
          final expense = Expense.fromMap({
            'id': '9',
            'title': 'Gift',
            'amount': 20,
            'category': 'Gifts',
            'date': '2026-10-01',
          });
          await tester.pumpWidget(
            _app(
              expenses: ExpenseProvider(FakeExpenseService()),
              home: ExpenseFormScreen(expense: expense),
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          expect(find.text('Edit Expense'), findsOneWidget);
        });
  });
}