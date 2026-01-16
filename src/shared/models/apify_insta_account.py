from dataclasses import dataclass, field
from typing import List, Optional, Dict, Any
from datetime import datetime


# --------- Leaf models ---------
@dataclass
class ExternalUrl:
    url: str
    title: Optional[str] = None
    lynx_url: Optional[str] = None
    link_type: Optional[str] = None
    # Original JSON
    raw: Dict[str, Any] = field(default_factory=dict, repr=False)

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> "ExternalUrl":
        return cls(
            url=data.get("url", ""),
            title=data.get("title"),
            lynx_url=data.get("lynx_url"),
            link_type=data.get("link_type"),
            raw=dict(data) if isinstance(data, dict) else {},
        )

    def to_dict(self) -> Dict[str, Any]:
        return {
            "title": self.title,
            "lynx_url": self.lynx_url,
            "url": self.url,
            "link_type": self.link_type,
        }

    def to_agent_dict(self) -> Dict[str, Any]:
        return {
            "title": self.title,
            "url": self.url,
        }


@dataclass
class TaggedUser:
    id: str
    username: str
    full_name: Optional[str] = None
    is_verified: Optional[bool] = None
    profile_pic_url: Optional[str] = None
    raw: Dict[str, Any] = field(default_factory=dict, repr=False)

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> "TaggedUser":
        return cls(
            id=str(data.get("id", "")),
            username=data.get("username", ""),
            full_name=data.get("full_name"),
            is_verified=data.get("is_verified"),
            profile_pic_url=data.get("profile_pic_url"),
            raw=dict(data) if isinstance(data, dict) else {},
        )

    def to_dict(self) -> Dict[str, Any]:
        return {
            "full_name": self.full_name,
            "id": self.id,
            "is_verified": self.is_verified,
            "profile_pic_url": self.profile_pic_url,
            "username": self.username,
        }


@dataclass
class RelatedProfile:
    id: str
    username: str
    full_name: Optional[str] = None
    is_private: Optional[bool] = None
    is_verified: Optional[bool] = None
    profile_pic_url: Optional[str] = None
    raw: Dict[str, Any] = field(default_factory=dict, repr=False)

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> "RelatedProfile":
        return cls(
            id=str(data.get("id", "")),
            username=data.get("username", ""),
            full_name=data.get("full_name"),
            is_private=data.get("is_private"),
            is_verified=data.get("is_verified"),
            profile_pic_url=data.get("profile_pic_url"),
            raw=dict(data) if isinstance(data, dict) else {},
        )

    def to_dict(self) -> Dict[str, Any]:
        return {
            "id": self.id,
            "username": self.username,
            "full_name": self.full_name,
            "is_private": self.is_private,
            "is_verified": self.is_verified,
            "profile_pic_url": self.profile_pic_url,
        }


# --------- Post model ---------
@dataclass
class Post:
    id: str
    type: str
    short_code: Optional[str] = None
    caption: Optional[str] = None
    hashtags: List[str] = field(default_factory=list)
    mentions: List[str] = field(default_factory=list)
    url: Optional[str] = None
    comments_count: Optional[int] = None
    likes_count: Optional[int] = None
    video_view_count: Optional[int] = None
    timestamp: Optional[str] = None  # keep as ISO string for simplicity

    # Media
    display_url: Optional[str] = None
    video_url: Optional[str] = None
    images: List[str] = field(default_factory=list)
    dimensions_height: Optional[int] = None
    dimensions_width: Optional[int] = None
    alt: Optional[str] = None

    # Meta
    location_name: Optional[str] = None
    location_id: Optional[str] = None
    owner_username: Optional[str] = None
    owner_id: Optional[str] = None
    product_type: Optional[str] = None
    tagged_users: List[TaggedUser] = field(default_factory=list)
    child_posts: List["Post"] = field(default_factory=list)
    is_comments_disabled: Optional[bool] = None
    raw: Dict[str, Any] = field(default_factory=dict, repr=False)

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> "Post":
        tagged = [
            TaggedUser.from_dict(u)
            for u in data.get("taggedUsers", [])
            if isinstance(u, dict)
        ]

        # Recursively parse child posts if present
        children = [
            Post.from_dict(p) for p in data.get("childPosts", []) if isinstance(p, dict)
        ]

        return cls(
            id=str(data.get("id", "")),
            type=data.get("type", "Image"),
            short_code=data.get("shortCode"),
            caption=data.get("caption"),
            hashtags=list(data.get("hashtags", []) or []),
            mentions=list(data.get("mentions", []) or []),
            url=data.get("url"),
            comments_count=data.get("commentsCount"),
            likes_count=data.get("likesCount"),
            video_view_count=data.get("videoViewCount"),
            timestamp=data.get("timestamp"),
            display_url=data.get("displayUrl"),
            video_url=data.get("videoUrl"),
            images=list(data.get("images", []) or []),
            dimensions_height=data.get("dimensionsHeight"),
            dimensions_width=data.get("dimensionsWidth"),
            alt=data.get("alt"),
            location_name=data.get("locationName"),
            location_id=data.get("locationId"),
            owner_username=data.get("ownerUsername"),
            owner_id=data.get("ownerId"),
            product_type=data.get("productType"),
            tagged_users=tagged,
            child_posts=children,
            is_comments_disabled=data.get("isCommentsDisabled"),
            raw=dict(data) if isinstance(data, dict) else {},
        )

    def to_dict(self) -> Dict[str, Any]:
        return {
            "id": self.id,
            "type": self.type,
            "shortCode": self.short_code,
            "caption": self.caption,
            "hashtags": list(self.hashtags),
            "mentions": list(self.mentions),
            "url": self.url,
            "commentsCount": self.comments_count,
            "likesCount": self.likes_count,
            "videoViewCount": self.video_view_count,
            "timestamp": self.timestamp,
            "displayUrl": self.display_url,
            "videoUrl": self.video_url,
            "images": list(self.images),
            "dimensionsHeight": self.dimensions_height,
            "dimensionsWidth": self.dimensions_width,
            "alt": self.alt,
            "locationName": self.location_name,
            "locationId": self.location_id,
            "ownerUsername": self.owner_username,
            "ownerId": self.owner_id,
            "productType": self.product_type,
            "taggedUsers": [u.to_dict() for u in self.tagged_users],
            "childPosts": [c.to_dict() for c in self.child_posts],
            "isCommentsDisabled": self.is_comments_disabled,
        }

    def to_agent_dict(self) -> Dict[str, Any]:
        return {
            "type": self.type,
            "caption": self.caption,
            "hashtags": list(self.hashtags),
            "url": self.url,
            "commentsCount": self.comments_count,
            "likesCount": self.likes_count,
            "videoViewCount": self.video_view_count,
            "timestamp": self.timestamp,
            "displayUrl": self.display_url,
            "alt": self.alt,
            "locationName": self.location_name,
            "ownerUsername": self.owner_username,
            "productType": self.product_type,
        }


# --------- Main model ---------
@dataclass
class ApifyInstaAccount:
    # IDs and basic profile
    _id: str
    url: str
    username: str
    full_name: Optional[str] = None
    biography: Optional[str] = None

    # Stats
    followers_count: Optional[int] = None
    follows_count: Optional[int] = None
    posts_count: Optional[int] = None

    # Status / business
    verified: Optional[bool] = None
    is_business_account: Optional[bool] = None
    business_category_name: Optional[str] = None
    has_channel: Optional[bool] = None
    highlight_reel_count: Optional[int] = None
    igtv_video_count: Optional[int] = None

    # Links / images
    profile_pic_url: Optional[str] = None
    profile_pic_url_hd: Optional[str] = None
    external_url: Optional[str] = None
    external_urls: List[ExternalUrl] = field(default_factory=list)

    # Connections & content
    related_profiles: List[RelatedProfile] = field(default_factory=list)
    latest_igtv_videos: List[Post] = field(default_factory=list)
    latest_posts: List[Post] = field(default_factory=list)

    # Metadata
    input_url: Optional[str] = None
    raw: Dict[str, Any] = field(default_factory=dict, repr=False)

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> "ApifyInstaAccount":
        # External URLs
        ext_urls = [
            ExternalUrl.from_dict(u)
            for u in data.get("externalUrls", [])
            if isinstance(u, dict)
        ]

        # Related profiles
        related = [
            RelatedProfile.from_dict(p)
            for p in data.get("relatedProfiles", [])
            if isinstance(p, dict)
        ]

        # Posts
        latest_posts = [
            Post.from_dict(p)
            for p in data.get("latestPosts", [])
            if isinstance(p, dict)
        ]
        latest_igtv = [
            Post.from_dict(p)
            for p in data.get("latestIgtvVideos", [])
            if isinstance(p, dict)
        ]

        return cls(
            _id=str(data.get("id", "")),
            url=data.get("url", ""),
            username=data.get("username", ""),
            full_name=data.get("fullName"),
            biography=data.get("biography"),
            followers_count=data.get("followersCount"),
            follows_count=data.get("followsCount"),
            posts_count=data.get("postsCount"),
            verified=data.get("verified"),
            is_business_account=data.get("isBusinessAccount"),
            business_category_name=data.get("businessCategoryName"),
            has_channel=data.get("hasChannel"),
            highlight_reel_count=data.get("highlightReelCount"),
            igtv_video_count=data.get("igtvVideoCount"),
            profile_pic_url=data.get("profilePicUrl"),
            profile_pic_url_hd=data.get("profilePicUrlHD"),
            external_url=data.get("externalUrl"),
            external_urls=ext_urls,
            related_profiles=related,
            latest_igtv_videos=latest_igtv,
            latest_posts=latest_posts,
            input_url=data.get("inputUrl"),
            raw=dict(data) if isinstance(data, dict) else {},
        )

    def to_dict(self) -> Dict[str, Any]:
        return {
            "inputUrl": self.input_url,
            "id": self._id,
            "username": self.username,
            "url": self.url,
            "fullName": self.full_name,
            "biography": self.biography,
            "externalUrls": [u.to_dict() for u in self.external_urls],
            "externalUrl": self.external_url,
            "followersCount": self.followers_count,
            "followsCount": self.follows_count,
            "hasChannel": self.has_channel,
            "highlightReelCount": self.highlight_reel_count,
            "isBusinessAccount": self.is_business_account,
            "businessCategoryName": self.business_category_name,
            "verified": self.verified,
            "profilePicUrl": self.profile_pic_url,
            "profilePicUrlHD": self.profile_pic_url_hd,
            "igtvVideoCount": self.igtv_video_count,
            "relatedProfiles": [p.to_dict() for p in self.related_profiles],
            "latestIgtvVideos": [p.to_dict() for p in self.latest_igtv_videos],
            "postsCount": self.posts_count,
            "latestPosts": [p.to_dict() for p in self.latest_posts],
        }

    def to_agent_dict(self) -> Dict[str, Any]:
        return {
            "username": self.username,
            "url": self.url,
            "fullName": self.full_name,
            "biography": self.biography,
            "externalUrls": [u.to_agent_dict() for u in self.external_urls],
            "externalUrl": self.external_url,
            "followersCount": self.followers_count,
            "followsCount": self.follows_count,
            "latest_posts": [p.to_agent_dict() for p in self.latest_posts],
            "engagementRate": self.get_engagement_rate(),
        }

    def get_engagement_rate(self, max_posts: int = 12) -> Optional[float]:
        """Compute Instagram ER by followers over recent posts.

        - Uses up to `max_posts` most recent items from latest_posts + latest_igtv_videos.
        - Engagement per post = likes_count + (comments_count or 0).
        - ER (%) = average of per-post ((likes + comments) / followers_count * 100).
        - Returns None if followers_count is missing/zero or there are no valid posts.
        """
        if not self.followers_count or self.followers_count <= 0:
            return None

        # Merge posts from feed + IGTV and deduplicate by post id
        all_posts: List[Post] = list(self.latest_posts or []) + list(
            self.latest_igtv_videos or []
        )
        seen: set[str] = set()
        unique_posts: List[Post] = []
        for p in all_posts:
            pid = getattr(p, "id", None)
            if not pid or pid in seen:
                continue
            seen.add(pid)
            unique_posts.append(p)

        if not unique_posts:
            return None

        # Sort by timestamp desc when possible

        def _parse_ts(ts: Any) -> Optional[datetime]:
            if ts is None:
                return None
            # Support ISO string or epoch seconds (int/str)
            try:
                if isinstance(ts, (int, float)):
                    return datetime.fromtimestamp(ts)
                if isinstance(ts, str):
                    # Try ISO first
                    try:
                        return datetime.fromisoformat(ts.replace("Z", "+00:00"))
                    except Exception:
                        # Maybe epoch in string
                        v = float(ts)
                        return datetime.fromtimestamp(v)
            except Exception:
                return None
            return None

        unique_posts.sort(
            key=lambda p: (_parse_ts(getattr(p, "timestamp", None)) or datetime.min),
            reverse=True,
        )

        # Take up to max_posts with valid like metrics
        valid_rates: List[float] = []
        for p in unique_posts:
            if len(valid_rates) >= max_posts:
                break
            likes = getattr(p, "likes_count", None)
            if likes is None:
                continue
            comments = getattr(p, "comments_count", 0) or 0
            engagement = likes + comments
            # Per-post ER by followers (%)
            rate = (engagement / self.followers_count) * 100.0
            valid_rates.append(rate)

        if not valid_rates:
            return None

        # Average ER across posts; round to 2 decimals for stability
        return round(sum(valid_rates) / len(valid_rates), 2)
