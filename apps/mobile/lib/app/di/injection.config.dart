// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:app_core/app_core.dart' as _i130;
import 'package:app_network/app_network.dart' as _i107;
import 'package:app_storage/app_storage.dart' as _i646;
import 'package:design_system/design_system.dart' as _i1063;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/profile/data/repositories/profile_repository_impl.dart'
    as _i334;
import '../../features/profile/domain/repositories/profile_repository.dart'
    as _i894;
import '../../features/profile/presentation/state/profile_bloc.dart' as _i421;
import '../../features/settings/presentation/state/settings_bloc.dart'
    as _i1024;
import '../config/app_config.dart' as _i650;
import '../router/app_router.dart' as _i81;
import 'modules/app_module.dart' as _i349;
import 'modules/network_module.dart' as _i851;
import 'modules/storage_module.dart' as _i148;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    final networkModule = _$NetworkModule();
    final storageModule = _$StorageModule();
    gh.lazySingleton<_i130.AppLogger>(() => appModule.logger);
    gh.lazySingleton<_i130.FailureMessageResolver>(
        () => appModule.failureMessageResolver);
    gh.lazySingleton<_i1063.AppFeedback>(() => appModule.feedback);
    gh.lazySingleton<_i81.AppRouter>(() => appModule.router);
    gh.lazySingleton<_i107.NetworkErrorMapper>(
        () => networkModule.networkErrorMapper);
    gh.lazySingleton<_i646.SecureStorage>(() => storageModule.secureStorage);
    gh.lazySingleton<_i646.KeyValueStorage>(
        () => storageModule.keyValueStorage);
    gh.lazySingleton<_i1024.SettingsBloc>(() => _i1024.SettingsBloc());
    gh.lazySingleton<_i361.Dio>(() => networkModule.dio(
          gh<_i650.AppConfig>(),
          gh<_i130.AppLogger>(),
        ));
    gh.lazySingleton<_i107.ApiClient>(() => networkModule.apiClient(
          gh<_i361.Dio>(),
          gh<_i107.NetworkErrorMapper>(),
        ));
    gh.lazySingleton<_i894.ProfileRepository>(
        () => _i334.ProfileRepositoryImpl(gh<_i107.ApiClient>()));
    gh.factory<_i421.ProfileBloc>(
        () => _i421.ProfileBloc(gh<_i894.ProfileRepository>()));
    return this;
  }
}

class _$AppModule extends _i349.AppModule {}

class _$NetworkModule extends _i851.NetworkModule {}

class _$StorageModule extends _i148.StorageModule {}
