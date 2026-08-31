import 'package:app_core/app_core.dart';
import 'package:app_network/app_network.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/user_profile_dto.dart';

/// Implementation of [ProfileRepository] consuming [ApiClient].
class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<Result<UserProfile>> getProfile() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      '/api/v1/profile',
      responseParser: (data) =>
          data is Map<String, dynamic> ? data : <String, dynamic>{},
    );

    return result.when(
      success: (data) {
        final dto = UserProfileDto.fromJson(data);
        if (dto.id.isEmpty || dto.email.isEmpty || dto.name.isEmpty) {
          return const Result.failure(
            DataContractFailure(message: 'Profile payload is incomplete'),
          );
        }
        return Result.success(dto.toDomain());
      },
      failure: Result.failure,
    );
  }

  @override
  Future<Result<UserProfile>> updateProfile({
    required String name,
    String? bio,
  }) async {
    final result = await _apiClient.patch<Map<String, dynamic>>(
      '/api/v1/profile',
      data: {'name': name, 'bio': bio},
      responseParser: (data) =>
          data is Map<String, dynamic> ? data : <String, dynamic>{},
    );

    return result.when(
      success: (data) {
        final dto = UserProfileDto.fromJson(data);
        if (dto.id.isEmpty || dto.email.isEmpty || dto.name.isEmpty) {
          return const Result.failure(
            DataContractFailure(
                message: 'Updated profile payload is incomplete'),
          );
        }
        return Result.success(dto.toDomain());
      },
      failure: Result.failure,
    );
  }
}
