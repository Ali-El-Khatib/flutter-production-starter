import 'package:app_core/app_core.dart';
import 'package:app_storage/app_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/features/auth/auth.dart';
import 'package:mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mobile/features/auth_v2/auth_v2.dart';

enum AuthVersion { v1, v2 }

void configureAuthImplementation({
  required GetIt getIt,
  required AuthVersion version,
  required SecureStorage secureStorage,
  required AuthRemoteDataSource remoteDataSource,
}) {
  if (getIt.isRegistered<AuthRepository>()) {
    getIt.unregister<AuthRepository>();
  }

  switch (version) {
    case AuthVersion.v1:
      getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
          remoteDataSource: remoteDataSource,
          secureStorage: secureStorage,
        ),
      );
    case AuthVersion.v2:
      getIt.registerLazySingleton<AuthRepository>(
        () => AuthV2RepositoryImpl(
          secureStorage: secureStorage,
        ),
      );
  }
}

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

void main() {
  group('LEGO Pluggability: AuthRepository Swapping', () {
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

    test('Auth V1 implementation registers and fulfills LoginUseCase contract', () async {
      configureAuthImplementation(
        getIt: testGetIt,
        version: AuthVersion.v1,
        secureStorage: secureStorage,
        remoteDataSource: remoteDataSource,
      );

      final repo = testGetIt<AuthRepository>();
      final useCase = LoginUseCase(repo);

      final result = await useCase(email: 'test@example.com', password: 'password123');

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull?.user.id, equals('usr_v1'));
      expect(result.dataOrNull?.token, equals('v1_token_123'));
    });

    test('Auth V2 implementation plugs in seamlessly without modifying domain UseCases', () async {
      configureAuthImplementation(
        getIt: testGetIt,
        version: AuthVersion.v2,
        secureStorage: secureStorage,
        remoteDataSource: remoteDataSource,
      );

      final repo = testGetIt<AuthRepository>();
      final useCase = LoginUseCase(repo);

      final result = await useCase(email: 'test@example.com', password: 'password123');

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull?.user.id, equals('usr_v2_99'));
      expect(result.dataOrNull?.user.role, equals('pro_architect'));
      expect(result.dataOrNull?.token.startsWith('jwt_v2_secure_token_'), isTrue);
    });

    test('Guarantees exactly ONE AuthRepository implementation is active at a time', () {
      configureAuthImplementation(
        getIt: testGetIt,
        version: AuthVersion.v1,
        secureStorage: secureStorage,
        remoteDataSource: remoteDataSource,
      );

      expect(testGetIt.isRegistered<AuthRepository>(), isTrue);
      expect(testGetIt<AuthRepository>(), isA<AuthRepositoryImpl>());

      // Swap to V2
      configureAuthImplementation(
        getIt: testGetIt,
        version: AuthVersion.v2,
        secureStorage: secureStorage,
        remoteDataSource: remoteDataSource,
      );

      expect(testGetIt.isRegistered<AuthRepository>(), isTrue);
      expect(testGetIt<AuthRepository>(), isA<AuthV2RepositoryImpl>());
    });
  });
}
