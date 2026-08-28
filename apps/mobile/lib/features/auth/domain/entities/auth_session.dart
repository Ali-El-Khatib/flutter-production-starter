import 'package:meta/meta.dart';
import 'package:mobile/features/auth/domain/entities/user.dart';

/// Represents an active authenticated session.
@immutable
class AuthSession {
  const AuthSession({
    required this.user,
    required this.token,
    this.refreshToken,
  });

  final User user;
  final String token;
  final String? refreshToken;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthSession &&
          runtimeType == other.runtimeType &&
          user == other.user &&
          token == other.token;

  @override
  int get hashCode => Object.hash(user, token);
}
