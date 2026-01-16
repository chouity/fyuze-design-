from dataclasses import dataclass, field
from typing import Optional, List
from datetime import datetime


def _truncate(content: str, max_length: int) -> str:
    if not content or len(content) <= max_length:
        return content
    half = (max_length - 3) // 2
    return content[:half] + "..." + content[-half:]


@dataclass
class TikTokVideo:
    aweme_id: str
    desc: Optional[str]
    create_time: int
    video_duration: int
    like_count: int
    comment_count: int
    share_count: int
    play_count: int
    collect_count: int
    author_uid: str
    author_unique_id: str
    video_url: Optional[str]
    cover_url: Optional[str]
    music_title: Optional[str]
    music_author: Optional[str]

    @classmethod
    def from_dict(cls, data: dict) -> "TikTokVideo":
        """Create TikTokVideo from aweme_info dict"""
        statistics = data.get("statistics", {})
        author = data.get("author", {})
        music = data.get("music", {})
        video = data.get("video", {})

        # Extract video URL from video data structure
        video_url = None
        if video and "play_addr" in video:
            play_addr = video["play_addr"]
            if "url_list" in play_addr and play_addr["url_list"]:
                video_url = play_addr["url_list"][0]

        # Extract cover URL
        cover_url = None
        if video and "cover" in video:
            cover = video["cover"]
            if "url_list" in cover and cover["url_list"]:
                cover_url = cover["url_list"][0]

        return cls(
            aweme_id=str(data.get("aweme_id", "")),
            desc=data.get("desc", ""),
            create_time=int(data.get("create_time", 0)),
            video_duration=int(video.get("duration", 0)) if video else 0,
            like_count=int(statistics.get("digg_count", 0)),
            comment_count=int(statistics.get("comment_count", 0)),
            share_count=int(statistics.get("share_count", 0)),
            play_count=int(statistics.get("play_count", 0)),
            collect_count=int(statistics.get("collect_count", 0)),
            author_uid=str(author.get("uid", "")),
            author_unique_id=str(author.get("unique_id", "")),
            video_url=video_url,
            cover_url=cover_url,
            music_title=music.get("title") if music else None,
            music_author=music.get("author") if music else None,
        )

    def to_dict(self) -> dict:
        return {
            "aweme_id": self.aweme_id,
            "desc": self.desc,
            "create_time": self.create_time,
            "video_duration": self.video_duration,
            "like_count": self.like_count,
            "comment_count": self.comment_count,
            "share_count": self.share_count,
            "play_count": self.play_count,
            "collect_count": self.collect_count,
            "author_uid": self.author_uid,
            "author_unique_id": self.author_unique_id,
            "video_url": self.video_url,
            "cover_url": self.cover_url,
            "music_title": self.music_title,
            "music_author": self.music_author,
        }

    def to_agent_dict(self) -> dict:
        """Simplified dict for agent consumption with key metrics."""
        return {
            "caption": _truncate(self.desc or "", 300),
            "taken_at_timestamp": self.create_time,
            "video_duration": self.video_duration,
            "like_count": self.like_count,
            "comment_count": self.comment_count,
            "share_count": self.share_count,
            "video_view_count": self.play_count,
            "owner_username": self.author_unique_id,
        }


@dataclass
class TikTokVideos:
    videos: List[TikTokVideo]
    count: int

    @classmethod
    def from_dict(cls, data: List[dict]) -> "TikTokVideos":
        """Create from list of aweme_info dicts"""
        videos = [TikTokVideo.from_dict(video_data) for video_data in data]
        return cls(videos=videos, count=len(videos))

    def to_dict(self) -> dict:
        return {
            "count": self.count,
            "videos": [v.to_dict() for v in self.videos],
        }


@dataclass
class EnsembleTiktokAccount:
    uid: str
    unique_id: str
    nickname: str
    signature: Optional[str] = None
    follower_count: int = 0
    following_count: int = 0
    total_favorited: int = 0
    aweme_count: int = 0
    region: Optional[str] = None
    birthday: Optional[str] = None
    verification_type: int = 0
    is_verified: bool = False
    avatar_url: Optional[str] = None
    videos: TikTokVideos = field(
        default_factory=lambda: TikTokVideos(videos=[], count=0)
    )
    raw_data: dict = field(default_factory=dict)

    @classmethod
    def from_dict(
        cls, data: dict, videos_data: Optional[List[dict]] = None
    ) -> "EnsembleTiktokAccount":
        """
        Build from TikTok user/author JSON data.
        videos_data should be a list of aweme_info dicts if available.
        """

        # Extract avatar URL from avatar_larger structure
        avatar_url = None
        avatar_larger = data.get("avatar_larger", {})
        if isinstance(avatar_larger, dict) and "url_list" in avatar_larger:
            url_list = avatar_larger["url_list"]
            if url_list and len(url_list) > 0:
                avatar_url = url_list[0]

        # Handle videos if provided
        videos_obj = TikTokVideos(videos=[], count=0)
        if videos_data:
            videos_obj = TikTokVideos.from_dict(videos_data)

        return cls(
            uid=str(data.get("uid", "")),
            unique_id=str(data.get("unique_id", "")),
            nickname=str(data.get("nickname", "")),
            signature=data.get("signature"),
            follower_count=int(data.get("follower_count", 0)),
            following_count=int(data.get("following_count", 0)),
            total_favorited=int(data.get("total_favorited", 0)),
            aweme_count=int(data.get("aweme_count", 0)),
            region=data.get("region"),
            birthday=data.get("birthday"),
            verification_type=int(data.get("verification_type", 0)),
            is_verified=int(data.get("verification_type", 0)) > 0,
            avatar_url=avatar_url,
            videos=videos_obj,
            raw_data=data,
        )

    @classmethod
    def from_direct_dict(
        cls, payload: dict, videos_data: Optional[List[dict]] = None
    ) -> "EnsembleTiktokAccount":
        """
        Build from a direct TikTok payload containing "user" and "stats" blocks.

        Args:
            payload: Dictionary structured like the direct response (see attachment).
            videos_data: Optional list of aweme/video dictionaries to attach.

        Returns:
            EnsembleTiktokAccount populated with available information.
        """

        user = payload.get("user", {}) or {}
        stats = payload.get("stats", {}) or {}

        def _safe_int(value: Optional[object], default: int = 0) -> int:
            try:
                if value is None:
                    return default
                if isinstance(value, bool):
                    return int(value)
                return int(value)
            except (TypeError, ValueError):
                return default

        # Gather possible avatar URLs and normalize to the structure expected by from_dict
        avatar_candidates: List[str] = []
        avatar_larger = user.get("avatar_larger")
        if isinstance(avatar_larger, dict):
            avatar_candidates.extend(avatar_larger.get("url_list", []) or [])
        elif isinstance(avatar_larger, str) and avatar_larger:
            avatar_candidates.append(avatar_larger)

        for key in ("avatarLarger", "avatarMedium", "avatarThumb"):
            value = user.get(key)
            if isinstance(value, str) and value:
                avatar_candidates.append(value)
            elif isinstance(value, dict):
                avatar_candidates.extend(value.get("url_list", []) or [])

        normalized = {
            "uid": user.get("id") or user.get("uid") or "",
            "unique_id": user.get("uniqueId")
            or user.get("unique_id")
            or user.get("secUid")
            or "",
            "nickname": user.get("nickname", ""),
            "signature": user.get("signature"),
            "follower_count": _safe_int(
                stats.get("followerCount")
                or user.get("followerCount")
                or user.get("follower_count"),
            ),
            "following_count": _safe_int(
                stats.get("followingCount")
                or user.get("followingCount")
                or user.get("following_count"),
            ),
            "total_favorited": _safe_int(
                stats.get("heartCount")
                or stats.get("heart")
                or user.get("totalFavorited")
                or user.get("total_favorited"),
            ),
            "aweme_count": _safe_int(
                stats.get("videoCount")
                or user.get("videoCount")
                or user.get("aweme_count"),
            ),
            "region": user.get("region") or user.get("account_region"),
            "birthday": user.get("birthday"),
            "verification_type": _safe_int(user.get("verification_type")),
            "is_verified": bool(user.get("verified")),
            "avatar_larger": (
                {"url_list": avatar_candidates} if avatar_candidates else {}
            ),
        }

        account = cls.from_dict(normalized, videos_data)
        account.raw_data = payload
        return account

    def to_dict(self) -> dict:
        return {
            "uid": self.uid,
            "unique_id": self.unique_id,
            "nickname": self.nickname,
            "signature": self.signature,
            "follower_count": self.follower_count,
            "following_count": self.following_count,
            "total_favorited": self.total_favorited,
            "aweme_count": self.aweme_count,
            "region": self.region,
            "birthday": self.birthday,
            "verification_type": self.verification_type,
            "is_verified": self.is_verified,
            "avatar_url": self.avatar_url,
            "videos": self.videos.to_dict(),
            "engagementRate": self.get_engagement_rate(),
            "raw_data": self.raw_data,
        }

    def get_engagement_rate(self, max_videos: int = 12) -> Optional[float]:
        """Compute TikTok ER by followers over recent videos.

        - Uses up to `max_videos` most recent videos.
        - Engagement per video = like_count + comment_count + share_count.
        - ER (%) = average of per-video ((likes + comments + shares) / followers * 100).
        - Returns None if followers is missing/zero or there are no valid videos.
        """
        if not self.follower_count or self.follower_count <= 0:
            return None

        all_videos = self.videos.videos if self.videos else []

        if not all_videos:
            return None

        # Sort by timestamp desc (most recent first)
        def _parse_ts(ts: Optional[int]) -> datetime:
            if ts is None:
                return datetime.min
            try:
                return datetime.fromtimestamp(ts)
            except Exception:
                return datetime.min

        sorted_videos = sorted(
            all_videos,
            key=lambda v: _parse_ts(v.create_time),
            reverse=True,
        )

        # Take up to max_videos with valid engagement metrics
        valid_rates: List[float] = []
        for video in sorted_videos:
            if len(valid_rates) >= max_videos:
                break

            # TikTok engagement includes likes, comments, and shares
            likes = video.like_count or 0
            comments = video.comment_count or 0
            shares = video.share_count or 0
            engagement = likes + comments + shares

            # Per-video ER by followers (%)
            rate = (engagement / self.follower_count) * 100.0
            valid_rates.append(rate)

        if not valid_rates:
            return None

        # Average ER across videos; round to 2 decimals for stability
        return round(sum(valid_rates) / len(valid_rates), 2)

    def to_agent_dict(self) -> dict:
        """Simplified dict for agent consumption with key metrics."""
        return {
            "username": self.unique_id,
            "full_name": self.nickname,
            "bio": self.signature,
            "followers": self.follower_count,
            "following": self.following_count,
            "region": self.region,
            "is_verified": self.is_verified,
            "posts_count": self.videos.count if self.videos else 0,
            "engagementRate": self.get_engagement_rate(),
            "posts": (
                [v.to_agent_dict() for v in self.videos.videos[:6]]
                if self.videos
                else []
            ),
        }

    def __eq__(self, other) -> bool:
        """Two accounts are equal if they have the same unique_id."""
        if not isinstance(other, EnsembleTiktokAccount):
            return False
        return self.unique_id == other.unique_id

    def __hash__(self) -> int:
        """Hash based on unique_id so accounts with same unique_id are treated as identical in sets."""
        return hash(self.unique_id)
