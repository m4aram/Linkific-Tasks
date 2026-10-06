import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import 'debug/frame_monitor.dart';
import 'error/error_handling.dart';
import 'firebase_options.dart'; // created by: flutterfire configure
import 'screens/home_screen.dart';

/// MaterialApp.showPerformanceOverlay draws two graphs on top of the app:
/// the top one is the raster thread, the bottom one is the UI thread. A red bar = a slow frame.
final ValueNotifier<bool> showPerformanceOverlay = ValueNotifier<bool>(false);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // For this exercise reports are sent in debug mode too, so the test can be seen in the console.
  // In a real app use: setCrashlyticsCollectionEnabled(!kDebugMode)
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  setupErrorHandling(useCrashlytics: true);
  FrameMonitor.instance.start();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: showPerformanceOverlay,
      builder: (context, overlay, _) => MaterialApp(
        title: 'Debug Lab',
        debugShowCheckedModeBanner: false,
        showPerformanceOverlay: overlay,
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.orange),
        home: const HomeScreen(),
      ),
    );
  }
}