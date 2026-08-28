import 'package:app_core/app_core.dart';
import 'package:mobile/features/auth/domain/entities/auth_session.dart';
import 'package:mobile/features/auth/domain/entities/user.dart';

/// Contract for Authentication operations.
abstract class AuthRepository {
  const AuthRepository();

  Future<Result<AuthSession>> login({
    required String email,
    required String password,
  });

  Future<Result<void>> logout();

  Future<Result<User?>> getCurrentUser();
}
