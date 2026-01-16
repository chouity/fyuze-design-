from __future__ import annotations
from typing import List, Optional, Dict, Any
from pydantic import BaseModel, Field, HttpUrl, field_validator, ConfigDict
from datetime import datetime
from collections import Counter


# ---- Core models ----


class Profile(BaseModel):
    model_config = ConfigDict(extra="ignore")
    user_id: str = Field(alias="userID")
    username: str
    name: str
    platform: str
    url: HttpUrl
    country_code: Optional[str] = Field(default=None, alias="countryCode")
    gender: Optional[str] = None
    age_bracket: Optional[str] = Field(default=None, alias="age")


class PostDetails(BaseModel):
    model_config = ConfigDict(extra="ignore")
    post_id: str = Field(alias="postID")
    post_url: HttpUrl = Field(alias="postUrl")
    type: str
    date_iso: datetime = Field(alias="dateISO")

    likes: int
    comments: int
    video_views: int = Field(alias="videoViews")
    text_length: int = Field(alias="textLength")
    from_owner: bool = Field(alias="fromOwner")
    is_ad: bool = Field(alias="isAd")
    hashtags: List[str] = Field(default_factory=list, alias="hashTags")

    post_image: Optional[HttpUrl] = Field(default=None, alias="postImage")
    video_link: Optional[HttpUrl] = Field(default=None, alias="videoLink")

    @field_validator("video_link", "post_image", mode="before")
    @classmethod
    def empty_str_to_none(cls, v):
        return None if v in (None, "", "null", "None") else v


class PostStats(BaseModel):
    model_config = ConfigDict(extra="ignore")
    interactions: int
    er: float
    video_views_er: float = Field(alias="videoViewsER")
    main_grade: str = Field(alias="mainGrade")


class Post(BaseModel):
    model_config = ConfigDict(extra="ignore")
    details: PostDetails = Field(alias="postDetails")
    stats: PostStats = Field(alias="postStats")


class FeedSnapshot(BaseModel):
    model_config = ConfigDict(extra="ignore")
    profile: Profile
    period: Optional[str] = None
    posts: List[Post]

    total_posts: int
    avg_er: float
    median_er: float
    type_breakdown: Dict[str, int]
    top_hashtags: List[str]
    best_by_er_id: Optional[str]
    best_by_interactions_id: Optional[str]

    @staticmethod
    def _median(vals: List[float]) -> float:
        n = len(vals)
        if not n:
            return 0.0
        s = sorted(vals)
        mid = n // 2
        return float(s[mid]) if n % 2 else float((s[mid - 1] + s[mid]) / 2.0)

    @classmethod
    def from_raw(cls, raw: Dict[str, Any], top_hashtags_n: int = 10) -> "FeedSnapshot":
        profile = Profile(**raw["profile"])
        posts = [Post(**p) for p in raw.get("posts", [])]

        ers = [p.stats.er for p in posts]
        total_posts = len(posts)
        avg_er = float(sum(ers) / total_posts) if total_posts else 0.0
        median_er = cls._median(ers)

        type_counts = Counter(p.details.type for p in posts)

        all_tags: List[str] = []
        for p in posts:
            all_tags.extend(
                [t.strip().lstrip("#").lower() for t in (p.details.hashtags or [])]
            )
        top_hashtags = [t for t, _ in Counter(all_tags).most_common(top_hashtags_n)]

        best_by_er = max(posts, key=lambda p: p.stats.er, default=None)
        best_by_interactions = max(
            posts, key=lambda p: p.stats.interactions, default=None
        )

        period = (raw.get("about") or {}).get("period")

        return cls(
            profile=profile,
            period=period,
            posts=posts,
            total_posts=total_posts,
            avg_er=avg_er,
            median_er=median_er,
            type_breakdown=dict(type_counts),
            top_hashtags=top_hashtags,
            best_by_er_id=best_by_er.details.post_id if best_by_er else None,
            best_by_interactions_id=(
                best_by_interactions.details.post_id if best_by_interactions else None
            ),
        )
