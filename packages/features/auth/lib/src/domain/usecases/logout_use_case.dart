import 'package:app_core/app_core.dart';
import 'package:auth_contract/auth_contract.dart';

/// Use case handling user logout and session cleanup.
class LogoutUseCase {
  const LogoutUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<void>> call() => _repository.logout();
}
