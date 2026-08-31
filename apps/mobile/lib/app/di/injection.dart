import 'package:app_network/app_network.dart';
import 'package:feature_auth/feature_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/app/config/app_config.dart';
import 'package:mobile/app/di/injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
  ignoreUnregisteredTypes: [AppConfig, AuthBloc, TokenProvider],
)
Future<void> configureDependencies(AppConfig config) async {
  if (getIt.isRegistered<AppConfig>()) {
    await getIt.reset();
  }
  getIt.registerSingleton<AppConfig>(config);
  getIt.init(environment: config.environment.name);

  // Register Package-Level LEGO Bricks
  registerAuthFeature(getIt, enableDemoData: config.enableDemoData);
}
