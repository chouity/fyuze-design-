from pydantic import BaseModel, Field, HttpUrl
from typing import List, Optional, Literal
from src.shared.enums.platform import Platform


class BasicSearchRequest(BaseModel):
    query: str
    gl: str | None = None


class FyuzeRequest(BaseModel):
    message: str
    user_id: str
    session_id: str


class Influencer(BaseModel):
    """
    A model representing an influencer.
    """

    username: str = Field(..., description="The influencer's username.")
    url: str = Field(..., description="The influencer's profile URL.")
    fullName: str = Field(..., description="The influencer's full name.")
    biography: str = Field(..., description="A brief biography of the influencer.")
    profilePicUrl: str = Field(
        ..., description="The URL to the influencer's profile picture."
    )
    followersCount: int = Field(
        ..., description="The number of followers the influencer has."
    )


class FyuzeResponse(BaseModel):
    """
    A model representing the response from the Fyuze API.
    """

    text: str = Field(
        ..., description="Only the text received from the previous agent."
    )
    role: Literal["assistant", "tool", "system", "user"] = Field(
        "assistant",
        description="The role of the speaker for this message. Defaults to 'assistant'.",
    )
    influencers_found: Optional[List[dict]] = Field(
        default=None,
        description="A list of influencers found based on the user's request.",
    )  # type: ignore


class FyuzeModel(BaseModel):
    """
    A model representing the response from the Fyuze API.
    """

    text: str = Field(
        ..., description="Only the text received from the previous agent."
    )
    role: Literal["assistant", "tool", "system", "user"] = Field(
        "assistant",
        description="The role of the agent message that was parsed."
        " Typically 'assistant' unless relaying direct tool output.",
    )
    influencers_usernames: List[str] = Field(
        default_factory=list,
        description="A list of influencers usernames found based on the user's request. If not found return an empty list.",
    )
    platform: Optional[Platform] = Field(
        default=None,
        description="The platform of the influencers found (e.g., Instagram, TikTok). If not found return null",
    )


class SearchInstaRequest(BaseModel):
    topic: str
    location: str
    keywords: List[str]
    search_results: Optional[int] = Field(
        10, description="Number of search results to return (max 10)"
    )


class WebsiteUrlRequest(BaseModel):
    url: HttpUrl
