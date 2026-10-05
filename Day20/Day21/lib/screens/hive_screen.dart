import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../main.dart';

class HiveScreen extends StatefulWidget {
  const HiveScreen({super.key});

  @override
  State<HiveScreen> createState() => _HiveScreenState();
}

class _HiveScreenState extends State<HiveScreen> {
  final TextEditingController input = TextEditingController();
  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() => notes = hiveService.readAll());
  }

  Future<void> _create() async {
    final title = input.text.trim();
    if (title.isEmpty) return;
    await hiveService.create(title);
    input.clear();
    _refresh();
  }

  Future<void> _editNote(Map<String, dynamic> note) async {
    final controller = TextEditingController(text: '${note['title'] ?? ''}');

    final newTitle = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit note'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Note title',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final value = controller.text.trim();
                if (value.isNotEmpty) Navigator.pop(dialogContext, value);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (newTitle == null || newTitle.isEmpty) return;
    await hiveService.update(note['key'], newTitle);
    _refresh();
  }

  Future<void> _deleteNote(dynamic key) async {
    await hiveService.delete(key);
    _refresh();
  }

  Future<void> _clear() async {
    await hiveService.clear();
    _refresh();
  }

  @override
  void dispose() {
    input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive CRUD'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: input,
              decoration: const InputDecoration(
                labelText: 'Note title',
                hintText: 'Write a note...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _create,
                    child: const Text('Create'),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: _clear,
                  child: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: notes.isEmpty
                  ? const Center(child: Text('No notes yet. Create one using Hive.'))
                  : ListView.separated(
                      itemCount: notes.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final note = notes[index];
                        return ListTile(
                          title: Text('${note['title'] ?? ''}'),
                          subtitle: Text('key: ${note['key']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Edit',
                                onPressed: () => _editNote(note),
                                icon: const Icon(Icons.edit_outlined),
                              ),
                              IconButton(
                                tooltip: 'Delete',
                                onPressed: () => _deleteNote(note['key']),
                                icon: const Icon(Icons.delete_outline),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
