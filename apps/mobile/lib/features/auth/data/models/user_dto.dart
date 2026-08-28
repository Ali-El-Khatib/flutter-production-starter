import 'package:mobile/features/auth/domain/entities/user.dart';

/// DTO for User API JSON serialization.
class UserDto {
  const UserDto({
    required this.id,
    required this.email,
    required this.name,
    this.role = 'user',
  });

  final String id;
  final String email;
  final String name;
  final String role;

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      role: json['role'] as String? ?? 'user',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
    };
  }

  User toDomain() {
    return User(
      id: id,
      email: email,
      name: name,
      role: role,
    );
  }
}
