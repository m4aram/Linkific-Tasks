import 'package:floor/floor.dart';
import '../models/note.dart';

@dao
abstract class NoteDao {
  @Query('SELECT * FROM notes ORDER BY id DESC')
  Future<List<Note>> getAllNotes();

  @Query('SELECT * FROM notes WHERE id = :id LIMIT 1')
  Future<Note?> getNoteById(int id);

  @Query('SELECT * FROM notes ORDER BY id DESC')
  Stream<List<Note>> watchNotes();

  @Query(
    'SELECT * FROM notes '
        'WHERE title LIKE :query OR content LIKE :query '
        'ORDER BY id DESC',
  )
  Future<List<Note>> searchNotes(String query);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertNote(Note note);

  @Update()
  Future<void> updateNote(Note note);

  @delete
  Future<void> deleteNote(Note note);
}