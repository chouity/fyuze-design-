"""Loader that exposes the protected ``src.modules.search_engine`` package."""

from __future__ import annotations

import importlib
import importlib.machinery
import importlib.util
import sys
from pathlib import Path
from types import ModuleType

_PACKAGE_NAME = "src.modules.search_engine"
_DIST_RELATIVE = Path("dist") / "protected" / "search_engine"
_REPO_ROOT = Path(__file__).resolve().parents[3]
_BINARY_DIR = _REPO_ROOT / _DIST_RELATIVE
_INIT_FILE = _BINARY_DIR / "__init__.pyc"

__all__ = [
    "SearchEngine",
    "URLParser",
    "package",
]


def _import_protected_package() -> ModuleType:
    """Load the compiled package into ``sys.modules`` under its original name."""
    if not _INIT_FILE.exists():
        raise ImportError(
            f"Protected package entry point '{_INIT_FILE}' not found. "
            "Run scripts/build_protected_search_engine.py to regenerate it."
        )

    # Ensure the parent namespace package exists
    importlib.import_module("src.modules")

    existing = sys.modules.get(_PACKAGE_NAME)
    if existing is not None:
        return existing

    loader = importlib.machinery.SourcelessFileLoader(_PACKAGE_NAME, str(_INIT_FILE))
    spec = importlib.util.spec_from_loader(_PACKAGE_NAME, loader, is_package=True)
    if spec is None:
        raise ImportError(f"Unable to create spec for {_PACKAGE_NAME}")

    module = importlib.util.module_from_spec(spec)
    module.__file__ = str(_INIT_FILE)
    module.__path__ = [str(_BINARY_DIR)]
    sys.modules[_PACKAGE_NAME] = module
    loader.exec_module(module)
    return module


package = _import_protected_package()

_search_engine_module = importlib.import_module(f"{_PACKAGE_NAME}.search_engine")
_url_parser_module = importlib.import_module(f"{_PACKAGE_NAME}._url_parser")

SearchEngine = getattr(package, "SearchEngine", _search_engine_module.SearchEngine)
URLParser = getattr(package, "URLParser", _url_parser_module.URLParser)

# Ensure the original package also exposes the expected symbols for backwards compatibility
setattr(package, "SearchEngine", SearchEngine)
setattr(package, "URLParser", URLParser)
