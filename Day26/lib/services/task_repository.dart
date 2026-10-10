import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '../models/task.dart';
import 'storage_service.dart';

/// Data layer for tasks: acts as the API between the screens and Firestore.
/// Path: users/{uid}/tasks/{taskId}
class TaskRepository {
  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      FirebaseFirestore.instance.collection('users').doc(uid).collection('tasks');

  /// Real-time listener: every add/update/delete reaches the UI immediately.
  Stream<List<Task>> watchTasks(String uid) {
    return _col(uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(Task.fromDoc).toList());
  }

  Future<void> addTask(
    String uid, {
    required String title,
    String note = '',
    DateTime? dueDate,
    XFile? attachment,
  }) async {
    final doc = _col(uid).doc(); // create the id first so the file path can use it
    final file = attachment == null ? null : await _upload(uid, doc.id, attachment);
    await doc.set({
      'title': title.trim(),
      'note': note.trim(),
      'done': false,
      'dueDate': dueDate == null ? null : Timestamp.fromDate(dueDate),
      'attachmentUrl': file?.url,
      'attachmentPath': file?.path,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateTask(
    String uid,
    Task task, {
    required String title,
    String note = '',
    DateTime? dueDate,
    XFile? newAttachment,
  }) async {
    final data = <String, dynamic>{
      'title': title.trim(),
      'note': note.trim(),
      'dueDate': dueDate == null ? null : Timestamp.fromDate(dueDate),
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (newAttachment != null) {
      final file = await _upload(uid, task.id, newAttachment);
      data['attachmentUrl'] = file.url;
      data['attachmentPath'] = file.path;
    }
    await _col(uid).doc(task.id).update(data);
    // Delete the old attachment only after the update succeeded
    if (newAttachment != null &&
        task.attachmentPath != null &&
        task.attachmentPath != data['attachmentPath']) {
      await storageService.delete(task.attachmentPath!);
    }
  }

  Future<void> setDone(String uid, String taskId, bool done) {
    return _col(uid).doc(taskId).update({
      'done': done,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteTask(String uid, Task task) async {
    await _col(uid).doc(task.id).delete();
    if (task.attachmentPath != null) {
      await storageService.delete(task.attachmentPath!);
    }
  }

  Future<({String url, String path})> _upload(String uid, String taskId, XFile file) async {
    final path = 'users/$uid/tasks/$taskId/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final url = await storageService.upload(
      path: path,
      bytes: await file.readAsBytes(),
      contentType: file.mimeType ?? 'image/jpeg',
    );
    return (url: url, path: path);
  }
}

final TaskRepository taskRepository = TaskRepository();
