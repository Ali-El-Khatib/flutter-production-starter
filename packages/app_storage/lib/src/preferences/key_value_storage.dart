import 'package:shared_preferences/shared_preferences.dart';

/// Contract for general persistent key-value configuration/preferences.
abstract class KeyValueStorage {
  const KeyValueStorage();

  Future<void> setString(String key, String value);
  Future<String?> getString(String key);

  Future<void> setBool(String key, bool value);
  Future<bool?> getBool(String key);

  Future<void> setInt(String key, int value);
  Future<int?> getInt(String key);

  Future<void> setDouble(String key, double value);
  Future<double?> getDouble(String key);

  Future<void> remove(String key);
  Future<void> clear();
  Future<bool> containsKey(String key);
}

/// Platform-backed preferences storage with an application-owned namespace.
class SharedPreferencesKeyValueStorage implements KeyValueStorage {
  SharedPreferencesKeyValueStorage({
    SharedPreferencesAsync? preferences,
    String namespace = 'starter.',
  })  : _preferences = preferences ?? SharedPreferencesAsync(),
        _namespace = namespace;

  final SharedPreferencesAsync _preferences;
  final String _namespace;

  String _key(String key) => '$_namespace$key';

  @override
  Future<void> setString(String key, String value) =>
      _preferences.setString(_key(key), value);

  @override
  Future<String?> getString(String key) => _preferences.getString(_key(key));

  @override
  Future<void> setBool(String key, bool value) =>
      _preferences.setBool(_key(key), value);

  @override
  Future<bool?> getBool(String key) => _preferences.getBool(_key(key));

  @override
  Future<void> setInt(String key, int value) =>
      _preferences.setInt(_key(key), value);

  @override
  Future<int?> getInt(String key) => _preferences.getInt(_key(key));

  @override
  Future<void> setDouble(String key, double value) =>
      _preferences.setDouble(_key(key), value);

  @override
  Future<double?> getDouble(String key) => _preferences.getDouble(_key(key));

  @override
  Future<void> remove(String key) => _preferences.remove(_key(key));

  @override
  Future<void> clear() async {
    final keys = await _preferences.getKeys();
    final ownedKeys = keys.where((key) => key.startsWith(_namespace)).toSet();
    if (ownedKeys.isNotEmpty) {
      await _preferences.clear(allowList: ownedKeys);
    }
  }

  @override
  Future<bool> containsKey(String key) => _preferences.containsKey(_key(key));
}

/// Deterministic in-memory implementation intended for tests only.
class InMemoryKeyValueStorage implements KeyValueStorage {
  InMemoryKeyValueStorage([Map<String, dynamic>? initialData])
      : _storage =
            initialData != null ? Map.of(initialData) : <String, dynamic>{};

  final Map<String, dynamic> _storage;

  @override
  Future<void> setString(String key, String value) async {
    _storage[key] = value;
  }

  @override
  Future<String?> getString(String key) async => _storage[key] as String?;

  @override
  Future<void> setBool(String key, bool value) async {
    _storage[key] = value;
  }

  @override
  Future<bool?> getBool(String key) async => _storage[key] as bool?;

  @override
  Future<void> setInt(String key, int value) async {
    _storage[key] = value;
  }

  @override
  Future<int?> getInt(String key) async => _storage[key] as int?;

  @override
  Future<void> setDouble(String key, double value) async {
    _storage[key] = value;
  }

  @override
  Future<double?> getDouble(String key) async => _storage[key] as double?;

  @override
  Future<void> remove(String key) async {
    _storage.remove(key);
  }

  @override
  Future<void> clear() async {
    _storage.clear();
  }

  @override
  Future<bool> containsKey(String key) async => _storage.containsKey(key);
}
