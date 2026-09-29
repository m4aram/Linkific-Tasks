import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> notes = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final data = await supabase
        .from('notes')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    if (!mounted) return;

    setState(() {
      notes = List<Map<String, dynamic>>.from(data);
      loading = false;
    });
  }

  Future<void> saveNote({
    int? id,
    required String title,
    required String content,
  }) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    if (id == null) {
      await supabase.from('notes').insert({
        'user_id': user.id,
        'title': title,
        'content': content,
      });
    } else {
      await supabase
          .from('notes')
          .update({'title': title, 'content': content})
          .eq('id', id);
    }

    await loadNotes();
  }

  Future<void> deleteNote(int id) async {
    await supabase.from('notes').delete().eq('id', id);
    await loadNotes();
  }

  void openNoteDialog({Map<String, dynamic>? note}) {
    final titleController = TextEditingController(text: note?['title'] ?? '');
    final contentController = TextEditingController(
      text: note?['content'] ?? '',
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(note == null ? 'إضافة ملاحظة' : 'تعديل الملاحظة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'العنوان'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: contentController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'المحتوى'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              await saveNote(
                id: note?['id'],
                title: titleController.text.trim(),
                content: contentController.text.trim(),
              );

              if (mounted) Navigator.pop(context);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الملاحظات')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openNoteDialog(),
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : notes.isEmpty
          ? const Center(child: Text('لا توجد ملاحظات'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notes.length,
              itemBuilder: (_, index) {
                final note = notes[index];
                return Card(
                  child: ListTile(
                    title: Text(note['title'] ?? ''),
                    subtitle: Text(note['content'] ?? ''),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            openNoteDialog(note: note);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            deleteNote(note['id']);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
