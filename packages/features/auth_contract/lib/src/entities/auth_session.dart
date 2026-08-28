import 'package:flutter/foundation.dart';
import 'user.dart';

/// Domain model representing an active authenticated session.
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
          token == other.token &&
          refreshToken == other.refreshToken;

  @override
  int get hashCode => user.hashCode ^ token.hashCode ^ refreshToken.hashCode;

  @override
  String toString() =>
      'AuthSession(user: $user, token: [PROTECTED], refreshToken: ${refreshToken != null ? "[PROTECTED]" : "null"})';
}
