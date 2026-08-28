/// Contract for securely storing sensitive data (e.g. auth tokens, secrets).
abstract class SecureStorage {
  const SecureStorage();

  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
  Future<void> deleteAll();
}

/// In-memory implementation of [SecureStorage], primarily for tests or fallback.
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
