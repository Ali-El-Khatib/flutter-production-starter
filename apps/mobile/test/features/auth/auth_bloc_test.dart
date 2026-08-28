import 'package:app_core/app_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/auth/auth.dart';

class MockLoginUseCase extends LoginUseCase {
  MockLoginUseCase() : super(const _DummyRepo());

  @override
  Future<Result<AuthSession>> call({
    required String email,
    required String password,
  }) async {
    if (email == 'user@test.com' && password == 'valid123') {
      return const Result.success(
        AuthSession(
          user: User(id: '1', email: 'user@test.com', name: 'Valid User'),
          token: 'token_abc',
        ),
      );
    }
    return const Result.failure(
      UnauthorizedFailure(message: 'Invalid credentials'),
    );
  }
}

class MockLogoutUseCase extends LogoutUseCase {
  MockLogoutUseCase() : super(const _DummyRepo());

  @override
  Future<Result<void>> call() async => const Result.success(null);
}

class MockGetCurrentUserUseCase extends GetCurrentUserUseCase {
  MockGetCurrentUserUseCase() : super(const _DummyRepo());

  @override
  Future<Result<User?>> call() async => const Result.success(null);
}

class _DummyRepo implements AuthRepository {
  const _DummyRepo();
  @override
  Future<Result<User?>> getCurrentUser() async => const Result.success(null);
  @override
  Future<Result<AuthSession>> login(
          {required String email, required String password}) async =>
      const Result.failure(UnknownFailure());
  @override
  Future<Result<void>> logout() async => const Result.success(null);
}

void main() {
  group('AuthBloc', () {
    late AuthBloc authBloc;

    setUp(() {
      authBloc = AuthBloc(
        loginUseCase: MockLoginUseCase(),
        logoutUseCase: MockLogoutUseCase(),
        getCurrentUserUseCase: MockGetCurrentUserUseCase(),
      );
    });

    test('initial state is unauthenticated', () {
      expect(authBloc.state.value.isAuthenticated, isFalse);
      expect(authBloc.state.value.user, isNull);
    });

    test('login success sets isAuthenticated to true', () async {
      authBloc.login(email: 'user@test.com', password: 'valid123');

      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(authBloc.state.value.isAuthenticated, isTrue);
      expect(authBloc.state.value.user?.name, equals('Valid User'));
      expect(authBloc.state.value.failure, isNull);
    });

    test('login failure sets failure in state', () async {
      authBloc.login(email: 'wrong@test.com', password: 'wrong');

      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(authBloc.state.value.isAuthenticated, isFalse);
      expect(authBloc.state.value.failure, isA<UnauthorizedFailure>());
    });

    test('logout resets authenticated state', () async {
      authBloc.login(email: 'user@test.com', password: 'valid123');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      authBloc.logout();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(authBloc.state.value.isAuthenticated, isFalse);
      expect(authBloc.state.value.user, isNull);
    });
  });
}
