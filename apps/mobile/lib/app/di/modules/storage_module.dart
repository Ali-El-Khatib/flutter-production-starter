import 'package:app_storage/app_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/app/config/app_config.dart';

@module
abstract class StorageModule {
  @lazySingleton
  SecureStorage secureStorage(AppConfig config) => config.useInMemoryStorage
      ? InMemorySecureStorage()
      : const FlutterSecureStorageAdapter();

  @lazySingleton
  KeyValueStorage keyValueStorage(AppConfig config) => config.useInMemoryStorage
      ? InMemoryKeyValueStorage()
      : SharedPreferencesKeyValueStorage();
}
