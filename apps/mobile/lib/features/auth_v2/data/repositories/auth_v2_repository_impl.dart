import 'dart:convert';
import 'package:app_core/app_core.dart';
import 'package:app_storage/app_storage.dart';
import 'package:mobile/features/auth/auth.dart';

/// Alternative (V2) implementation of [AuthRepository] proving LEGO module pluggability.
/// Can be switched via DI configuration without modifying any domain or UI caller code.
class AuthV2RepositoryImpl implements AuthRepository {
  const AuthV2RepositoryImpl({
    required SecureStorage secureStorage,
  }) : _secureStorage = secureStorage;

  final SecureStorage _secureStorage;

  static const String _tokenKey = 'auth_v2_token';
  static const String _userKey = 'auth_v2_user';

  @override
  Future<Result<AuthSession>> login({
    required String email,
    required String password,
  }) async {
    // V2 implementation logic (e.g. simulated OAuth2 / PKCE / enhanced security token)
    final user = User(
      id: 'usr_v2_99',
      email: email,
      name: 'V2 ${email.split('@').first}',
      role: 'pro_architect',
    );

    final session = AuthSession(
      user: user,
      token: 'jwt_v2_secure_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'refresh_v2_token_xyz',
    );

    await _secureStorage.write(_tokenKey, session.token);
    await _secureStorage.write(
      _userKey,
      jsonEncode({
        'id': user.id,
        'email': user.email,
        'name': user.name,
        'role': user.role,
      }),
    );

    return Result.success(session);
  }

  @override
  Future<Result<void>> logout() async {
    await _secureStorage.delete(_tokenKey);
    await _secureStorage.delete(_userKey);
    return const Result.success(null);
  }

  @override
  Future<Result<User?>> getCurrentUser() async {
    try {
      final userJson = await _secureStorage.read(_userKey);
      if (userJson != null && userJson.isNotEmpty) {
        final decoded = jsonDecode(userJson) as Map<String, dynamic>;
        return Result.success(
          User(
            id: decoded['id'] as String? ?? 'usr_v2',
            email: decoded['email'] as String? ?? '',
            name: decoded['name'] as String? ?? '',
            role: decoded['role'] as String? ?? 'user',
          ),
        );
      }
      return const Result.success(null);
    } catch (e, st) {
      return Result.failure(
        CacheFailure(
          message: 'Failed to read cached V2 session',
          cause: e,
          stackTrace: st,
        ),
      );
    }
  }
}
