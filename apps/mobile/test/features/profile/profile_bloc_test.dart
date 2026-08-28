import 'package:app_core/app_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/profile/profile.dart';

class MockProfileRepository implements ProfileRepository {
  @override
  Future<Result<UserProfile>> getProfile() async {
    return const Result.success(
      UserProfile(
        id: 'usr_1',
        email: 'test@example.com',
        name: 'Test Profile',
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
        id: 'usr_1',
        email: 'test@example.com',
        name: name,
        bio: bio,
      ),
    );
  }
}

void main() {
  group('ProfileBloc', () {
    late ProfileBloc profileBloc;

    setUp(() {
      profileBloc = ProfileBloc(MockProfileRepository());
    });

    test('initial state has no profile', () {
      expect(profileBloc.state.value.profile, isNull);
      expect(profileBloc.state.value.isLoading, isFalse);
    });

    test('loadProfile fetches profile successfully', () async {
      profileBloc.loadProfile();

      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(profileBloc.state.value.profile?.name, equals('Test Profile'));
      expect(profileBloc.state.value.isLoading, isFalse);
    });

    test('updateProfile updates profile name and bio', () async {
      profileBloc.updateProfile(name: 'Updated Name', bio: 'New Bio');

      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(profileBloc.state.value.profile?.name, equals('Updated Name'));
      expect(profileBloc.state.value.profile?.bio, equals('New Bio'));
    });
  });
}
