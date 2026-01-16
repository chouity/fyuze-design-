import time
from typing import Any, Optional


class Cache:
    """
    Simple in-memory cache with TTL (Time-To-Live).

    This class provides a dictionary-like cache with optional expiration for each key.
    Values are automatically removed after their TTL expires.

    Args:
        default_ttl (float): Default time-to-live for cache entries in seconds. Defaults to 300 seconds (5 minutes).

    Example:
        >>> cache = Cache(default_ttl=2)  # 2 seconds TTL
        >>> cache.set('foo', 'bar')
        >>> cache.get('foo')
        'bar'
        >>> import time; time.sleep(2)
        >>> cache.get('foo')
        # Returns None, as the entry has expired
        >>> cache.set('baz', 123, ttl=1)
        >>> cache.get('baz')
        123
        >>> cache.delete('baz')
        >>> cache.get('baz')
        # Returns None
        >>> cache.set('a', 1)
        >>> cache.set('b', 2)
        >>> cache.clear()
        >>> cache.get('a')
        # Returns None
    """

    def __init__(self, default_ttl: float = 300):  # 5 minutes default
        self.default_ttl = default_ttl
        self._cache = {}

    def get(self, key: str, default: Any = None) -> Any:
        """Get value from cache"""
        if key in self._cache:
            value, expiry = self._cache[key]
            if time.time() < expiry:
                return value
            else:
                del self._cache[key]

        return default

    def set(self, key: str, value: Any, ttl: Optional[float] = None) -> None:
        """Set value in cache"""
        if ttl is None:
            ttl = self.default_ttl

        expiry = time.time() + ttl
        self._cache[key] = (value, expiry)

    def delete(self, key: str) -> None:
        """Delete value from cache"""
        self._cache.pop(key, None)

    def clear(self) -> None:
        """Clear all cache"""
        self._cache.clear()

    def cleanup(self) -> None:
        """Remove expired entries"""
        now = time.time()
        expired_keys = [k for k, (_, expiry) in self._cache.items() if now >= expiry]
        for key in expired_keys:
            del self._cache[key]
