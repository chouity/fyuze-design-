"""
Custom shared exceptions for Fyuze Core
"""

from typing import Any, Dict, Optional


class FyuzeBaseException(Exception):
    """Base exception for all Fyuze Core exceptions"""

    def __init__(
        self,
        message: str,
        code: Optional[str] = None,
        details: Optional[Dict[str, Any]] = None,
    ):
        super().__init__(message)
        self.message = message
        self.code = code or self.__class__.__name__
        self.details = details or {}

    def to_dict(self) -> Dict[str, Any]:
        """Convert exception to dictionary"""
        return {"error": self.code, "message": self.message, "details": self.details}


class ConfigurationError(FyuzeBaseException):
    """Raised when there's a configuration error"""

    pass


class ValidationError(FyuzeBaseException):
    """Raised when validation fails"""

    pass
