import 'package:app_core/app_core.dart';
import 'package:mobile/features/auth/domain/entities/user.dart';

/// Presentation state for Authentication.
class AuthState {
  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.user,
    this.failure,
  });

  final bool isAuthenticated;
  final bool isLoading;
  final User? user;
  final Failure? failure;

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    User? user,
    Failure? failure,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      failure: failure,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthState &&
          runtimeType == other.runtimeType &&
          isAuthenticated == other.isAuthenticated &&
          isLoading == other.isLoading &&
          user == other.user &&
          failure == other.failure;

  @override
  int get hashCode => Object.hash(isAuthenticated, isLoading, user, failure);
}
