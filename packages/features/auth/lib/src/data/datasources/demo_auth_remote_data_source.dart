import 'package:app_core/app_core.dart';
import 'auth_remote_data_source.dart';

/// Explicit development-only authentication source.
///
/// This adapter is selected by application composition and never activates as
/// a fallback for failed production or staging requests.
class DemoAuthRemoteDataSource implements AuthRemoteDataSource {
  const DemoAuthRemoteDataSource();

  @override
  Future<Result<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    return Result.success({
      'token': 'demo_access_token',
      'refresh_token': 'demo_refresh_token',
      'user': {
        'id': 'demo_user',
        'email': email,
        'name': email.split('@').first,
        'role': 'developer',
      },
    });
  }

  @override
  Future<Result<void>> logout() async => const Result.success(null);

  @override
  Future<Result<Map<String, dynamic>>> getCurrentUser() async {
    return const Result.failure(
      UnauthorizedFailure(message: 'No remote demo session is active'),
    );
  }
}
