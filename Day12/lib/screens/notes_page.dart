import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/note.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final DatabaseHelper db = DatabaseHelper.instance;

  final TextEditingController searchController = TextEditingController();

  List<Note> notes = [];

  int currentPage = 0;
  final int pageSize = 3;

  bool hasMore = true;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    final result = await db.getNotesPaginated(
      pageSize,
      0,
    );

    if (!mounted) return;

    setState(() {
      notes = result;
      currentPage = 0;
      hasMore = result.length == pageSize;
    });
  }

  Future<void> loadMore() async {
    if (!hasMore || isLoadingMore) return;

    setState(() {
      isLoadingMore = true;
    });

    final nextPage = currentPage + 1;

    final result = await db.getNotesPaginated(
      pageSize,
      nextPage * pageSize,
    );

    if (!mounted) return;

    setState(() {
      notes.addAll(result);
      currentPage = nextPage;
      hasMore = result.length == pageSize;
      isLoadingMore = false;
    });
  }

  Future<void> searchNotes() async {
    final query = searchController.text.trim();

    if (query.isEmpty) {
      await loadNotes();
      return;
    }

    final result = await db.searchNotes(query);

    if (!mounted) return;

    setState(() {
      notes = result;
    });
  }

  Future<void> addNote() async {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await db.insertNote(
        Note(
          title: titleController.text,
          content: contentController.text,
          categoryId: 1,
        ),
      );

      await loadNotes();
    }
  }

  Future<void> editNote(Note note) async {
    final titleController = TextEditingController(text: note.title);

    final contentController =
    TextEditingController(text: note.content);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Update'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await db.updateNote(
        Note(
          id: note.id,
          title: titleController.text,
          content: contentController.text,
          categoryId: note.categoryId,
        ),
      );

      await loadNotes();
    }
  }

  Future<void> deleteNote(Note note) async {
    await db.deleteNote(note.id!);
    await loadNotes();
  }

  Future<void> showJoinedData() async {
    final result = await db.getNotesWithCategories();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('JOIN Results'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: result.length,
              itemBuilder: (context, index) {
                final item = result[index];

                return ListTile(
                  title: Text(
                    item['title']?.toString() ?? '',
                  ),
                  subtitle: Text(
                    'Category: ${item['category_name'] ?? 'None'}',
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQLite Notes'),
        actions: [
          IconButton(
            onPressed: showJoinedData,
            icon: const Icon(Icons.link),
            tooltip: 'Test JOIN',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              onChanged: (_) => searchNotes(),
              decoration: InputDecoration(
                hintText: 'Search notes...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: () {
                    searchController.clear();
                    loadNotes();
                  },
                  icon: const Icon(Icons.clear),
                ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),

          Expanded(
            child: notes.isEmpty
                ? const Center(
              child: Text('No notes found'),
            )
                : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];

                return Card(
                  child: ListTile(
                    title: Text(note.title),
                    subtitle: Text(note.content),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => editNote(note),
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () => deleteNote(note),
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: hasMore ? loadMore : null,
                    icon: const Icon(Icons.more_horiz),
                    label: Text(
                      isLoadingMore
                          ? 'Loading...'
                          : 'Load More',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNote,
        child: const Icon(Icons.add),
      ),
    );
  }
}