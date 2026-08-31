import 'package:app_network/app_network.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/app/config/app_config.dart';
import 'package:mobile/features/profile/data/repositories/demo_profile_repository.dart';
import 'package:mobile/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:mobile/features/profile/domain/repositories/profile_repository.dart';

/// Application-owned selection of environment-specific feature adapters.
@module
abstract class FeatureModule {
  @lazySingleton
  ProfileRepository profileRepository(ApiClient apiClient, AppConfig config) {
    return config.enableDemoData
        ? const DemoProfileRepository()
        : ProfileRepositoryImpl(apiClient);
  }
}
