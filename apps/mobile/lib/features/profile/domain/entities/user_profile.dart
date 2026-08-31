import 'package:flutter/foundation.dart';

/// Domain entity representing a user's profile.
@immutable
class UserProfile {
  const UserProfile({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    this.role = 'Member',
    this.bio,
  });

  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final String role;
  final String? bio;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          name == other.name;

  @override
  int get hashCode => Object.hash(id, email, name);
}
