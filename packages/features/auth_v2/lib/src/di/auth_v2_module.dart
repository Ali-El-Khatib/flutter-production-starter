import 'package:app_storage/app_storage.dart';
import 'package:auth_contract/auth_contract.dart';
import 'package:get_it/get_it.dart';
import '../data/repositories/auth_v2_repository_impl.dart';

/// Registers the Auth V2 demonstration implementation into the shared application [GetIt] container.
void registerAuthV2Feature(GetIt getIt) {
  if (getIt.isRegistered<AuthRepository>()) {
    getIt.unregister<AuthRepository>();
  }

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthV2RepositoryImpl(
      secureStorage: getIt<SecureStorage>(),
    ),
  );
}
