from __future__ import annotations
from typing import List, Optional
from datetime import datetime
from pydantic import BaseModel, Field


class Share(BaseModel):
    name: str
    percent: float = Field(..., ge=0, le=1)


class GenderSplit(BaseModel):
    male: float = Field(..., ge=0, le=1)
    female: float = Field(..., ge=0, le=1)


class Mention(BaseModel):
    name: str
    url: str


class Connections(BaseModel):
    to_mentions_180d: int
    from_mentions_180d: int
    from_mentions_views_180d: int
    pct_fake_followers: float = Field(..., ge=0, le=1)


class AudienceSnapshot(BaseModel):
    updated_at: datetime

    top_countries: List[Share]
    top_cities: List[Share]

    gender_split: GenderSplit
    top_age_bracket: str

    follower_types: List[Share]  # real / influencer / massfollowers / suspicious
    reachability: List[Share]  # r0_500 / r500_1000 / ...

    categories: List[str] = []
    tags: List[str] = []
    interests: List[str] = []

    mentions: List[Mention] = []

    safety_score_total: int = 0
    connections: Optional[Connections] = None

    @classmethod
    def from_raw(cls, raw: dict, top_n: int = 10) -> "AudienceSnapshot":
        demo = raw.get("demographic", {})
        extra = raw.get("extra", {})
        prof_safe = extra.get("profileSafety", {}) or {}
        conn = extra.get("connections", {}) or {}

        def pick_shares(items, name_key="name", val_key="value"):
            out = []
            for it in items[:top_n]:
                name = it.get(name_key) or it.get("category", "")
                val = it.get(val_key)
                if isinstance(val, (int, float)) and name:
                    out.append(Share(name=name, percent=float(val)))
            return out

        # Countries & cities
        top_countries = pick_shares(demo.get("followersCountries", []))
        top_cities = pick_shares(demo.get("followersCities", []), val_key="value")

        # Gender & age
        genders = demo.get("genders", [])
        gender_map = {g.get("name"): g.get("percent") for g in genders}
        gender_split = GenderSplit(
            male=float(gender_map.get("m", 0.0)),
            female=float(gender_map.get("f", 0.0)),
        )
        top_age_bracket = (
            demo.get("followersGendersAges", {}).get("summary", {}).get("avgAges", "")
        ) or ""

        # Follower types & reachability
        follower_types = pick_shares(
            demo.get("followersTypes", []), name_key="name", val_key="percent"
        )
        reachability = pick_shares(
            demo.get("followersReachability", []), name_key="name", val_key="percent"
        )

        # Mentions (keep only name & url)
        mentions = [
            Mention(name=m.get("name", ""), url=m.get("url", ""))
            for m in (extra.get("lastFromMentions") or [])[:top_n]
            if m.get("name") and m.get("url")
        ]

        # Connections summary
        connections = (
            Connections(
                to_mentions_180d=int(conn.get("toMentions180d", 0)),
                from_mentions_180d=int(conn.get("fromMentions180d", 0)),
                from_mentions_views_180d=int(conn.get("fromMentionsViews180d", 0)),
                pct_fake_followers=float(conn.get("pctFakeFollowers", 0.0)),
            )
            if conn
            else None
        )

        return cls(
            updated_at=(
                datetime.fromisoformat(raw.get("lastUpdatedISO").replace("Z", "+00:00"))
                if raw.get("lastUpdatedISO")
                else datetime.utcnow()
            ),
            top_countries=top_countries,
            top_cities=top_cities,
            gender_split=gender_split,
            top_age_bracket=top_age_bracket,
            follower_types=follower_types,
            reachability=reachability,
            categories=extra.get("categories") or [],
            tags=extra.get("tags") or [],
            interests=demo.get("interests") or [],
            mentions=mentions,
            safety_score_total=int(prof_safe.get("totalScore", 0)),
            connections=connections,
        )

    def get_summary(self) -> str:
        """
        Generate a comprehensive, readable formatted summary of the audience snapshot.

        Returns:
            Formatted string containing all demographic and audience information

        Example:
            >>> snapshot = AudienceSnapshot.from_raw(raw_data)
            >>> print(snapshot.get_summary())
        """
        lines = []

        # Header
        lines.append("=" * 80)
        lines.append("INSTAGRAM AUDIENCE DEMOGRAPHIC SNAPSHOT".center(80))
        lines.append("=" * 80)

        # Metadata
        lines.append(
            f"\nLast Updated: {self.updated_at.strftime('%Y-%m-%d %H:%M:%S UTC')}"
        )
        lines.append(f"Safety Score: {self.safety_score_total}/100\n")

        # Gender & Age
        lines.append("-" * 80)
        lines.append("GENDER & AGE DISTRIBUTION")
        lines.append("-" * 80)
        lines.append(
            f"Male: {self.gender_split.male * 100:>6.1f}%  |  "
            f"Female: {self.gender_split.female * 100:>6.1f}%"
        )
        if self.top_age_bracket:
            lines.append(f"Top Age Bracket: {self.top_age_bracket}")
        lines.append("")

        # Geographic Distribution
        lines.append("-" * 80)
        lines.append("TOP COUNTRIES")
        lines.append("-" * 80)
        for i, country in enumerate(self.top_countries, 1):
            lines.append(f"{i:>2}. {country.name:<30} {country.percent * 100:>6.1f}%")
        lines.append("")

        lines.append("-" * 80)
        lines.append("TOP CITIES")
        lines.append("-" * 80)
        for i, city in enumerate(self.top_cities, 1):
            lines.append(f"{i:>2}. {city.name:<30} {city.percent * 100:>6.1f}%")
        lines.append("")

        # Follower Composition
        lines.append("-" * 80)
        lines.append("FOLLOWER TYPES")
        lines.append("-" * 80)
        for follower_type in self.follower_types:
            lines.append(
                f"  • {follower_type.name:<25} {follower_type.percent * 100:>6.1f}%"
            )
        lines.append("")

        # Reachability
        lines.append("-" * 80)
        lines.append("REACHABILITY DISTRIBUTION")
        lines.append("-" * 80)
        for reach in self.reachability:
            lines.append(f"  • {reach.name:<25} {reach.percent * 100:>6.1f}%")
        lines.append("")

        # Categories & Tags
        if self.categories:
            lines.append("-" * 80)
            lines.append("CATEGORIES")
            lines.append("-" * 80)
            lines.append(", ".join(self.categories))
            lines.append("")

        if self.tags:
            lines.append("-" * 80)
            lines.append("TAGS")
            lines.append("-" * 80)
            lines.append(", ".join(self.tags))
            lines.append("")

        # Interests
        if self.interests:
            lines.append("-" * 80)
            lines.append("TOP INTERESTS")
            lines.append("-" * 80)
            for i, interest in enumerate(self.interests[:10], 1):
                lines.append(f"{i:>2}. {interest}")
            lines.append("")

        # Connections
        if self.connections:
            lines.append("-" * 80)
            lines.append("CONNECTION METRICS (Last 180 days)")
            lines.append("-" * 80)
            lines.append(f"  Outgoing Mentions: {self.connections.to_mentions_180d}")
            lines.append(f"  Incoming Mentions: {self.connections.from_mentions_180d}")
            lines.append(
                f"  Incoming Mention Views: {self.connections.from_mentions_views_180d}"
            )
            lines.append(
                f"  Fake Followers %: {self.connections.pct_fake_followers * 100:.1f}%"
            )
            lines.append("")

        # Mentions
        if self.mentions:
            lines.append("-" * 80)
            lines.append("RECENT MENTIONS")
            lines.append("-" * 80)
            for i, mention in enumerate(self.mentions, 1):
                lines.append(f"{i}. {mention.name}")
                lines.append(f"   URL: {mention.url}")
            lines.append("")

        # Footer
        lines.append("=" * 80)

        return "\n".join(lines)

    def get_agent_summary(self) -> str:
        """
        Generate a concise, AI-friendly summary of the audience snapshot.
        Clearly indicates unavailable data and provides explanatory context for available metrics.

        Returns:
            Formatted string optimized for AI agent consumption with clear data availability indicators

        Example:
            >>> snapshot = AudienceSnapshot.from_raw(raw_data)
            >>> print(snapshot.get_agent_summary())
        """
        lines = []

        # Header
        lines.append("INSTAGRAM AUDIENCE DEMOGRAPHIC ANALYSIS")
        lines.append("=" * 70)

        # Metadata
        lines.append(
            f"\nData Last Updated: {self.updated_at.strftime('%Y-%m-%d at %H:%M:%S UTC')}"
        )

        # Safety Score
        if self.safety_score_total > 0:
            safety_level = (
                "High"
                if self.safety_score_total >= 70
                else "Medium" if self.safety_score_total >= 40 else "Low"
            )
            lines.append(
                f"Profile Safety Score: {self.safety_score_total}/100 ({safety_level} credibility)"
            )
        else:
            lines.append("Profile Safety Score: Not available")

        # Gender & Age Demographics
        lines.append("\n--- DEMOGRAPHIC BREAKDOWN ---")
        lines.append(
            f"Gender Distribution: {self.gender_split.male * 100:.1f}% Male, "
            f"{self.gender_split.female * 100:.1f}% Female"
        )

        if self.top_age_bracket:
            lines.append(f"Primary Age Bracket: {self.top_age_bracket}")
        else:
            lines.append("Primary Age Bracket: Data not available")

        # Geographic Distribution
        lines.append("\n--- GEOGRAPHIC REACH ---")
        if self.top_countries:
            top_3_countries = self.top_countries[:3]
            country_str = ", ".join(
                [f"{c.name} ({c.percent * 100:.1f}%)" for c in top_3_countries]
            )
            lines.append(f"Top Countries (up to 3): {country_str}")

            if len(self.top_countries) > 3:
                lines.append(
                    f"Additional countries tracked: {len(self.top_countries) - 3} more"
                )
        else:
            lines.append("Country Distribution: Data not available")

        if self.top_cities:
            top_3_cities = self.top_cities[:3]
            city_str = ", ".join(
                [f"{c.name} ({c.percent * 100:.1f}%)" for c in top_3_cities]
            )
            lines.append(f"Top Cities (up to 3): {city_str}")
        else:
            lines.append("City Distribution: Data not available")

        # Follower Quality & Composition
        lines.append("\n--- FOLLOWER QUALITY ANALYSIS ---")
        if self.follower_types:
            for ftype in self.follower_types:
                explanation = self._explain_follower_type(ftype.name)
                lines.append(
                    f"{ftype.name.capitalize()}: {ftype.percent * 100:.1f}% {explanation}"
                )
        else:
            lines.append("Follower Type Breakdown: Data not available")

        # Reachability Insights
        lines.append("\n--- AUDIENCE REACHABILITY ---")
        if self.reachability:
            lines.append("Follower reach distribution (by follower count ranges):")
            for reach in self.reachability:
                reach_explanation = self._explain_reachability(reach.name)
                lines.append(f"  • {reach_explanation}: {reach.percent * 100:.1f}%")
        else:
            lines.append("Reachability Distribution: Data not available")

        # Interests & Categories
        lines.append("\n--- AUDIENCE INTERESTS & CATEGORIES ---")
        if self.categories:
            lines.append(f"Content Categories: {', '.join(self.categories[:5])}")
            if len(self.categories) > 5:
                lines.append(f"  (and {len(self.categories) - 5} more categories)")
        else:
            lines.append("Content Categories: Not available")

        if self.tags:
            lines.append(f"Profile Tags: {', '.join(self.tags[:5])}")
            if len(self.tags) > 5:
                lines.append(f"  (and {len(self.tags) - 5} more tags)")
        else:
            lines.append("Profile Tags: Not available")

        if self.interests:
            top_interests = self.interests[:5]
            lines.append(f"Top Audience Interests: {', '.join(top_interests)}")
            if len(self.interests) > 5:
                lines.append(
                    f"  (and {len(self.interests) - 5} more interests tracked)"
                )
        else:
            lines.append("Audience Interests: Data not available")

        # Connection & Engagement Metrics
        lines.append("\n--- ENGAGEMENT & CONNECTION METRICS ---")
        if self.connections:
            lines.append(
                f"Outgoing Mentions (180d): {self.connections.to_mentions_180d:,} "
                f"- indicates how often this account mentions others"
            )
            lines.append(
                f"Incoming Mentions (180d): {self.connections.from_mentions_180d:,} "
                f"- indicates how often others mention this account"
            )
            lines.append(
                f"Incoming Mention Views (180d): {self.connections.from_mentions_views_180d:,} "
                f"- total views from mentions by others"
            )

            fake_pct = self.connections.pct_fake_followers * 100
            credibility_note = (
                "excellent authenticity"
                if fake_pct < 10
                else (
                    "acceptable authenticity"
                    if fake_pct < 25
                    else "concerning fake follower ratio"
                )
            )
            lines.append(
                f"Fake Followers Percentage: {fake_pct:.1f}% ({credibility_note})"
            )
        else:
            lines.append("Connection & Engagement Metrics: Data not available")

        # Recent Mentions
        if self.mentions:
            lines.append(f"\n--- RECENT MENTIONS ({len(self.mentions)} tracked) ---")
            for mention in self.mentions[:3]:
                lines.append(f"  • {mention.name} - {mention.url}")
            if len(self.mentions) > 3:
                lines.append(f"  ... and {len(self.mentions) - 3} more mentions")
        else:
            lines.append("\n--- RECENT MENTIONS ---")
            lines.append("No recent mentions data available")

        lines.append("\n" + "=" * 70)
        return "\n".join(lines)

    @staticmethod
    def _explain_follower_type(follower_type: str) -> str:
        """Provide context explanation for follower types."""
        explanations = {
            "real": "(genuine engaged followers)",
            "influencer": "(accounts with significant followings)",
            "massfollowers": "(accounts that follow many others)",
            "suspicious": "(potentially fake or bot accounts)",
        }
        return explanations.get(follower_type.lower(), "")

    @staticmethod
    def _explain_reachability(reachability_code: str) -> str:
        """Convert reachability codes to human-readable explanations."""
        # Format is typically r0_500, r500_1000, etc.
        if reachability_code.startswith("r"):
            parts = reachability_code[1:].split("_")
            if len(parts) == 2:
                try:
                    lower = int(parts[0])
                    upper = parts[1]
                    if upper == "inf" or upper == "max":
                        return f"Followers with {lower:,}+ followers"
                    else:
                        return f"Followers with {lower:,}-{int(upper):,} followers"
                except ValueError:
                    pass
        return reachability_code
