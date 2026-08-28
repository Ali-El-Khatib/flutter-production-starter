import 'package:app_core/app_core.dart';
import '../entities/auth_session.dart';
import '../entities/user.dart';

/// Abstract domain contract defining authentication operations.
///
/// Implemented by interchangeable auth feature implementations
/// (e.g. `feature_auth`, `feature_auth_v2`).
abstract interface class AuthRepository {
  /// Authenticates a user with email and password.
  Future<Result<AuthSession>> login({
    required String email,
    required String password,
  });

  /// Logs out the currently authenticated user and revokes tokens.
  Future<Result<void>> logout();

  /// Retrieves the currently cached or persisted user session.
  Future<Result<User?>> getCurrentUser();
}
