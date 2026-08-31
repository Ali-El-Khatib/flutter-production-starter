import 'package:app_network/app_network.dart';
import 'package:app_storage/app_storage.dart';
import 'package:auth_contract/auth_contract.dart';
import 'package:get_it/get_it.dart';
import '../data/auth_storage_keys.dart';
import '../data/datasources/demo_auth_remote_data_source.dart';
import '../data/datasources/auth_remote_data_source.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/usecases/get_current_user_use_case.dart';
import '../domain/usecases/login_use_case.dart';
import '../domain/usecases/logout_use_case.dart';
import '../presentation/state/auth_bloc.dart';

/// Registers all authentication feature dependencies into the shared application [GetIt] container.
void registerAuthFeature(GetIt getIt, {required bool enableDemoData}) {
  if (!getIt.isRegistered<TokenProvider>()) {
    getIt.registerLazySingleton<TokenProvider>(
      () => () => getIt<SecureStorage>().read(AuthStorageKeys.accessToken),
    );
  }

  if (!getIt.isRegistered<AuthRemoteDataSource>()) {
    getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => enableDemoData
          ? const DemoAuthRemoteDataSource()
          : AuthRemoteDataSourceImpl(getIt<ApiClient>()),
    );
  }

  if (!getIt.isRegistered<AuthRepository>()) {
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: getIt<AuthRemoteDataSource>(),
        secureStorage: getIt<SecureStorage>(),
      ),
    );
  }

  if (!getIt.isRegistered<LoginUseCase>()) {
    getIt.registerFactory<LoginUseCase>(
      () => LoginUseCase(getIt<AuthRepository>()),
    );
  }

  if (!getIt.isRegistered<LogoutUseCase>()) {
    getIt.registerFactory<LogoutUseCase>(
      () => LogoutUseCase(getIt<AuthRepository>()),
    );
  }

  if (!getIt.isRegistered<GetCurrentUserUseCase>()) {
    getIt.registerFactory<GetCurrentUserUseCase>(
      () => GetCurrentUserUseCase(getIt<AuthRepository>()),
    );
  }

  if (!getIt.isRegistered<AuthBloc>()) {
    getIt.registerLazySingleton<AuthBloc>(
      () => AuthBloc(
        loginUseCase: getIt<LoginUseCase>(),
        logoutUseCase: getIt<LogoutUseCase>(),
        getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
      ),
    );
  }
}
