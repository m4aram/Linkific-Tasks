import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../models/note.dart';
import '../models/category.dart';
import 'note_dao.dart';

part 'app_database.g.dart';

final migration1to2 = Migration(1, 2, (database) async {
  await database.execute(
    ''' CREATE TABLE IF NOT EXISTS categories ( id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL ) ''',
  );
  await database.execute('''
  INSERT INTO categories (name)
  VALUES ('General')
''');

  await database.execute('''
  ALTER TABLE notes
  ADD COLUMN categoryId INTEGER
''');
});

@Database(version: 2, entities: [Note, Category])
abstract class AppDatabase extends FloorDatabase {
  NoteDao get noteDao;
}
