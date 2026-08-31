import 'dart:convert';
import 'package:app_core/app_core.dart';
import 'package:app_storage/app_storage.dart';
import 'package:auth_contract/auth_contract.dart';
import '../auth_storage_keys.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_dto.dart';

/// Concrete implementation of [AuthRepository] managing tokens and remote requests.
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required SecureStorage secureStorage,
  })  : _remoteDataSource = remoteDataSource,
        _secureStorage = secureStorage;

  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorage _secureStorage;

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
          final token = data['token'];
          final refreshToken = data['refresh_token'];
          final userMap = data['user'];
          if (token is! String ||
              token.isEmpty ||
              userMap is! Map<String, dynamic>) {
            return const Result.failure(
              DataContractFailure(
                message: 'Authentication response is missing token or user',
              ),
            );
          }

          final userDto = UserDto.fromJson(userMap);
          if (userDto.id.isEmpty ||
              userDto.email.isEmpty ||
              userDto.name.isEmpty) {
            return const Result.failure(
              DataContractFailure(
                message: 'Authentication user payload is incomplete',
              ),
            );
          }
          final user = userDto.toDomain();

          await _secureStorage.write(AuthStorageKeys.accessToken, token);
          if (refreshToken is String && refreshToken.isNotEmpty) {
            await _secureStorage.write(
              AuthStorageKeys.refreshToken,
              refreshToken,
            );
          }
          await _secureStorage.write(
            AuthStorageKeys.userData,
            jsonEncode(userDto.toJson()),
          );

          return Result.success(
            AuthSession(
              user: user,
              token: token,
              refreshToken: refreshToken is String ? refreshToken : null,
            ),
          );
        } catch (e, st) {
          return Result.failure(
            CacheFailure(
              message: 'Failed to persist authentication session',
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
    // Remote logout is best-effort; local credential removal is authoritative.
    await _remoteDataSource.logout();
    try {
      await _secureStorage.delete(AuthStorageKeys.accessToken);
      await _secureStorage.delete(AuthStorageKeys.refreshToken);
      await _secureStorage.delete(AuthStorageKeys.userData);
      return const Result.success(null);
    } catch (e, st) {
      return Result.failure(
        CacheFailure(
          message: 'Failed to clear authentication session',
          cause: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Result<User?>> getCurrentUser() async {
    try {
      final token = await _secureStorage.read(AuthStorageKeys.accessToken);
      final userJson = await _secureStorage.read(AuthStorageKeys.userData);
      if (token != null &&
          token.isNotEmpty &&
          userJson != null &&
          userJson.isNotEmpty) {
        final decoded = jsonDecode(userJson) as Map<String, dynamic>;
        final user = UserDto.fromJson(decoded).toDomain();
        return Result.success(user);
      }
      await _secureStorage.delete(AuthStorageKeys.accessToken);
      await _secureStorage.delete(AuthStorageKeys.refreshToken);
      await _secureStorage.delete(AuthStorageKeys.userData);
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
