import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/note.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();

    final path = join(
      databasesPath,
      'notes.db',
    );

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(
      Database db,
      int version,
      ) async {
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        category_id INTEGER,
        FOREIGN KEY (category_id)
          REFERENCES categories(id)
      )
    ''');

    // Sample categories
    await db.insert('categories', {'name': 'General'});
    await db.insert('categories', {'name': 'Flutter'});
  }

  // CREATE
  Future<int> insertNote(Note note) async {
    final db = await database;

    return await db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // READ ALL
  Future<List<Note>> getAllNotes() async {
    final db = await database;

    final maps = await db.query(
      'notes',
      orderBy: 'id DESC',
    );

    return maps.map((map) => Note.fromMap(map)).toList();
  }

  // READ SINGLE
  Future<Note?> getNoteById(int id) async {
    final db = await database;

    final maps = await db.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) {
      return null;
    }

    return Note.fromMap(maps.first);
  }

  // UPDATE
  Future<int> updateNote(Note note) async {
    final db = await database;

    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // DELETE
  Future<int> deleteNote(int id) async {
    final db = await database;

    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // SEARCH - WHERE
  Future<List<Note>> searchNotes(String query) async {
    final db = await database;

    final maps = await db.query(
      'notes',
      where: 'title LIKE ? OR content LIKE ?',
      whereArgs: [
        '%$query%',
        '%$query%',
      ],
      orderBy: 'id DESC',
    );

    return maps.map((map) => Note.fromMap(map)).toList();
  }

  // LIMIT + OFFSET
  Future<List<Note>> getNotesPaginated(
      int limit,
      int offset,
      ) async {
    final db = await database;

    final maps = await db.query(
      'notes',
      orderBy: 'id DESC',
      limit: limit,
      offset: offset,
    );

    return maps.map((map) => Note.fromMap(map)).toList();
  }

  // JOIN
  Future<List<Map<String, dynamic>>> getNotesWithCategories() async {
    final db = await database;

    return await db.rawQuery('''
      SELECT
        notes.id,
        notes.title,
        notes.content,
        categories.name AS category_name
      FROM notes
      LEFT JOIN categories
        ON notes.category_id = categories.id
      ORDER BY notes.id DESC
    ''');
  }

  // GET CATEGORIES
  Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await database;

    return await db.query(
      'categories',
      orderBy: 'id ASC',
    );
  }
}