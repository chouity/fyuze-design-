from dataclasses import dataclass, field
from typing import List, Optional
from datetime import datetime


@dataclass
class BasicSearchResultItem:
    """Represents a single Basic Search result item."""

    kind: str
    title: str
    html_title: str
    link: str
    display_link: str
    snippet: str
    html_snippet: str
    formatted_url: str
    html_formatted_url: str
    pagemap: dict = field(default_factory=dict)

    @classmethod
    def from_dict(cls, data: dict) -> "BasicSearchResultItem":
        """Create a BasicSearchResultItem from a dictionary (e.g., JSON response)."""
        return cls(
            kind=data.get("kind", ""),
            title=data.get("title", ""),
            html_title=data.get("htmlTitle", ""),
            link=data.get("link", ""),
            display_link=data.get("displayLink", ""),
            snippet=data.get("snippet", ""),
            html_snippet=data.get("htmlSnippet", ""),
            formatted_url=data.get("formattedUrl", ""),
            html_formatted_url=data.get("htmlFormattedUrl", ""),
            pagemap=data.get("pagemap", {}),
        )

    def to_dict(self) -> dict:
        """Convert BasicSearchResultItem to a dictionary."""
        return {
            "kind": self.kind,
            "title": self.title,
            "html_title": self.html_title,
            "link": self.link,
            "display_link": self.display_link,
            "snippet": self.snippet,
            "html_snippet": self.html_snippet,
            "formatted_url": self.formatted_url,
            "html_formatted_url": self.html_formatted_url,
            "pagemap": self.pagemap,
        }


@dataclass
class BasicSearchResult:
    """Represents the result of a basic search operation."""

    query: str
    request_time: datetime
    finish_time: datetime
    execution_time: float
    success: bool
    error_message: str = ""
    response: Optional[List[BasicSearchResultItem]] = None

    def to_dict(self) -> dict:
        """Convert BasicSearchResult to a dictionary, including nested items and datetimes as ISO strings."""
        return {
            "query": self.query,
            "request_time": (
                self.request_time.isoformat() if self.request_time else None
            ),
            "finish_time": self.finish_time.isoformat() if self.finish_time else None,
            "execution_time": self.execution_time,
            "success": self.success,
            "error_message": self.error_message,
            "response": (
                [item.to_dict() for item in self.response] if self.response else None
            ),
        }
