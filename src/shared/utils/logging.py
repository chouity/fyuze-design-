"""
Production-ready logging configuration for Fyuze Core
"""

import logging
import logging.handlers
import sys
from pathlib import Path
from typing import Optional


class ColoredFormatter(logging.Formatter):
    """
    Colored console formatter for better readability.

    Example:
        >>> import logging
        >>> from logging import StreamHandler
        >>> handler = StreamHandler()
        >>> handler.setFormatter(ColoredFormatter('%(levelname)s: %(message)s'))
        >>> logger = logging.getLogger('test')
        >>> logger.addHandler(handler)
        >>> logger.warning('This is a warning!')
        # Output will be colored in the console
    """

    COLORS = {
        "DEBUG": "\033[36m",  # Cyan
        "INFO": "\033[32m",  # Green
        "WARNING": "\033[33m",  # Yellow
        "ERROR": "\033[31m",  # Red
        "CRITICAL": "\033[35m",  # Magenta
        "RESET": "\033[0m",  # Reset
    }

    def format(self, record):
        if hasattr(record, "levelname"):
            color = self.COLORS.get(record.levelname, self.COLORS["RESET"])
            record.levelname = f"{color}{record.levelname}{self.COLORS['RESET']}"
        return super().format(record)


class FyuzeLogger:
    """
    Production logger with file rotation and structured output.

    Features:
        - Console logging with color
        - Rotating file logging (info/debug and error logs)
        - Singleton per logger name

    Example:
        >>> logger = FyuzeLogger('my_module')
        >>> logger.info('Hello, world!')
        >>> logger.error('Something went wrong')

    To change log directory:
        >>> FyuzeLogger.set_log_directory('logs')
    """

    _instances = {}
    _base_log_dir = None

    @classmethod
    def set_log_directory(cls, log_dir: str):
        """Set the base directory for log files"""
        cls._base_log_dir = Path(log_dir)
        cls._base_log_dir.mkdir(parents=True, exist_ok=True)

    def __new__(cls, name: str):
        if name not in cls._instances:
            cls._instances[name] = super().__new__(cls)
        return cls._instances[name]

    def __init__(self, name: str):
        if hasattr(self, "_initialized"):
            return

        self.name = name
        self.logger = logging.getLogger(name)

        # Set default log directory if not set
        if self._base_log_dir is None:
            project_root = Path(__file__).parent.parent.parent
            self.set_log_directory(project_root / "logs")

        self._setup_logger()
        self._initialized = True

    def _setup_logger(self):
        """Configure logger with console and file handlers"""
        self.logger.setLevel(logging.DEBUG)

        # Clear existing handlers
        self.logger.handlers.clear()

        # Console handler with colors
        console_handler = logging.StreamHandler(sys.stdout)
        console_handler.setLevel(logging.INFO)
        console_formatter = ColoredFormatter(
            "%(asctime)s | %(name)s | %(levelname)s | %(message)s", datefmt="%H:%M:%S"
        )
        console_handler.setFormatter(console_formatter)
        self.logger.addHandler(console_handler)

        # File handler with rotation
        log_file = self._base_log_dir / f"{self.name}.log"
        file_handler = logging.handlers.RotatingFileHandler(
            log_file, maxBytes=10 * 1024 * 1024, backupCount=5  # 10MB
        )
        file_handler.setLevel(logging.DEBUG)
        file_formatter = logging.Formatter(
            "%(asctime)s | %(name)s | %(levelname)s | %(funcName)s:%(lineno)d | %(message)s",
            datefmt="%Y-%m-%d %H:%M:%S",
        )
        file_handler.setFormatter(file_formatter)
        self.logger.addHandler(file_handler)

        # Error file handler
        error_file = self._base_log_dir / f"{self.name}_errors.log"
        error_handler = logging.handlers.RotatingFileHandler(
            error_file, maxBytes=10 * 1024 * 1024, backupCount=3  # 10MB
        )
        error_handler.setLevel(logging.ERROR)
        error_handler.setFormatter(file_formatter)
        self.logger.addHandler(error_handler)

        # Prevent duplicate logs
        self.logger.propagate = False

    def debug(self, msg, *args, **kwargs):
        self.logger.debug(msg, *args, **kwargs)

    def info(self, msg, *args, **kwargs):
        self.logger.info(msg, *args, **kwargs)

    def warning(self, msg, *args, **kwargs):
        self.logger.warning(msg, *args, **kwargs)

    def error(self, msg, *args, **kwargs):
        self.logger.error(msg, *args, **kwargs)

    def critical(self, msg, *args, **kwargs):
        self.logger.critical(msg, *args, **kwargs)

    def exception(self, msg, *args, **kwargs):
        self.logger.exception(msg, *args, **kwargs)


def get_logger(name: str) -> FyuzeLogger:
    """
    Get a logger instance for the given name.

    Args:
        name (str): Logger name (typically module name)

    Returns:
        FyuzeLogger: Logger instance

    Example:
        >>> logger = get_logger(__name__)
        >>> logger.debug('Debug message')
    """
    return FyuzeLogger(name)


def setup_logging(log_dir: Optional[str] = None, level: str = "INFO"):
    """
    Setup global logging configuration.

    Args:
        log_dir (str, optional): Directory for log files.
        level (str): Default logging level (e.g., 'INFO', 'DEBUG').

    Example:
        >>> setup_logging(log_dir='logs', level='DEBUG')
        >>> logger = get_logger('test')
        >>> logger.info('Logging is set up!')
    """
    if log_dir:
        FyuzeLogger.set_log_directory(log_dir)

    # Set root logger level
    logging.getLogger().setLevel(getattr(logging, level.upper(), logging.INFO))

    # Disable some noisy loggers
    logging.getLogger("urllib3").setLevel(logging.WARNING)
    logging.getLogger("requests").setLevel(logging.WARNING)
