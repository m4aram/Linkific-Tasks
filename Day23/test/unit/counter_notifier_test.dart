import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tasks/state/counter_notifier.dart';

void main() {
  late CounterNotifier notifier;

  // Runs before every test.
  setUp(() {
    notifier = CounterNotifier();
  });

  // Runs after every test: release the notifier.
  tearDown(() {
    notifier.dispose();
  });

  group('CounterNotifier', () {
    test('initial count is 0', () {
      expect(notifier.count, 0);
    });

    test('increment increases count by 1', () {
      notifier.increment();

      expect(notifier.count, 1);
    });

    test('decrement decreases count by 1', () {
      notifier.decrement();

      expect(notifier.count, -1);
    });

    test('reset sets count back to 0', () {
      notifier.increment();
      notifier.increment();

      notifier.reset();

      expect(notifier.count, 0);
    });

    test('notifies listeners on every state change', () {
      int notifications = 0;
      notifier.addListener(() => notifications++);

      notifier.increment();
      notifier.decrement();
      notifier.reset();

      expect(notifications, 3);
    });
  });
}
