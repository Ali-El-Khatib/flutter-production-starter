import 'package:app_storage/app_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InMemorySecureStorage', () {
    late SecureStorage storage;

    setUp(() {
      storage = InMemorySecureStorage();
    });

    test('writes, reads, and deletes key-value pairs', () async {
      await storage.write('auth_token', 'xyz-123');
      expect(await storage.read('auth_token'), equals('xyz-123'));

      await storage.delete('auth_token');
      expect(await storage.read('auth_token'), isNull);
    });
  });

  group('InMemoryKeyValueStorage', () {
    late KeyValueStorage storage;

    setUp(() {
      storage = InMemoryKeyValueStorage();
    });

    test('handles primitive types correctly', () async {
      await storage.setString('theme', 'dark');
      await storage.setBool('onboarding_completed', true);
      await storage.setInt('launch_count', 5);

      expect(storage.getString('theme'), equals('dark'));
      expect(storage.getBool('onboarding_completed'), isTrue);
      expect(storage.getInt('launch_count'), equals(5));
    });
  });

  group('MemoryCache', () {
    test('expires items after TTL', () async {
      final cache = MemoryCache<String, String>();
      cache.put('key1', 'value1', ttl: const Duration(milliseconds: 50));

      expect(cache.get('key1'), equals('value1'));

      await Future<void>.delayed(const Duration(milliseconds: 60));
      expect(cache.get('key1'), isNull);
    });
  });
}
