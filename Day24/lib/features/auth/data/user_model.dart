import 'package:flutter/foundation.dart';

@immutable
class AppUser {
  const AppUser({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.image,
  });

  /// Parses defensively: a missing or wrongly-typed field becomes a safe
  /// default instead of crashing the app.
  factory AppUser.fromJson(Map<String, dynamic> json) {
    String text(String key) {
      final value = json[key];
      return value is String ? value : '';
    }

    final id = json['id'];
    final image = json['image'];
    return AppUser(
      id: id is num ? id.toInt() : 0,
      username: text('username'),
      email: text('email'),
      firstName: text('firstName'),
      lastName: text('lastName'),
      image: image is String && image.isNotEmpty ? image : null,
    );
  }

  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String? image;

  String get fullName {
    final name = '$firstName $lastName'.trim();
    return name.isEmpty ? username : name;
  }
}
