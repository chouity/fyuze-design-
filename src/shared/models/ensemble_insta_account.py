from dataclasses import dataclass, field
from typing import Optional, List
from datetime import datetime


def _truncate(content: str, max_length: int) -> str:
    if not content or len(content) <= max_length:
        return content
    half = (max_length - 3) // 2
    return content[:half] + "..." + content[-half:]


@dataclass
class InstagramPost:
    id: str
    shortcode: str
    is_video: bool
    caption: Optional[str]
    taken_at_timestamp: int
    display_url: str
    video_url: str
    video_view_count: int
    like_count: int
    comment_count: int
    owner_username: str
    thumbnail_src: str
    product_type: str
    song_name: Optional[str]
    artist_name: Optional[str]

    @classmethod
    def from_dict(cls, data: dict) -> "InstagramPost":
        node = data.get("node", data)

        # Safely extract caption to avoid list index out of range
        caption_edges = node.get("edge_media_to_caption", {}).get("edges", [])
        caption = None
        if caption_edges:
            caption = caption_edges[0].get("node", {}).get("text")

        return cls(
            id=node["id"],
            shortcode=node["shortcode"],
            is_video=node.get("is_video", False),
            caption=caption,
            taken_at_timestamp=node.get("taken_at_timestamp"),
            display_url=node.get("display_url"),
            video_url=node.get("video_url"),
            video_view_count=node.get("video_view_count", 0),
            like_count=node.get("edge_liked_by", {}).get("count", 0),
            comment_count=node.get("edge_media_to_comment", {}).get("count", 0),
            owner_username=node.get("owner", {}).get("username", ""),
            thumbnail_src=node.get("thumbnail_src"),
            product_type=node.get("product_type", ""),
            song_name=(node.get("clips_music_attribution_info") or {}).get("song_name"),
            artist_name=(node.get("clips_music_attribution_info") or {}).get(
                "artist_name"
            ),
        )

    def to_dict(self) -> dict:
        return {
            "id": self.id,
            "shortcode": self.shortcode,
            "is_video": self.is_video,
            "caption": self.caption,
            "taken_at_timestamp": self.taken_at_timestamp,
            "display_url": self.display_url,
            "video_url": self.video_url,
            "video_view_count": self.video_view_count,
            "like_count": self.like_count,
            "comment_count": self.comment_count,
            "owner_username": self.owner_username,
            "thumbnail_src": self.thumbnail_src,
            "product_type": self.product_type,
            "song_name": self.song_name,
            "artist_name": self.artist_name,
        }

    def to_agent_dict(self) -> dict:
        """Simplified dict for agent consumption with key metrics."""
        return {
            "is_video": self.is_video,
            "caption": _truncate(self.caption or "", 400),
            "taken_at_timestamp": self.taken_at_timestamp,
            "like_count": self.like_count,
            "comment_count": self.comment_count,
            "video_view_count": self.video_view_count,
            "owner_username": self.owner_username,
        }


@dataclass
class InstagramPosts:
    posts: list["InstagramPost"]
    count: int

    @classmethod
    def from_dict(cls, data: dict) -> "InstagramPosts":
        posts = data["edges"]
        posts = [InstagramPost.from_dict(post) for post in posts]
        return cls(posts=posts, count=data["count"])

    def to_dict(self) -> dict:
        return {
            "count": self.count,
            "edges": [p.to_dict() for p in self.posts],
        }


@dataclass
class EnsembleInstaAccount:
    id: str
    username: str
    bio: Optional[str]
    profile_pic_url: str
    links: List[str] = field(default_factory=list)
    fb_link: Optional[str] = None
    full_name: Optional[str] = None
    followers: int = 0
    following: int = 0
    category: Optional[str] = None
    is_verified: bool = False
    posts: "InstagramPosts" = field(
        default_factory=lambda: InstagramPosts(posts=[], count=0)
    )
    raw_data: dict = field(default_factory=dict)

    @classmethod
    def from_dict(cls, data: dict) -> "EnsembleInstaAccount":
        """
        Build from an Instagram user JSON (like the sample you shared).
        Expects posts under 'edge_owner_to_timeline_media'.
        """

        # --- simple helpers --- #
        def _get_count(container: Optional[dict]) -> int:
            if not isinstance(container, dict):
                return 0
            return int(container.get("count", 0) or 0)

        def _extract_links(user: dict) -> List[str]:
            links: List[str] = []
            # 1) explicit list of bio links (if present)
            bio_links = user.get("bio_links") or []
            for item in bio_links:
                # Items can be dicts or strings depending on source; handle both
                if isinstance(item, str):
                    links.append(item)
                elif isinstance(item, dict):
                    # common shapes: {"url": "..."} or {"link": {"url": "..."}} etc.
                    if "url" in item and isinstance(item["url"], str):
                        links.append(item["url"])
                    elif (
                        "link" in item
                        and isinstance(item["link"], dict)
                        and isinstance(item["link"].get("url"), str)
                    ):
                        links.append(item["link"]["url"])

            # 2) external_url (classic profile link)
            if isinstance(user.get("external_url"), str):
                links.append(user["external_url"])

            # 3) links
            links.extend(user.get("links", []))

            # Deduplicate while preserving order
            seen = set()
            unique_links = []
            for u in links:
                if u and u not in seen:
                    seen.add(u)
                    unique_links.append(u)
            return unique_links

        # Posts: adapt to your InstagramPosts schema
        timeline = data.get("edge_owner_to_timeline_media") or {}
        posts_obj = (
            InstagramPosts.from_dict(timeline)
            if isinstance(timeline, dict)
            and "edges" in timeline
            and "count" in timeline
            else InstagramPosts(posts=[], count=0)
        )

        return cls(
            id=str(data.get("id", "")),
            username=str(data.get("username", "")),
            bio=(data.get("biography_with_entities", {}) or {}).get("raw_text")
            or data.get("biography"),
            links=_extract_links(data),
            fb_link=data.get("fb_profile_biolink"),  # often None
            full_name=data.get("full_name"),
            followers=_get_count(data.get("edge_followed_by")),
            following=_get_count(data.get("edge_follow")),
            category=data.get("category_name")
            or data.get("overall_category_name")
            or data.get("business_category_name"),
            is_verified=bool(data.get("is_verified", False)),
            profile_pic_url=data.get("profile_pic_url_hd"),
            posts=posts_obj,
            raw_data=data,
        )

    def to_dict(self) -> dict:
        return {
            "id": self.id,
            "username": self.username,
            "bio": self.bio,
            "links": self.links,
            "fb_link": self.fb_link,
            "full_name": self.full_name,
            "followers": self.followers,
            "following": self.following,
            "category": self.category,
            "is_verified": self.is_verified,
            "profile_pic_url": self.profile_pic_url,
            "posts": {
                "count": self.posts.count,
                "edges": [p.to_dict() for p in self.posts.posts],
            },
            "engagementRate": self.get_engagement_rate(),
            "raw_data": self.raw_data,
        }

    def get_engagement_rate(self, max_posts: int = 12) -> Optional[float]:
        """Compute Instagram ER by followers over recent posts.

        - Uses up to `max_posts` most recent items from posts.
        - Engagement per post = like_count + comment_count.
        - ER (%) = average of per-post ((likes + comments) / followers * 100).
        - Returns None if followers is missing/zero or there are no valid posts.
        """
        if not self.followers or self.followers <= 0:
            return None

        # Get posts from the posts container
        all_posts = self.posts.posts if self.posts else []

        if not all_posts:
            return None

        # Sort by timestamp desc (most recent first)
        def _parse_ts(ts: Optional[int]) -> datetime:
            if ts is None:
                return datetime.min
            try:
                return datetime.fromtimestamp(ts)
            except Exception:
                return datetime.min

        sorted_posts = sorted(
            all_posts,
            key=lambda p: _parse_ts(p.taken_at_timestamp),
            reverse=True,
        )

        # Take up to max_posts with valid engagement metrics
        valid_rates: List[float] = []
        for post in sorted_posts:
            if len(valid_rates) >= max_posts:
                break

            # Both like_count and comment_count should be available
            likes = post.like_count or 0
            comments = post.comment_count or 0
            engagement = likes + comments

            # Per-post ER by followers (%)
            rate = (engagement / self.followers) * 100.0
            valid_rates.append(rate)

        if not valid_rates:
            return None

        # Average ER across posts; round to 2 decimals for stability
        return round(sum(valid_rates) / len(valid_rates), 2)

    def to_agent_dict(self) -> dict:
        """Simplified dict for agent consumption with key metrics."""
        return {
            "username": self.username,
            "full_name": self.full_name,
            "bio": self.bio,
            "links": self.links,
            "followers": self.followers,
            "following": self.following,
            "category": self.category,
            "is_verified": self.is_verified,
            "posts_count": self.posts.count if self.posts else 0,
            "engagementRate": self.get_engagement_rate(),
            "posts": (
                [p.to_agent_dict() for p in self.posts.posts[:6]] if self.posts else []
            ),
        }

    def get_agent_summary(self) -> str:
        """
        Generate a comprehensive, AI-friendly summary of the Instagram account.
        Clearly indicates unavailable data and provides explanatory context for available metrics.

        Returns:
            Formatted string optimized for AI agent consumption with clear data availability indicators

        Example:
            >>> account = EnsembleInstaAccount.from_dict(raw_data)
            >>> print(account.get_agent_summary())
        """
        lines = []

        # Header
        lines.append("INSTAGRAM ACCOUNT PROFILE SUMMARY")
        lines.append("=" * 70)

        # Basic Profile Information
        lines.append("\n--- BASIC PROFILE INFORMATION ---")
        lines.append(f"Username: @{self.username}")

        if self.full_name:
            lines.append(f"Full Name: {self.full_name}")
        else:
            lines.append("Full Name: Not provided")

        if self.id:
            lines.append(f"Account ID: {self.id}")
        else:
            lines.append("Account ID: Not available")

        # Verification Status
        verification_status = (
            "✓ Verified Account" if self.is_verified else "Not Verified"
        )
        lines.append(f"Verification Status: {verification_status}")

        # Category
        if self.category:
            lines.append(f"Account Category: {self.category}")
        else:
            lines.append("Account Category: Not specified")

        # Bio
        lines.append("\n--- BIOGRAPHY ---")
        if self.bio:
            # Truncate if too long for readability
            bio_text = self.bio if len(self.bio) <= 300 else self.bio[:297] + "..."
            lines.append(f"{bio_text}")
        else:
            lines.append("Biography: Not provided")

        # Links
        lines.append("\n--- EXTERNAL LINKS ---")
        if self.links:
            for i, link in enumerate(self.links, 1):
                lines.append(f"  {i}. {link}")
        else:
            lines.append("No external links in profile")

        if self.fb_link:
            lines.append(f"Facebook Profile: {self.fb_link}")

        # Follower Metrics
        lines.append("\n--- AUDIENCE METRICS ---")
        if self.followers > 0:
            lines.append(f"Followers: {self.followers:,} (total audience size)")
        else:
            lines.append("Followers: Data not available")

        if self.following > 0:
            lines.append(f"Following: {self.following:,} (accounts this user follows)")
        else:
            lines.append("Following: Data not available")

        # Calculate follower ratio if both are available
        if self.followers > 0 and self.following > 0:
            ratio = self.followers / self.following
            if ratio > 10:
                ratio_interpretation = "high influence (followers >> following)"
            elif ratio > 1:
                ratio_interpretation = "good ratio (more followers than following)"
            elif ratio > 0.5:
                ratio_interpretation = "balanced (similar followers and following)"
            else:
                ratio_interpretation = "follows more than followed"

            lines.append(
                f"Follower/Following Ratio: {ratio:.2f} ({ratio_interpretation})"
            )

        # Engagement Rate
        lines.append("\n--- ENGAGEMENT METRICS ---")
        engagement_rate = self.get_engagement_rate()
        if engagement_rate is not None:
            if engagement_rate >= 5.0:
                engagement_level = "Excellent engagement"
            elif engagement_rate >= 3.0:
                engagement_level = "Very good engagement"
            elif engagement_rate >= 1.0:
                engagement_level = "Good engagement"
            elif engagement_rate >= 0.5:
                engagement_level = "Average engagement"
            else:
                engagement_level = "Below average engagement"

            lines.append(
                f"Engagement Rate: {engagement_rate:.2f}% ({engagement_level})"
            )
            lines.append(
                "  (Calculated as: average of (likes + comments) / followers across recent posts)"
            )
        else:
            lines.append(
                "Engagement Rate: Cannot be calculated (insufficient data or no followers)"
            )

        # Posts Overview
        lines.append("\n--- CONTENT OVERVIEW ---")
        posts_count = self.posts.count if self.posts else 0

        if posts_count > 0:
            lines.append(f"Total Posts: {posts_count:,}")

            # Analyze recent posts
            if self.posts and self.posts.posts:
                recent_posts = self.posts.posts[:12]  # Look at up to 12 recent posts

                video_count = sum(1 for p in recent_posts if p.is_video)
                total_recent = len(recent_posts)
                video_pct = (
                    (video_count / total_recent * 100) if total_recent > 0 else 0
                )

                lines.append(
                    f"Recent Content Mix: {video_pct:.0f}% videos, "
                    f"{100 - video_pct:.0f}% photos (based on {total_recent} recent posts)"
                )

                # Average engagement on recent posts
                total_likes = sum(p.like_count for p in recent_posts if p.like_count)
                total_comments = sum(
                    p.comment_count for p in recent_posts if p.comment_count
                )

                if total_recent > 0:
                    avg_likes = total_likes / total_recent
                    avg_comments = total_comments / total_recent
                    lines.append(
                        f"Average Engagement per Post: {avg_likes:,.0f} likes, "
                        f"{avg_comments:,.0f} comments"
                    )

                # Check for video views if videos exist
                video_posts = [
                    p for p in recent_posts if p.is_video and p.video_view_count > 0
                ]
                if video_posts:
                    avg_views = sum(p.video_view_count for p in video_posts) / len(
                        video_posts
                    )
                    lines.append(
                        f"Average Video Views: {avg_views:,.0f} views per video"
                    )

                # Music attribution (for Reels)
                music_posts = [p for p in recent_posts if p.song_name or p.artist_name]
                if music_posts:
                    lines.append(
                        f"Music Content: {len(music_posts)} posts with music attribution "
                        f"(likely Reels or music videos)"
                    )

        else:
            lines.append("Total Posts: No posts data available")

        # Recent Posts Sample
        if self.posts and self.posts.posts:
            lines.append("\n--- RECENT POSTS SAMPLE (up to 3) ---")
            for i, post in enumerate(self.posts.posts[:3], 1):
                post_type = "Video" if post.is_video else "Photo"
                timestamp = (
                    datetime.fromtimestamp(post.taken_at_timestamp).strftime(
                        "%Y-%m-%d %H:%M"
                    )
                    if post.taken_at_timestamp
                    else "Unknown date"
                )

                lines.append(f"\nPost #{i} ({post_type}) - Posted: {timestamp}")
                lines.append(
                    f"  Engagement: {post.like_count:,} likes, {post.comment_count:,} comments"
                )

                if post.is_video and post.video_view_count > 0:
                    lines.append(f"  Views: {post.video_view_count:,}")

                if post.caption:
                    caption_preview = _truncate(post.caption, 150)
                    lines.append(f"  Caption: {caption_preview}")
                else:
                    lines.append("  Caption: No caption")

                if post.song_name or post.artist_name:
                    music_info = []
                    if post.song_name:
                        music_info.append(f"Song: {post.song_name}")
                    if post.artist_name:
                        music_info.append(f"Artist: {post.artist_name}")
                    lines.append(f"  Music: {', '.join(music_info)}")

        lines.append("\n" + "=" * 70)
        return "\n".join(lines)
