# App Storage (`package:app_storage`)

Storage abstractions and implementations for secure persistence, key-value storage, and in-memory caching.

---

## 📦 Features

- **`SecureStorage` Contract**: Interface for sensitive data (tokens, credentials, API keys) + `InMemorySecureStorage` implementation for testing and environments without hardware keystores.
- **`KeyValueStorage` Contract**: Interface for user preferences, flags, and drafts + `InMemoryKeyValueStorage` implementation.
- **`MemoryCache<K, V>`**: Generic thread-safe cache supporting Time-To-Live (TTL) expiration and manual cache invalidation.

---

## 🚀 Usage

### Secure Storage
```dart
import 'package:app_storage/app_storage.dart';

final SecureStorage secureStorage = InMemorySecureStorage();

// Save token
await secureStorage.write(key: 'auth_token', value: 'jwt_abc_123');

// Read token
final token = await secureStorage.read('auth_token');

// Delete token
await secureStorage.delete('auth_token');
```

### In-Memory Cache with TTL
```dart
final cache = MemoryCache<String, UserProfile>(
  defaultTtl: const Duration(minutes: 5),
);

cache.set('user_1', profile);

final cachedProfile = cache.get('user_1'); // null if TTL expired
```

---

## 🧪 Testing

```bash
flutter test
```
