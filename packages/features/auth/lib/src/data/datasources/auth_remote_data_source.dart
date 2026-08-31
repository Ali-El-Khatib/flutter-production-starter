import 'package:app_core/app_core.dart';
import 'package:app_network/app_network.dart';

/// Contract for Remote Authentication API operations.
abstract class AuthRemoteDataSource {
  const AuthRemoteDataSource();

  Future<Result<Map<String, dynamic>>> login({
    required String email,
    required String password,
  });

  Future<Result<void>> logout();

  Future<Result<Map<String, dynamic>>> getCurrentUser();
}

/// Implementation of [AuthRemoteDataSource] consuming [ApiClient].
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<Result<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    return _apiClient.post<Map<String, dynamic>>(
      '/api/v1/auth/login',
      data: {'email': email, 'password': password},
      responseParser: (data) =>
          data is Map<String, dynamic> ? data : <String, dynamic>{},
    );
  }

  @override
  Future<Result<void>> logout() async {
    return _apiClient.post<void>('/api/v1/auth/logout');
  }

  @override
  Future<Result<Map<String, dynamic>>> getCurrentUser() async {
    return _apiClient.get<Map<String, dynamic>>(
      '/api/v1/auth/me',
      responseParser: (data) =>
          data is Map<String, dynamic> ? data : <String, dynamic>{},
    );
  }
}
