import '../../domain/entities/user_profile.dart';

/// Data Transfer Object for Profile API serialization and domain mapping.
class UserProfileDto {
  const UserProfileDto({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    this.role,
    this.bio,
  });

  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final String? role;
  final String? bio;

  factory UserProfileDto.fromJson(Map<String, dynamic> json) {
    return UserProfileDto(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String?,
      role: json['role'] as String?,
      bio: json['bio'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar_url': avatarUrl,
      'role': role,
      'bio': bio,
    };
  }

  UserProfile toDomain() {
    return UserProfile(
      id: id,
      email: email,
      name: name,
      avatarUrl: avatarUrl,
      role: role ?? 'Member',
      bio: bio,
    );
  }
}
