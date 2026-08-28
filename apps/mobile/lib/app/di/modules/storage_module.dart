import 'package:app_storage/app_storage.dart';
import 'package:injectable/injectable.dart';

@module
abstract class StorageModule {
  @lazySingleton
  SecureStorage get secureStorage => InMemorySecureStorage();

  @lazySingleton
  KeyValueStorage get keyValueStorage => InMemoryKeyValueStorage();
}
