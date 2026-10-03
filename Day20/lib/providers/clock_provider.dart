import 'package:flutter_riverpod/flutter_riverpod.dart';

/// StreamProvider = exposes a Stream as AsyncValue (loading / data / error).
/// It subscribes automatically and cancels the stream when nobody listens.
final clockProvider = StreamProvider<DateTime>((ref) async* {
  yield DateTime.now();
  yield* Stream<DateTime>.periodic(const Duration(seconds: 1), (_) => DateTime.now());
});
