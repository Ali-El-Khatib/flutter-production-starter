import 'package:app_core/app_core.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/features/auth/domain/repositories/auth_repository.dart';

/// Use case handling user logout and session cleanup.
@injectable
class LogoutUseCase {
  const LogoutUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<void>> call() => _repository.logout();
}
