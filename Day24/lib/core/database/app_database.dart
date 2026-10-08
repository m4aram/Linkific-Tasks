import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:shoplite/core/constants/app_constants.dart';
import 'package:sqflite/sqflite.dart';

/// Table and column names, so SQL identifiers are never typed by hand
/// (and never come from user input).
abstract final class FavoritesTable {
  static const String name = 'favorites';
  static const String id = 'id';
  static const String title = 'title';
  static const String description = 'description';
  static const String category = 'category';
  static const String brand = 'brand';
  static const String price = 'price';
  static const String discount = 'discount_percentage';
  static const String rating = 'rating';
  static const String stock = 'stock';
  static const String thumbnail = 'thumbnail';
  static const String addedAt = 'added_at';
}

/// Owns the SQLite connection. The database is opened lazily, the first
/// time something actually needs it, and only once.
class AppDatabase {
  Future<Database>? _opening;

  Future<Database> get database => _opening ??= _open();

  Future<Database> _open() async {
    final directory = await getDatabasesPath();
    return openDatabase(
      p.join(directory, AppConstants.databaseName),
      version: AppConstants.databaseVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE ${FavoritesTable.name} (
            ${FavoritesTable.id} INTEGER PRIMARY KEY,
            ${FavoritesTable.title} TEXT NOT NULL,
            ${FavoritesTable.description} TEXT NOT NULL,
            ${FavoritesTable.category} TEXT NOT NULL,
            ${FavoritesTable.brand} TEXT,
            ${FavoritesTable.price} REAL NOT NULL,
            ${FavoritesTable.discount} REAL NOT NULL,
            ${FavoritesTable.rating} REAL NOT NULL,
            ${FavoritesTable.stock} INTEGER NOT NULL,
            ${FavoritesTable.thumbnail} TEXT NOT NULL,
            ${FavoritesTable.addedAt} INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> close() async {
    final opening = _opening;
    _opening = null;
    if (opening == null) return;
    final db = await opening;
    await db.close();
  }
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});
