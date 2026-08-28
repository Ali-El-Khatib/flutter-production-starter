import 'package:app_core/app_core.dart';
import 'package:auth_contract/auth_contract.dart';
import 'package:feature_auth/feature_auth.dart';
import 'package:flutter_test/flutter_test.dart';

class MockAuthRepository implements AuthRepository {
  @override
  Future<Result<AuthSession>> login({
    required String email,
    required String password,
  }) async {
    if (email == 'user@test.com' && password == 'password123') {
      return const Result.success(
        AuthSession(
          user: User(
              id: '1', email: 'user@test.com', name: 'Tester', role: 'user'),
          token: 'mock_token',
        ),
      );
    }
    return const Result.failure(
      UnauthorizedFailure(message: 'Invalid credentials'),
    );
  }

  @override
  Future<Result<User?>> getCurrentUser() async => const Result.success(null);

  @override
  Future<Result<void>> logout() async => const Result.success(null);
}

void main() {
  group('LoginUseCase', () {
    late LoginUseCase useCase;

    setUp(() {
      useCase = LoginUseCase(MockAuthRepository());
    });

    test('validates email format before repository invocation', () async {
      final result =
          await useCase(email: 'invalid-email', password: 'password123');

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<ValidationFailure>());
      final validationFailure = result.failureOrNull as ValidationFailure;
      expect(validationFailure.fieldErrors.containsKey('email'), isTrue);
    });

    test('validates password length before repository invocation', () async {
      final result = await useCase(email: 'user@test.com', password: '123');

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<ValidationFailure>());
      final validationFailure = result.failureOrNull as ValidationFailure;
      expect(validationFailure.fieldErrors.containsKey('password'), isTrue);
    });

    test('returns AuthSession upon successful valid credentials', () async {
      final result =
          await useCase(email: 'user@test.com', password: 'password123');

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull?.user.name, equals('Tester'));
      expect(result.dataOrNull?.token, equals('mock_token'));
    });
  });
}
