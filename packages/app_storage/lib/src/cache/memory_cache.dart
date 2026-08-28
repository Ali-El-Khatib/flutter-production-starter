class _CacheEntry<V> {
  _CacheEntry({
    required this.value,
    required this.expiresAt,
  });

  final V value;
  final DateTime? expiresAt;

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
}

/// Generic in-memory cache with optional TTL expiration.
class MemoryCache<K, V> {
  final Map<K, _CacheEntry<V>> _cache = {};

  void put(K key, V value, {Duration? ttl}) {
    _cache[key] = _CacheEntry<V>(
      value: value,
      expiresAt: ttl != null ? DateTime.now().add(ttl) : null,
    );
  }

  V? get(K key) {
    final entry = _cache[key];
    if (entry == null) return null;

    if (entry.isExpired) {
      _cache.remove(key);
      return null;
    }

    return entry.value;
  }

  void remove(K key) {
    _cache.remove(key);
  }

  void clear() {
    _cache.clear();
  }

  int get size => _cache.length;
}
