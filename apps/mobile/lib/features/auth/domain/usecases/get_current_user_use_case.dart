import 'package:app_core/app_core.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/features/auth/domain/entities/user.dart';
import 'package:mobile/features/auth/domain/repositories/auth_repository.dart';

/// Use case retrieving the currently authenticated user if session exists.
@injectable
class GetCurrentUserUseCase {
  const GetCurrentUserUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<User?>> call() => _repository.getCurrentUser();
}
