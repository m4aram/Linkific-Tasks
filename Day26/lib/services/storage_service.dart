import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

/// Uploads and deletes files in Firebase Storage.
class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads the file to [path] and returns its download URL.
  Future<String> upload({
    required String path,
    required Uint8List bytes,
    String contentType = 'image/jpeg',
  }) async {
    final ref = _storage.ref(path);
    await ref.putData(bytes, SettableMetadata(contentType: contentType));
    return ref.getDownloadURL();
  }

  Future<void> delete(String path) async {
    try {
      await _storage.ref(path).delete();
    } on FirebaseException catch (e) {
      if (e.code != 'object-not-found') rethrow; // already gone = fine
    }
  }
}

final StorageService storageService = StorageService();
