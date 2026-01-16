from typing import List, Optional, Literal

from pydantic import BaseModel, HttpUrl, Field


class WebsiteSummary(BaseModel):
    """
    Structured summary of a website extracted from its content.

    This model is intended as the response schema for website analysis.
    """

    url: HttpUrl = Field(..., description="The URL of the website being summarized")
    name: Optional[str] = Field(None, description="The business or organization name")
    type: Literal[
        "e-commerce", "ngo", "blog", "portfolio", "news", "company", "other"
    ] = Field(..., description="The general type of the website")
    industry: Optional[str] = Field(
        None, description="The industry or domain the website belongs to"
    )
    services: List[str] = Field(
        default_factory=list,
        description="List of services or offerings found on the website",
    )
    mission: Optional[str] = Field(
        None, description="The mission or purpose of the business/organization"
    )
    contact_info: Optional[str] = Field(
        None, description="Contact details or summary of contact options"
    )
    summary_markdown: Optional[str] = Field(
        None, description="A summarized description of the website in Markdown format"
    )
