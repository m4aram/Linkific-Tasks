import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoplite/core/database/app_database.dart';
import 'package:shoplite/features/products/data/product_model.dart';
import 'package:sqflite/sqflite.dart';

/// Local favourites in SQLite.
///
/// SQL injection prevention: every value goes through `?` placeholders
/// (`whereArgs`) or sqflite's map helpers, which bind parameters. No
/// query is ever built by concatenating strings with user data.
class FavoritesRepository {
  FavoritesRepository(this._database);

  final AppDatabase _database;

  Future<List<Product>> getAll() async {
    final db = await _database.database;
    final rows = await db.query(
      FavoritesTable.name,
      orderBy: '${FavoritesTable.addedAt} DESC',
    );
    return rows.map(Product.fromDb).toList(growable: false);
  }

  Future<void> add(Product product) async {
    final db = await _database.database;
    await db.insert(
      FavoritesTable.name,
      product.toDb(addedAt: DateTime.now().millisecondsSinceEpoch),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> remove(int productId) async {
    final db = await _database.database;
    await db.delete(
      FavoritesTable.name,
      where: '${FavoritesTable.id} = ?',
      whereArgs: [productId],
    );
  }
}

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepository(ref.watch(appDatabaseProvider));
});
