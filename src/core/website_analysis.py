"""Search, fetch, and analyze websites into structured summaries.

This module targets general websites. It performs a web search to discover candidate
sites for a given topic/location/keywords, then uses the WebsitesAnalyzer to crawl and
produce a structured WebsiteSummary for each URL.
"""

from __future__ import annotations

from dotenv import load_dotenv

from src.modules.websites_analyzer.websites_analyzer import WebsitesAnalyzer
from src.shared.models import WebsiteSummary

# Load environment variables
load_dotenv()

# Initialize main components
WEBSITES_ANALYZER = WebsitesAnalyzer()


def analyze_website(
    url: str,
) -> WebsiteSummary:
    """Analyze a single website URL and return a structured summary.

    Args:
            url: The website URL to crawl and analyze.

    Returns:
            A structured summary of the website as a WebsiteSummary object.

    Example:
            >>> summary = analyze_website("https://krono.agency")
            >>> print(summary.model_dump()["url"])  # => https://krono.agency
    """
    summary: WebsiteSummary = WEBSITES_ANALYZER.analyze_website(url)
    return summary
