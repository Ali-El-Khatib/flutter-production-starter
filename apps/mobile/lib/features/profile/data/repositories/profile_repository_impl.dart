import 'package:app_core/app_core.dart';
import 'package:app_network/app_network.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/features/profile/data/models/user_profile_dto.dart';
import 'package:mobile/features/profile/domain/entities/user_profile.dart';
import 'package:mobile/features/profile/domain/repositories/profile_repository.dart';

/// Implementation of [ProfileRepository] consuming [ApiClient].
@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<Result<UserProfile>> getProfile() async {
    // In starter repo, we simulate API response or call /api/v1/profile
    final result = await _apiClient.get<Map<String, dynamic>>(
      '/api/v1/profile',
      responseParser: (data) =>
          data is Map<String, dynamic> ? data : <String, dynamic>{},
    );

    return result.when(
      success: (data) {
        if (data.isEmpty) {
          // Default profile preview
          return const Result.success(
            UserProfile(
              id: 'usr_1',
              email: 'developer@example.com',
              name: 'Senior Flutter Engineer',
              role: 'Lead Architect',
              bio:
                  'Building production-grade modular architectures with Flutter and Dart.',
            ),
          );
        }
        final dto = UserProfileDto.fromJson(data);
        return Result.success(dto.toDomain());
      },
      failure: (failure) {
        // Return default preview if server is unreachable demo endpoint
        if (failure is ConnectivityFailure ||
            failure is NotFoundFailure ||
            failure is ServerFailure) {
          return const Result.success(
            UserProfile(
              id: 'usr_1',
              email: 'developer@example.com',
              name: 'Senior Flutter Engineer',
              role: 'Lead Architect',
              bio:
                  'Building production-grade modular architectures with Flutter and Dart.',
            ),
          );
        }
        return Result.failure(failure);
      },
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
        return Result.success(dto.toDomain());
      },
      failure: (failure) {
        // Optimistic local update fallback for starter preview
        return Result.success(
          UserProfile(
            id: 'usr_1',
            email: 'developer@example.com',
            name: name,
            role: 'Lead Architect',
            bio: bio,
          ),
        );
      },
    );
  }
}
