from collections.abc import Callable
from functools import wraps
import time
import asyncio


def retry(max_attempts: int = 3, delay: float = 1.0, backoff: float = 2.0):
    """
    Retry decorator with exponential backoff for synchronous functions.

    Args:
        max_attempts (int): Maximum number of retry attempts. Defaults to 3.
        delay (float): Initial delay between retries in seconds. Defaults to 1.0.
        backoff (float): Backoff multiplier for delay. Defaults to 2.0.

    Example:
        >>> from retry import retry
        >>> @retry(max_attempts=3, delay=1, backoff=2)
        ... def flaky():
        ...     print('Trying...')
        ...     raise ValueError('Fail!')
        >>> try:
        ...     flaky()
        ... except ValueError:
        ...     print('Failed after retries')

    This will print 'Trying...' three times, then 'Failed after retries'.
    """

    def decorator(func: Callable):
        @wraps(func)
        def wrapper(*args, **kwargs):
            current_delay = delay
            last_exception = None

            for attempt in range(max_attempts):
                try:
                    return func(*args, **kwargs)
                except Exception as e:
                    last_exception = e
                    if attempt < max_attempts - 1:
                        time.sleep(current_delay)
                        current_delay *= backoff
                    else:
                        raise last_exception

            raise last_exception

        return wrapper

    return decorator


def async_retry(max_attempts: int = 3, delay: float = 1.0, backoff: float = 2.0):
    """
    Async retry decorator with exponential backoff for async functions.

    Args:
        max_attempts (int): Maximum number of retry attempts. Defaults to 3.
        delay (float): Initial delay between retries in seconds. Defaults to 1.0.
        backoff (float): Backoff multiplier for delay. Defaults to 2.0.

    Example:
        >>> import asyncio
        >>> from retry import async_retry
        >>> @async_retry(max_attempts=2, delay=0.5, backoff=2)
        ... async def async_flaky():
        ...     print('Async trying...')
        ...     raise RuntimeError('Async fail!')
        >>> async def main():
        ...     try:
        ...         await async_flaky()
        ...     except RuntimeError:
        ...         print('Async failed after retries')
        >>> asyncio.run(main())

    This will print 'Async trying...' two times, then 'Async failed after retries'.
    """

    def decorator(func: Callable):
        @wraps(func)
        async def wrapper(*args, **kwargs):
            current_delay = delay
            last_exception = None

            for attempt in range(max_attempts):
                try:
                    return await func(*args, **kwargs)
                except Exception as e:
                    last_exception = e
                    if attempt < max_attempts - 1:
                        await asyncio.sleep(current_delay)
                        current_delay *= backoff
                    else:
                        raise last_exception

            raise last_exception

        return wrapper

    return decorator
