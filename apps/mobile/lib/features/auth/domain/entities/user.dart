import 'package:meta/meta.dart';

/// Authenticated user domain entity.
@immutable
class User {
  const User({
    required this.id,
    required this.email,
    required this.name,
    this.role = 'user',
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
          email == other.email;

  @override
  int get hashCode => Object.hash(id, email);

  @override
  String toString() => 'User(id: $id, email: $email, name: $name)';
}
