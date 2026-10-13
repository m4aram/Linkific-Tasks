import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/utils/formatters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatAmount', () {
    test('adds thousand separators and two decimals', () {
      expect(formatAmount(0), '\$0.00');
      expect(formatAmount(4.5), '\$4.50');
      expect(formatAmount(1234), '\$1,234.00');
      expect(formatAmount(1234567.891), '\$1,234,567.89');
      expect(formatAmount(-12), '-\$12.00');
      expect(formatAmount(-0.001), '\$0.00');
    });
  });

  group('dates', () {
    final now = DateTime(2026, 10, 13, 15);

    test('formatDate is ISO', () {
      expect(formatDate(DateTime(2026, 3, 7)), '2026-03-07');
    });

    test('formatFriendlyDate', () {
      expect(formatFriendlyDate(DateTime(2026, 10, 13, 1), now: now), 'Today');
      expect(formatFriendlyDate(DateTime(2026, 10, 12), now: now), 'Yesterday');
      expect(formatFriendlyDate(DateTime(2026, 9, 1), now: now), 'Sep 1, 2026');
    });

    test('formatMonth', () {
      expect(formatMonth(DateTime(2026, 10, 1)), 'October 2026');
    });
  });

  group('Expense.fromMap', () {
    test('reads a normal row', () {
      final e = Expense.fromMap({
        'id': 'abc',
        'title': 'Taxi',
        'amount': 12,
        'category': 'Transport',
        'date': '2026-10-01',
      });
      expect(e.amount, 12.0);
      expect(e.category, 'Transport');
      expect(e.date, DateTime(2026, 10, 1));
    });

    test('handles unknown category and text amount', () {
      final e = Expense.fromMap({
        'id': 7,
        'title': ' Gift ',
        'amount': '19.90',
        'category': 'Gifts',
        'date': '2026-10-01',
      });
      expect(e.id, '7');
      expect(e.title, 'Gift');
      expect(e.amount, 19.9);
      expect(e.category, 'Other');
    });

    test('toMap stores the date without time', () {
      final e = Expense(
        id: '1',
        title: 'Rent',
        amount: 500,
        category: 'Bills',
        date: DateTime(2026, 10, 1, 23, 59),
      );
      expect(e.toMap()['date'], '2026-10-01');
    });

    test('hasSameContentAs ignores the time of day', () {
      final a = Expense(
        id: '1',
        title: 'Rent',
        amount: 500,
        category: 'Bills',
        date: DateTime(2026, 10, 1, 8),
      );
      expect(a.hasSameContentAs(a.copyWith(date: DateTime(2026, 10, 1))), isTrue);
      expect(a.hasSameContentAs(a.copyWith(amount: 501)), isFalse);
    });
  });
}
