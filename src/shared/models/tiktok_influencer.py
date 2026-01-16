from dataclasses import dataclass, field
from typing import List, Optional, Dict, Any, Tuple, Union
import re
import json


# --------- Leaf models ---------
@dataclass
class TikTokAuthorMeta:
    id: Optional[str] = None
    name: Optional[str] = None  # TikTok handle without '@'
    nick_name: Optional[str] = None
    verified: Optional[bool] = None
    signature: Optional[str] = None
    bio_link: Optional[str] = None
    profile_url: Optional[str] = None
    avatar: Optional[str] = None
    fans: Optional[int] = None  # followers
    heart: Optional[int] = None  # total likes across profile
    video: Optional[int] = None  # number of posted videos
    raw: Dict[str, Any] = field(default_factory=dict, repr=False)

    @classmethod
    def from_source(cls, data: Dict[str, Any]) -> "TikTokAuthorMeta":
        if not isinstance(data, dict):
            return cls()
        nested = (
            data.get("authorMeta") if isinstance(data.get("authorMeta"), dict) else None
        )
        g = nested or data
        return cls(
            id=str(g.get("id")) if g.get("id") is not None else None,
            name=g.get("name")
            or data.get("authorMeta.name")
            or data.get("author_name"),
            nick_name=g.get("nickName") or data.get("authorMeta.nickName"),
            verified=(
                g.get("verified")
                if "verified" in g
                else data.get("authorMeta.verified")
            ),
            signature=g.get("signature"),
            bio_link=g.get("bioLink"),
            profile_url=g.get("profileUrl"),
            avatar=g.get("avatar")
            or data.get("authorMeta.avatar")
            or data.get("author_avatar"),
            fans=g.get("fans"),
            heart=g.get("heart"),
            video=g.get("video"),
            raw=dict(nested or {}),
        )

    def to_dict(self) -> Dict[str, Any]:
        return {
            "id": self.id,
            "name": self.name,
            "nickName": self.nick_name,
            "verified": self.verified,
            "signature": self.signature,
            "bioLink": self.bio_link,
            "profileUrl": self.profile_url,
            "avatar": self.avatar,
            "fans": self.fans,
            "heart": self.heart,
            "video": self.video,
        }


@dataclass
class TikTokVideoMeta:
    height: Optional[int] = None
    width: Optional[int] = None
    duration: Optional[int] = None  # seconds
    cover_url: Optional[str] = None
    original_cover_url: Optional[str] = None
    definition: Optional[str] = None
    format: Optional[str] = None
    raw: Dict[str, Any] = field(default_factory=dict, repr=False)

    @classmethod
    def from_source(cls, data: Dict[str, Any]) -> "TikTokVideoMeta":
        if not isinstance(data, dict):
            return cls()
        nested = (
            data.get("videoMeta") if isinstance(data.get("videoMeta"), dict) else None
        )
        g = nested or {}
        return cls(
            height=g.get("height"),
            width=g.get("width"),
            duration=g.get("duration") or data.get("videoMeta.duration"),
            cover_url=g.get("coverUrl"),
            original_cover_url=g.get("originalCoverUrl"),
            definition=g.get("definition"),
            format=g.get("format"),
            raw=dict(nested or {}),
        )

    def to_dict(self) -> Dict[str, Any]:
        return {
            "height": self.height,
            "width": self.width,
            "duration": self.duration,
            "coverUrl": self.cover_url,
            "originalCoverUrl": self.original_cover_url,
            "definition": self.definition,
            "format": self.format,
        }


@dataclass
class TikTokMusicMeta:
    music_name: Optional[str] = None
    music_author: Optional[str] = None
    music_original: Optional[bool] = None
    play_url: Optional[str] = None
    cover_medium_url: Optional[str] = None
    original_cover_medium_url: Optional[str] = None
    music_id: Optional[str] = None
    raw: Dict[str, Any] = field(default_factory=dict, repr=False)

    @classmethod
    def from_source(cls, data: Dict[str, Any]) -> "TikTokMusicMeta":
        if not isinstance(data, dict):
            return cls()
        nested = (
            data.get("musicMeta") if isinstance(data.get("musicMeta"), dict) else None
        )
        g = nested or {}
        return cls(
            music_name=g.get("musicName") or data.get("musicMeta.musicName"),
            music_author=g.get("musicAuthor") or data.get("musicMeta.musicAuthor"),
            music_original=g.get("musicOriginal")
            or data.get("musicMeta.musicOriginal"),
            play_url=g.get("playUrl"),
            cover_medium_url=g.get("coverMediumUrl"),
            original_cover_medium_url=g.get("originalCoverMediumUrl"),
            music_id=g.get("musicId"),
            raw=dict(nested or {}),
        )

    def to_dict(self) -> Dict[str, Any]:
        return {
            "musicName": self.music_name,
            "musicAuthor": self.music_author,
            "musicOriginal": self.music_original,
            "playUrl": self.play_url,
            "coverMediumUrl": self.cover_medium_url,
            "originalCoverMediumUrl": self.original_cover_medium_url,
            "musicId": self.music_id,
        }


@dataclass
class MentionedProfile:
    id: Optional[str] = None
    name: Optional[str] = None
    nick_name: Optional[str] = None
    profile_url: Optional[str] = None
    raw: Dict[str, Any] = field(default_factory=dict, repr=False)

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> "MentionedProfile":
        if not isinstance(data, dict):
            return cls()
        return cls(
            id=str(data.get("id")) if data.get("id") is not None else None,
            name=data.get("name"),
            nick_name=data.get("nickName"),
            profile_url=data.get("profileUrl"),
            raw=dict(data),
        )

    def to_dict(self) -> Dict[str, Any]:
        return {
            "id": self.id,
            "name": self.name,
            "nickName": self.nick_name,
            "profileUrl": self.profile_url,
        }


# --------- Post model ---------
@dataclass
class TikTokPost:
    id: Optional[str] = None
    text: Optional[str] = None
    hashtags: List[str] = field(default_factory=list)
    mentions: List[str] = field(default_factory=list)
    detailed_mentions: List[MentionedProfile] = field(default_factory=list)

    digg_count: Optional[int] = None  # likes
    share_count: Optional[int] = None
    play_count: Optional[int] = None
    comment_count: Optional[int] = None
    collect_count: Optional[int] = None  # saves/favorites

    create_time_iso: Optional[str] = None
    create_time: Optional[int] = None
    web_video_url: Optional[str] = None
    is_ad: Optional[bool] = None
    is_pinned: Optional[bool] = None
    is_sponsored: Optional[bool] = None
    is_slideshow: Optional[bool] = None
    media_urls: List[str] = field(default_factory=list)

    author: Optional[TikTokAuthorMeta] = None
    video_meta: Optional[TikTokVideoMeta] = None
    music_meta: Optional[TikTokMusicMeta] = None

    raw: Dict[str, Any] = field(default_factory=dict, repr=False)

    @staticmethod
    def _extract_id_from_url(url: Optional[str]) -> Optional[str]:
        if not url:
            return None
        m = re.search(r"/video/(\d+)", url)
        return m.group(1) if m else None

    @staticmethod
    def _parse_tags(text: Optional[str]) -> Tuple[List[str], List[str]]:
        if not text:
            return [], []
        hashtags = [h[1:] for h in re.findall(r"#[\w\d_]+", text)]
        mentions = [m[1:] for m in re.findall(r"@[\w\d_.]+", text)]
        return hashtags, mentions

    @classmethod
    def from_dict(cls, data: Union[Dict[str, Any], str]) -> "TikTokPost":
        # Accept JSON string data
        if isinstance(data, str):
            try:
                data = json.loads(data)
            except Exception:
                data = {}
        if not isinstance(data, dict):
            data = {}

        author = TikTokAuthorMeta.from_source(data)
        video = TikTokVideoMeta.from_source(data)
        music = TikTokMusicMeta.from_source(data)

        text = data.get("text")
        hashtags, mentions = cls._parse_tags(text)

        # Merge with provided hashtags/mentions arrays if present
        provided_hashtags: List[str] = []
        if isinstance(data.get("hashtags"), list):
            for h in data["hashtags"]:
                if isinstance(h, dict):
                    name = (h.get("name") or "").lstrip("#").strip()
                    if name:
                        provided_hashtags.append(name)
                elif isinstance(h, str):
                    name = h.lstrip("#").strip()
                    if name:
                        provided_hashtags.append(name)

        provided_mentions: List[str] = []
        if isinstance(data.get("mentions"), list):
            for m in data["mentions"]:
                if isinstance(m, str):
                    name = m.lstrip("@").strip()
                    if name:
                        provided_mentions.append(name)

        def _unique(seq: List[str]) -> List[str]:
            seen = set()
            out: List[str] = []
            for s in seq:
                key = s.lower()
                if key and key not in seen:
                    seen.add(key)
                    out.append(s)
            return out

        hashtags = _unique(list(hashtags) + provided_hashtags)
        mentions = _unique(list(mentions) + provided_mentions)

        detailed_mentions = []
        if isinstance(data.get("detailedMentions"), list):
            detailed_mentions = [
                MentionedProfile.from_dict(m)
                for m in data["detailedMentions"]
                if isinstance(m, dict)
            ]

        url = data.get("webVideoUrl") or data.get("url")

        return cls(
            id=(data.get("id") or cls._extract_id_from_url(url)),
            text=text,
            hashtags=hashtags,
            mentions=mentions,
            detailed_mentions=detailed_mentions,
            digg_count=data.get("diggCount"),
            share_count=data.get("shareCount"),
            play_count=data.get("playCount"),
            comment_count=data.get("commentCount"),
            collect_count=data.get("collectCount"),
            create_time_iso=data.get("createTimeISO") or data.get("create_time_iso"),
            create_time=data.get("createTime"),
            web_video_url=url,
            is_ad=data.get("isAd"),
            is_pinned=data.get("isPinned"),
            is_sponsored=data.get("isSponsored"),
            is_slideshow=data.get("isSlideshow"),
            media_urls=list(data.get("mediaUrls", []) or []),
            author=author,
            video_meta=video,
            music_meta=music,
            raw=dict(data) if isinstance(data, dict) else {},
        )

    def to_dict(self) -> Dict[str, Any]:
        return {
            "id": self.id,
            "text": self.text,
            "hashtags": list(self.hashtags),
            "mentions": list(self.mentions),
            "detailedMentions": [m.to_dict() for m in self.detailed_mentions],
            "diggCount": self.digg_count,
            "shareCount": self.share_count,
            "playCount": self.play_count,
            "commentCount": self.comment_count,
            "collectCount": self.collect_count,
            "createTimeISO": self.create_time_iso,
            "createTime": self.create_time,
            "webVideoUrl": self.web_video_url,
            "isAd": self.is_ad,
            "isPinned": self.is_pinned,
            "isSponsored": self.is_sponsored,
            "isSlideshow": self.is_slideshow,
            "mediaUrls": list(self.media_urls),
            "authorMeta": self.author.to_dict() if self.author else None,
            "videoMeta": self.video_meta.to_dict() if self.video_meta else None,
            "musicMeta": self.music_meta.to_dict() if self.music_meta else None,
        }


# --------- Main model ---------
@dataclass
class TikTokInfluencer:
    # IDs and basic profile
    _id: str
    url: str
    username: str
    full_name: Optional[str] = None
    biography: Optional[str] = None

    # Stats
    followers_count: Optional[int] = None
    posts_count: Optional[int] = None
    hearts_count: Optional[int] = None

    # Status
    verified: Optional[bool] = None

    # Links / images
    profile_pic_url: Optional[str] = None
    external_url: Optional[str] = None

    # Content
    latest_posts: List[TikTokPost] = field(default_factory=list)

    # Metadata
    input_url: Optional[str] = None
    raw: Any = field(default_factory=dict, repr=False)

    @classmethod
    def from_posts(
        cls,
        posts: List[Union[Dict[str, Any], TikTokPost, str]],
        input_url: Optional[str] = None,
    ) -> "TikTokInfluencer":
        # Normalize to TikTokPost
        parsed_posts: List[TikTokPost] = []
        for item in posts:
            if isinstance(item, TikTokPost):
                parsed_posts.append(item)
            elif isinstance(item, dict) or isinstance(item, str):
                try:
                    parsed_posts.append(TikTokPost.from_dict(item))
                except Exception:
                    continue
            else:
                continue

        parsed_posts = [p for p in parsed_posts if p and p.author and p.author.name]
        if not parsed_posts:
            raise ValueError("No valid posts to build influencer")

        # Ensure all posts are from the same author
        authors = {
            (p.author.name if p.author else None, p.author.avatar if p.author else None)
            for p in parsed_posts
        }
        if len(authors) != 1:
            raise ValueError(
                "Posts belong to multiple authors; group by author before building influencer"
            )

        ((username, avatar),) = authors
        username = username or ""
        # Pull richer author fields from first valid post
        author_meta = next(
            (p.author for p in parsed_posts if p.author), TikTokAuthorMeta()
        )
        url = author_meta.profile_url or (
            f"https://www.tiktok.com/@{username}" if username else ""
        )

        return cls(
            _id=(author_meta.id or username or ""),
            url=url,
            username=username,
            full_name=author_meta.nick_name,
            biography=author_meta.signature,
            followers_count=author_meta.fans,
            posts_count=author_meta.video or len(parsed_posts),
            hearts_count=author_meta.heart,
            verified=author_meta.verified,
            profile_pic_url=avatar,
            external_url=author_meta.bio_link,
            latest_posts=parsed_posts,
            input_url=input_url,
            raw=[p.raw for p in parsed_posts],
        )

    def to_dict(self) -> Dict[str, Any]:
        return {
            "inputUrl": self.input_url,
            "id": self._id,
            "username": self.username,
            "url": self.url,
            "fullName": self.full_name,
            "biography": self.biography,
            "profilePicUrl": self.profile_pic_url,
            "followersCount": self.followers_count,
            "postsCount": (
                self.posts_count
                if self.posts_count is not None
                else len(self.latest_posts)
            ),
            "heartsCount": self.hearts_count,
            "verified": self.verified,
            "externalUrl": self.external_url,
            "latestPosts": [p.to_dict() for p in self.latest_posts],
        }

    def get_engagement_rate(self) -> Optional[float]:
        if (
            not self.latest_posts
            or not self.followers_count
            or self.followers_count <= 0
        ):
            return None
        total_engagement = 0
        valid_posts = 0
        for post in self.latest_posts:
            likes = post.digg_count
            comments = post.comment_count or 0
            if likes is None:
                continue
            total_engagement += likes + comments
            valid_posts += 1
        if valid_posts == 0:
            return None
        average_engagement = total_engagement / valid_posts
        return (average_engagement / self.followers_count) * 100.0


# --------- Builders / Factory ---------
def group_posts_by_author(
    posts: List[Union[Dict[str, Any], TikTokPost, str]],
) -> Dict[str, List[Union[Dict[str, Any], TikTokPost, str]]]:
    buckets: Dict[str, List[Union[Dict[str, Any], TikTokPost, str]]] = {}
    for item in posts:
        try:
            if isinstance(item, TikTokPost):
                key = item.author.name if item.author and item.author.name else ""
            elif isinstance(item, dict):
                key = TikTokAuthorMeta.from_source(item).name or ""
            elif isinstance(item, str):
                try:
                    obj = json.loads(item)
                    key = (
                        TikTokAuthorMeta.from_source(obj).name or ""
                        if isinstance(obj, dict)
                        else ""
                    )
                except Exception:
                    key = ""
            else:
                key = ""
            buckets.setdefault(key, []).append(item)
        except Exception:
            continue
    return buckets


@dataclass
class TikTokInfluencerFactory:
    @staticmethod
    def list_from_posts(
        posts: List[Union[Dict[str, Any], TikTokPost, str]],
        input_url: Optional[str] = None,
    ) -> List[TikTokInfluencer]:
        influencers: List[TikTokInfluencer] = []
        grouped = group_posts_by_author(posts)
        for _, bucket in grouped.items():
            try:
                influencers.append(
                    TikTokInfluencer.from_posts(bucket, input_url=input_url)
                )
            except Exception:
                continue
        return influencers
