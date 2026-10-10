import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  const Task({
    required this.id,
    required this.title,
    this.note = '',
    this.done = false,
    this.dueDate,
    this.attachmentUrl,
    this.attachmentPath,
    this.createdAt,
  });

  final String id;
  final String title;
  final String note;
  final bool done;
  final DateTime? dueDate;
  final String? attachmentUrl; // download URL for display
  final String? attachmentPath; // Storage path (needed for deletion)
  final DateTime? createdAt;

  factory Task.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return Task(
      id: doc.id,
      title: (d['title'] ?? '') as String,
      note: (d['note'] ?? '') as String,
      done: (d['done'] ?? false) as bool,
      dueDate: (d['dueDate'] as Timestamp?)?.toDate(),
      attachmentUrl: d['attachmentUrl'] as String?,
      attachmentPath: d['attachmentPath'] as String?,
      // May be null for a moment until the server writes the timestamp
      createdAt: (d['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
