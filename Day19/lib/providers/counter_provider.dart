import 'package:flutter/foundation.dart';

/// The smallest possible ChangeNotifier: one value + methods that change it.
class CounterProvider extends ChangeNotifier {
  int _value = 0;

  int get value => _value;

  void increment() {
    _value++;
    notifyListeners(); // tells every listening widget to rebuild
  }

  void decrement() {
    _value--;
    notifyListeners();
  }

  void reset() {
    _value = 0;
    notifyListeners();
  }
}
