import 'package:flutter_riverpod/legacy.dart';

/// StateProvider = the simplest state: one value that widgets can read and replace.
/// Since Riverpod 3 it lives in legacy.dart (the modern replacement is Notifier).
///
/// .autoDispose: when no widget listens anymore, the state is destroyed.
/// Leave the compare screen and come back: the counter starts from 0 again.
final counterProvider = StateProvider.autoDispose<int>((ref) => 0);
