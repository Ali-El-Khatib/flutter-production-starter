import 'package:app_core/app_core.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';

/// Explicit development-only profile repository.
class DemoProfileRepository implements ProfileRepository {
  const DemoProfileRepository();

  @override
  Future<Result<UserProfile>> getProfile() async {
    return const Result.success(
      UserProfile(
        id: 'demo_user',
        email: 'developer@example.com',
        name: 'Flutter Developer',
        role: 'Developer',
        bio: 'Development-only sample data.',
      ),
    );
  }

  @override
  Future<Result<UserProfile>> updateProfile({
    required String name,
    String? bio,
  }) async {
    return Result.success(
      UserProfile(
        id: 'demo_user',
        email: 'developer@example.com',
        name: name,
        role: 'Developer',
        bio: bio,
      ),
    );
  }
}
