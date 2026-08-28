import 'dart:convert';
import 'package:app_core/app_core.dart';
import 'package:app_storage/app_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mobile/features/auth/data/models/user_dto.dart';
import 'package:mobile/features/auth/domain/entities/auth_session.dart';
import 'package:mobile/features/auth/domain/entities/user.dart';
import 'package:mobile/features/auth/domain/repositories/auth_repository.dart';

/// Concrete implementation of [AuthRepository] managing tokens and remote requests.
@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required SecureStorage secureStorage,
  })  : _remoteDataSource = remoteDataSource,
        _secureStorage = secureStorage;

  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorage _secureStorage;

  static const String _tokenKey = 'auth_access_token';
  static const String _userKey = 'auth_user_data';

  @override
  Future<Result<AuthSession>> login({
    required String email,
    required String password,
  }) async {
    final result = await _remoteDataSource.login(
      email: email,
      password: password,
    );

    return result.when(
      success: (data) async {
        try {
          final token = data['token'] as String? ?? 'mock_token';
          final userMap = data['user'] as Map<String, dynamic>? ?? {};
          final userDto = UserDto.fromJson(userMap);
          final user = userDto.toDomain();

          // Persist token and user in secure storage
          await _secureStorage.write(_tokenKey, token);
          await _secureStorage.write(_userKey, jsonEncode(userDto.toJson()));

          return Result.success(AuthSession(user: user, token: token));
        } catch (e, st) {
          return Result.failure(
            UnknownFailure(
              message: 'Failed to process authentication payload',
              cause: e,
              stackTrace: st,
            ),
          );
        }
      },
      failure: (failure) => Result.failure(failure),
    );
  }

  @override
  Future<Result<void>> logout() async {
    await _remoteDataSource.logout();
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
        final user = UserDto.fromJson(decoded).toDomain();
        return Result.success(user);
      }
      return const Result.success(null);
    } catch (e, st) {
      return Result.failure(
        CacheFailure(
          message: 'Failed to read cached user session',
          cause: e,
          stackTrace: st,
        ),
      );
    }
  }
}
