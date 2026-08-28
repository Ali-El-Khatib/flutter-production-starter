import 'package:app_core/app_core.dart';
import 'package:mobile/features/profile/domain/entities/user_profile.dart';

/// Contract for Profile data operations.
abstract class ProfileRepository {
  const ProfileRepository();

  Future<Result<UserProfile>> getProfile();
  Future<Result<UserProfile>> updateProfile(
      {required String name, String? bio});
}
