import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  const AppUser({required this.uid, required this.name, required this.email, this.photoUrl});

  final String uid;
  final String name;
  final String email;
  final String? photoUrl;

  factory AppUser.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return AppUser(
      uid: doc.id,
      name: (d['name'] ?? '') as String,
      email: (d['email'] ?? '') as String,
      photoUrl: d['photoUrl'] as String?,
    );
  }
}
