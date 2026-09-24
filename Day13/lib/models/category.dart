import 'package:floor/floor.dart';

@Entity(tableName: 'categories')
class Category {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String name;

  Category({
    this.id,
    required this.name,
  });
}