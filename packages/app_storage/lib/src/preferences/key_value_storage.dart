/// Contract for general persistent key-value configuration/preferences.
abstract class KeyValueStorage {
  const KeyValueStorage();

  Future<void> setString(String key, String value);
  String? getString(String key);

  Future<void> setBool(String key, bool value);
  bool? getBool(String key);

  Future<void> setInt(String key, int value);
  int? getInt(String key);

  Future<void> setDouble(String key, double value);
  double? getDouble(String key);

  Future<void> remove(String key);
  Future<void> clear();
  bool containsKey(String key);
}

/// In-memory implementation of [KeyValueStorage] for testing or baseline fallback.
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
  String? getString(String key) => _storage[key] as String?;

  @override
  Future<void> setBool(String key, bool value) async {
    _storage[key] = value;
  }

  @override
  bool? getBool(String key) => _storage[key] as bool?;

  @override
  Future<void> setInt(String key, int value) async {
    _storage[key] = value;
  }

  @override
  int? getInt(String key) => _storage[key] as int?;

  @override
  Future<void> setDouble(String key, double value) async {
    _storage[key] = value;
  }

  @override
  double? getDouble(String key) => _storage[key] as double?;

  @override
  Future<void> remove(String key) async {
    _storage.remove(key);
  }

  @override
  Future<void> clear() async {
    _storage.clear();
  }

  @override
  bool containsKey(String key) => _storage.containsKey(key);
}
