import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tasks/form/login_form.dart';

void main() {
  Future<void> pumpForm(WidgetTester tester) {
    return tester.pumpWidget(const MaterialApp(home: LoginFormScreen()));
  }

  group('LoginFormScreen', () {
    testWidgets('renders email field, password field and submit button',
        (WidgetTester tester) async {
      await pumpForm(tester);

      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);
      expect(find.text('Form is valid'), findsNothing);
    });

    testWidgets('shows required errors when submitting an empty form',
        (WidgetTester tester) async {
      await pumpForm(tester);

      await tester.tap(find.text('Submit'));
      await tester.pump();

      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
      expect(find.text('Form is valid'), findsNothing);
    });

    testWidgets('shows an error for an invalid email',
        (WidgetTester tester) async {
      await pumpForm(tester);

      await tester.enterText(find.byKey(const Key('emailField')), 'user@');
      await tester.enterText(find.byKey(const Key('passwordField')), '123456');
      await tester.tap(find.text('Submit'));
      await tester.pump();

      expect(find.text('Enter a valid email'), findsOneWidget);
      expect(find.text('Form is valid'), findsNothing);
    });

    testWidgets('shows an error for a short password',
        (WidgetTester tester) async {
      await pumpForm(tester);

      await tester.enterText(
        find.byKey(const Key('emailField')),
        'user@mail.com',
      );
      await tester.enterText(find.byKey(const Key('passwordField')), '123');
      await tester.tap(find.text('Submit'));
      await tester.pump();

      expect(
        find.text('Password must be at least 6 characters'),
        findsOneWidget,
      );
      expect(find.text('Form is valid'), findsNothing);
    });

    testWidgets('shows "Form is valid" when all fields are valid',
        (WidgetTester tester) async {
      await pumpForm(tester);

      await tester.enterText(
        find.byKey(const Key('emailField')),
        'user@mail.com',
      );
      await tester.enterText(find.byKey(const Key('passwordField')), '123456');
      await tester.tap(find.text('Submit'));
      await tester.pump();

      expect(find.text('Email is required'), findsNothing);
      expect(find.text('Password is required'), findsNothing);
      expect(find.text('Form is valid'), findsOneWidget);
    });
  });
}
