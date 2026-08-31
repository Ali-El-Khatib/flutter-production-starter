import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Contract for securely storing sensitive data (e.g. auth tokens, secrets).
abstract class SecureStorage {
  const SecureStorage();

  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
  Future<void> deleteAll();
}

/// Platform-backed secure storage for production application data.
class FlutterSecureStorageAdapter implements SecureStorage {
  const FlutterSecureStorageAdapter({
    FlutterSecureStorage storage = const FlutterSecureStorage(),
    String namespace = 'starter.',
  })  : _storage = storage,
        _namespace = namespace;

  final FlutterSecureStorage _storage;
  final String _namespace;

  String _key(String key) => '$_namespace$key';

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: _key(key), value: value);

  @override
  Future<String?> read(String key) => _storage.read(key: _key(key));

  @override
  Future<void> delete(String key) => _storage.delete(key: _key(key));

  @override
  Future<void> deleteAll() async {
    final values = await _storage.readAll();
    final ownedKeys = values.keys.where((key) => key.startsWith(_namespace));
    await Future.wait(ownedKeys.map((key) => _storage.delete(key: key)));
  }
}

/// Deterministic in-memory implementation intended for tests only.
class InMemorySecureStorage implements SecureStorage {
  InMemorySecureStorage([Map<String, String>? initialData])
      : _storage =
            initialData != null ? Map.of(initialData) : <String, String>{};

  final Map<String, String> _storage;

  @override
  Future<void> write(String key, String value) async {
    _storage[key] = value;
  }

  @override
  Future<String?> read(String key) async {
    return _storage[key];
  }

  @override
  Future<void> delete(String key) async {
    _storage.remove(key);
  }

  @override
  Future<void> deleteAll() async {
    _storage.clear();
  }
}
