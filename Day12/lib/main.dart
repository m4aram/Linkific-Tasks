import 'package:flutter/material.dart';

import 'screens/notes_page.dart';

void main() {
  runApp(const SQLiteApp());
}

class SQLiteApp extends StatelessWidget {
  const SQLiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SQLite Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const NotesPage(),
    );
  }
}
