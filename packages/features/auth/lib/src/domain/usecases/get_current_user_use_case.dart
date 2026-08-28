import 'package:app_core/app_core.dart';
import 'package:auth_contract/auth_contract.dart';

/// Use case retrieving the currently authenticated user if session exists.
class GetCurrentUserUseCase {
  const GetCurrentUserUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<User?>> call() => _repository.getCurrentUser();
}
