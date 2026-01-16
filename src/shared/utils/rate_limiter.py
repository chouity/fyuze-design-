import time


class RateLimiter:
    """
    Simple rate limiter to restrict the number of operations within a time window.

    Args:
        max_calls (int): Maximum allowed calls within the time window.
        time_window (float): Time window in seconds.

    Example:
        >>> limiter = RateLimiter(max_calls=2, time_window=5)
        >>> limiter.can_proceed()
        True
        >>> limiter.can_proceed()
        True
        >>> limiter.can_proceed()
        False
        >>> limiter.wait_time()  # Time to wait before next allowed call
        # Returns a float >= 0
    """

    def __init__(self, max_calls: int, time_window: float):
        self.max_calls = max_calls
        self.time_window = time_window
        self.calls = []

    def can_proceed(self) -> bool:
        """
        Check if operation can proceed within the rate limit.

        Returns:
            bool: True if allowed, False if rate limit exceeded.

        Example:
            >>> limiter = RateLimiter(1, 2)
            >>> limiter.can_proceed()
            True
            >>> limiter.can_proceed()
            False
        """
        now = time.time()
        # Remove old calls outside time window
        self.calls = [
            call_time for call_time in self.calls if now - call_time < self.time_window
        ]

        if len(self.calls) < self.max_calls:
            self.calls.append(now)
            return True

        return False

    def wait_time(self) -> float:
        """
        Get time to wait before the next allowed call.

        Returns:
            float: Seconds to wait (0.0 if allowed immediately).

        Example:
            >>> limiter = RateLimiter(1, 1)
            >>> limiter.can_proceed()
            True
            >>> limiter.wait_time()
            0.0
            >>> limiter.can_proceed()
            False
            >>> limiter.wait_time() >= 0
            True
        """
        if not self.calls:
            return 0.0

        oldest_call = min(self.calls)
        return max(0.0, self.time_window - (time.time() - oldest_call))
