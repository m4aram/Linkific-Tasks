import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'crash_reporter.dart';

/// Global error handling. Call once in main(), before runApp.
/// There are THREE places where an error can appear, and each has its own hook.
/// Every error goes to the local crash log (shown in the app) and, when [useCrashlytics] is true,
/// also to Firebase Crashlytics.
void setupErrorHandling({bool useCrashlytics = false}) {
  // 1) Errors inside the Flutter framework: build, layout, paint, and gesture callbacks (onPressed).
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details); // keep printing it in the console
    crashReporter.recordFlutterError(details);
    // Reported as non-fatal: the app keeps running (for example a RenderFlex overflow).
    if (useCrashlytics) FirebaseCrashlytics.instance.recordFlutterError(details);
  };

  // 2) Errors Flutter cannot see: async code without a catch, plugins, other isolates.
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    crashReporter.recordError(error, stack, source: 'PlatformDispatcher.onError', fatal: true);
    if (useCrashlytics) FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true; // true = handled, do not crash the app
  };

  // 3) What the user SEES when a widget's build() throws (instead of the red/grey error screen).
  ErrorWidget.builder = (FlutterErrorDetails details) => FriendlyErrorWidget(details: details);
}

class FriendlyErrorWidget extends StatelessWidget {
  const FriendlyErrorWidget({super.key, required this.details});

  final FlutterErrorDetails details;

  @override
  Widget build(BuildContext context) {
    // In debug we show the real message (you are the developer). In release the user sees a calm message.
    final text = kDebugMode ? details.exceptionAsString() : 'Something went wrong on this part of the screen.';
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3E0),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFFFB74D)),
        ),
        child: Row(
          children: [
            const Icon(Icons.bug_report, color: Color(0xFFE65100)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Color(0xFF3E2723), fontSize: 13, decoration: TextDecoration.none),
              ),
            ),
          ],
        ),
      ),
    );
  }
}