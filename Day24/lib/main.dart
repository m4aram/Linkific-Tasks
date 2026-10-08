
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoplite/app.dart';
import 'package:shoplite/core/constants/app_strings.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _installErrorHandlers();

  // Nothing slow runs before the first frame: the database, the session
  // check and the network are all started lazily by the widgets that
  // need them.
  runApp(const ProviderScope(child: ShopLiteApp()));
}

/// Last line of defence: errors nobody caught are logged in debug builds
/// and never crash the app or show a red screen in release builds.
void _installErrorHandlers() {
  FlutterError.onError = (details) {
    if (kDebugMode) FlutterError.presentError(details);
  };

  PlatformDispatcher.instance.onError = (error, stackTrace) {
    if (kDebugMode) debugPrint('Uncaught error: $error\n$stackTrace');
    return true;
  };

  if (kReleaseMode) {
    ErrorWidget.builder = (details) {
      return const ColoredBox(
        color: Color(0xFFFFFFFF),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              AppStrings.errorUnexpected,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              style: TextStyle(color: Color(0xFF444444), fontSize: 14),
            ),
          ),
        ),
      );
    };
  }
}
