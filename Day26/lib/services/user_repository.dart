import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_user.dart';

/// The users collection in Firestore.
class UserRepository {
  final CollectionReference<Map<String, dynamic>> _users =
      FirebaseFirestore.instance.collection('users');

  Future<void> createUser({
    required String uid,
    required String name,
    required String email,
  }) {
    return _users.doc(uid).set({
      'name': name,
      'email': email,
      'photoUrl': null,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Real-time listener for the user profile.
  Stream<AppUser?> watchUser(String uid) {
    return _users.doc(uid).snapshots().map((d) => d.exists ? AppUser.fromDoc(d) : null);
  }

  Future<void> updatePhoto(String uid, String url) {
    return _users.doc(uid).set({'photoUrl': url}, SetOptions(merge: true));
  }
}

final UserRepository userRepository = UserRepository();
