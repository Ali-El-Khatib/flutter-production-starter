import 'package:app_core/app_core.dart';
import 'package:app_storage/app_storage.dart';
import 'package:auth_contract/auth_contract.dart';
import 'package:feature_auth/feature_auth.dart';
import 'package:feature_auth_v2/feature_auth_v2.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

class _MockRemoteDataSource implements AuthRemoteDataSource {
  @override
  Future<Result<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    return Result.success({
      'token': 'v1_token_123',
      'user': {
        'id': 'usr_v1',
        'email': email,
        'name': 'V1 User',
        'role': 'member',
      },
    });
  }

  @override
  Future<Result<Map<String, dynamic>>> getCurrentUser() async {
    return const Result.success({
      'id': 'usr_v1',
      'email': 'test@example.com',
      'name': 'V1 User',
      'role': 'member',
    });
  }

  @override
  Future<Result<void>> logout() async => const Result.success(null);
}

/// Verifies that any [AuthRepository] implementation satisfies the core contract expectations.
Future<void> verifyAuthRepositoryContract({
  required AuthRepository repository,
  required String testEmail,
  required String testPassword,
}) async {
  final useCase = LoginUseCase(repository);
  final result = await useCase(email: testEmail, password: testPassword);

  expect(result.isSuccess, isTrue);
  final session = result.dataOrNull;
  expect(session, isNotNull);
  expect(session?.user.email, equals(testEmail));
  expect(session?.token.isNotEmpty, isTrue);

  final currentUserResult = await repository.getCurrentUser();
  expect(currentUserResult.isSuccess, isTrue);

  final logoutResult = await repository.logout();
  expect(logoutResult.isSuccess, isTrue);
}

void main() {
  group('LEGO Feature Replaceability & Substitutability', () {
    late GetIt testGetIt;
    late SecureStorage secureStorage;
    late AuthRemoteDataSource remoteDataSource;

    setUp(() {
      testGetIt = GetIt.asNewInstance();
      secureStorage = InMemorySecureStorage();
      remoteDataSource = _MockRemoteDataSource();
    });

    tearDown(() async {
      await testGetIt.reset();
    });

    test('Auth V1 implementation satisfies the AuthRepository contract',
        () async {
      final repository = AuthRepositoryImpl(
        remoteDataSource: remoteDataSource,
        secureStorage: secureStorage,
      );

      await verifyAuthRepositoryContract(
        repository: repository,
        testEmail: 'user@example.com',
        testPassword: 'password123',
      );
    });

    test('Auth V2 implementation satisfies the AuthRepository contract',
        () async {
      final repository = AuthV2RepositoryImpl(
        secureStorage: secureStorage,
      );

      await verifyAuthRepositoryContract(
        repository: repository,
        testEmail: 'architect@example.com',
        testPassword: 'password123',
      );
    });

    test(
        'Domain UseCases consume either implementation seamlessly without code changes',
        () async {
      final v1Repo = AuthRepositoryImpl(
        remoteDataSource: remoteDataSource,
        secureStorage: secureStorage,
      );
      final v2Repo = AuthV2RepositoryImpl(
        secureStorage: secureStorage,
      );

      final v1Result = await LoginUseCase(v1Repo)(
        email: 'v1@test.com',
        password: 'password123',
      );
      final v2Result = await LoginUseCase(v2Repo)(
        email: 'v2@test.com',
        password: 'password123',
      );

      expect(v1Result.isSuccess, isTrue);
      expect(v2Result.isSuccess, isTrue);
      expect(v1Result.dataOrNull?.token, equals('v1_token_123'));
      expect(v2Result.dataOrNull?.token.startsWith('jwt_v2_secure_token_'),
          isTrue);
    });

    test(
        'Guarantees exactly ONE AuthRepository implementation is active at startup',
        () {
      // 1. Register V1 in DI
      testGetIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
          remoteDataSource: remoteDataSource,
          secureStorage: secureStorage,
        ),
      );

      expect(testGetIt.isRegistered<AuthRepository>(), isTrue);
      expect(testGetIt<AuthRepository>(), isA<AuthRepositoryImpl>());

      // 2. Manual Developer Swap: unregister and switch to V2
      testGetIt.unregister<AuthRepository>();
      testGetIt.registerLazySingleton<AuthRepository>(
        () => AuthV2RepositoryImpl(
          secureStorage: secureStorage,
        ),
      );

      expect(testGetIt.isRegistered<AuthRepository>(), isTrue);
      expect(testGetIt<AuthRepository>(), isA<AuthV2RepositoryImpl>());
    });
  });
}
