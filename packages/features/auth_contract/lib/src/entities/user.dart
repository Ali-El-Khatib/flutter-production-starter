import 'package:flutter/foundation.dart';

/// Domain representation of an authenticated user.
@immutable
class User {
  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });

  final String id;
  final String email;
  final String name;
  final String role;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          name == other.name &&
          role == other.role;

  @override
  int get hashCode =>
      id.hashCode ^ email.hashCode ^ name.hashCode ^ role.hashCode;

  @override
  String toString() => 'User(id: $id, email: $email, name: $name, role: $role)';
}
