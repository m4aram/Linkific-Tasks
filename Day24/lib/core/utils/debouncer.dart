import 'dart:async';

/// Delays [run] until the caller has been quiet for [delay]. Used so the
/// search box does not fire a request on every keystroke.
class Debouncer {
  Debouncer({required this.delay});

  final Duration delay;
  Timer? _timer;

  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  /// Must be called from the owner's `dispose()`.
  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
