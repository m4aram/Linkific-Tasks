import 'package:floor/floor.dart';
import 'category.dart';

@Entity(
  tableName: 'notes',
  foreignKeys: [
    ForeignKey(
      entity: Category,
      parentColumns: ['id'],
      childColumns: ['categoryId'],
    ),
  ],
)
class Note {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  @ColumnInfo(name: 'title')
  final String title;

  @ColumnInfo(name: 'content')
  final String content;

  @ColumnInfo(name: 'categoryId')
  final int? categoryId;

  Note({
    this.id,
    required this.title,
    required this.content,
    this.categoryId,
  });
}