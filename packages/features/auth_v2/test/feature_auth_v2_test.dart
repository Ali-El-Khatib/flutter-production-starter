import 'package:app_storage/app_storage.dart';
import 'package:auth_contract/auth_contract.dart';
import 'package:feature_auth_v2/feature_auth_v2.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FeatureAuthV2', () {
    late SecureStorage storage;
    late AuthRepository repository;

    setUp(() {
      storage = InMemorySecureStorage();
      repository = AuthV2RepositoryImpl(secureStorage: storage);
    });

    test('login persists token and user data', () async {
      final result = await repository.login(
        email: 'architect@antigravity.dev',
        password: 'Password123!',
      );

      expect(result.isSuccess, isTrue);
      final session = result.dataOrNull!;
      expect(session.user.role, equals('pro_architect'));
      expect(session.token.startsWith('jwt_v2_'), isTrue);

      final currentUser = await repository.getCurrentUser();
      expect(currentUser.isSuccess, isTrue);
      expect(
          currentUser.dataOrNull?.email, equals('architect@antigravity.dev'));
    });

    test('logout clears persisted token and session', () async {
      await repository.login(
        email: 'architect@antigravity.dev',
        password: 'Password123!',
      );

      final logoutResult = await repository.logout();
      expect(logoutResult.isSuccess, isTrue);

      final currentUser = await repository.getCurrentUser();
      expect(currentUser.isSuccess, isTrue);
      expect(currentUser.dataOrNull, isNull);
    });
  });
}
