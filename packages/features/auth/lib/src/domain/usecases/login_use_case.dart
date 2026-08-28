import 'package:app_core/app_core.dart';
import 'package:auth_contract/auth_contract.dart';

/// Use case handling user login with validation rules.
class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<AuthSession>> call({
    required String email,
    required String password,
  }) async {
    final trimmedEmail = email.trim();
    final trimmedPassword = password.trim();

    final fieldErrors = <String, List<String>>{};

    if (trimmedEmail.isEmpty) {
      fieldErrors['email'] = ['Email is required'];
    } else if (!trimmedEmail.contains('@') || !trimmedEmail.contains('.')) {
      fieldErrors['email'] = ['Please enter a valid email address'];
    }

    if (trimmedPassword.isEmpty) {
      fieldErrors['password'] = ['Password is required'];
    } else if (trimmedPassword.length < 6) {
      fieldErrors['password'] = ['Password must be at least 6 characters'];
    }

    if (fieldErrors.isNotEmpty) {
      return Result.failure(
        ValidationFailure(
          message: 'Please resolve form errors before proceeding',
          fieldErrors: fieldErrors,
        ),
      );
    }

    return _repository.login(
      email: trimmedEmail,
      password: trimmedPassword,
    );
  }
}
