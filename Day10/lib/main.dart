import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const ImageHandlingApp());
}

class ImageHandlingApp extends StatelessWidget {
  const ImageHandlingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Image Handling',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
