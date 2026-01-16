"""Perform basic Google Custom Search and return structured results.

This module provides a high-level interface for basic search functionality,
mirroring the style of `website_analysis.py`. It uses the SearchEngine's
basic_search method to perform Google Custom Search and return structured
BasicSearchResult objects.
"""

from __future__ import annotations

from dotenv import load_dotenv

from src.protected.search_engine import SearchEngine
from src.shared.models import BasicSearchResult

# Load environment variables
load_dotenv()

# Initialize main components
SEARCH_ENGINE = SearchEngine()


def basic_search(
    query: str,
    gl: str | None = None,
) -> BasicSearchResult:
    """Perform a basic Google Custom Search and return structured results.

    Args:
        query: The search query string.
        gl: Optional geographic location code (e.g., "us", "lb"). Defaults to None.

    Returns:
        A BasicSearchResult object containing the search outcome, including
        timing, success status, and list of GoogleSearchResult items.

    Example:
        >>> result = basic_search("food restaurants Tripoli Lebanon")
        >>> print(result.success)  # => True
        >>> print(len(result.response or []))  # => 10
    """
    result: BasicSearchResult = SEARCH_ENGINE.basic_search(query, gl)
    return result
