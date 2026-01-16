from threading import local
from typing import List, Dict, Any, Tuple, Optional
from collections import defaultdict
import os
from datetime import datetime

from exa_py.api import SearchResponse
from googleapiclient.discovery import build


from src.shared.enums import Platform
from src.shared.services import ExaSearchService, EnsembleService
from src.shared.models import (
    EnsembleTiktokAccount,
    BasicSearchResult,
    BasicSearchResultItem,
)

from src.shared.utils import get_logger, FyuzeLogger

from src.protected.search_engine import URLParser


class SearchEngine:
    """
    A comprehensive search engine for finding influencers and content creators
    across social media platforms using the EXA search service.

    This class provides methods to search for profiles based on topic, location,
    and keywords, with built-in result ranking and URL validation.
    """

    def __init__(self):
        """Initialize the search engine with EXA search service and logger."""
        self._exa_service = ExaSearchService()
        # self._logger: FyuzeLogger = get_logger(__name__)
        self._url_parser = URLParser()
        # Ensemble service for TikTok custom search
        self._ensemble_service = EnsembleService()

    def search_tiktok_accounts(
        self,
        topic: str,
        location: str,
        keywords: List[str] | None = None,
        *,
        period: str = "180",
        max_results_per_keyword: Optional[int] = None,
        max_workers: int = 5,
    ) -> List[EnsembleTiktokAccount]:
        """
        Custom TikTok search that builds creator-focused queries and fetches
        real accounts using Ensemble Data.

        Args:
            topic: Main topic/niche (e.g., "Food")
            location: City/Region focus (e.g., "Tripoli, Lebanon")
            keywords: Optional extra keywords to refine queries
            period: Ensemble search period (default: "90")
            max_results_per_keyword: Limit results per query (optional)
            max_workers: Parallelism for Ensemble calls

        Returns:
            A list of unique `EnsembleTiktokAccount` objects sorted by relevance.
        """
        kw = keywords or []
        # self._logger.info(
        #     f"TikTok custom search: topic='{topic}', location='{location}', keywords={kw}"
        # )

        queries = self._formulate_tiktok_queries(
            topic=topic, location=location, keywords=kw
        )
        if not queries:
            # self._logger.warning(
            #     "No TikTok queries were generated; returning empty list."
            # )
            return []

        # self._logger.debug(f"Executing {len(queries)} TikTok queries via Ensemble Data")

        # Use EnsembleService parallel search; it returns unique, relevance-sorted accounts
        accounts = self._ensemble_service.search_tiktok_parallel(
            keywords=queries,
            period=period,
            max_results_per_keyword=max_results_per_keyword,
            max_workers=max_workers,
        )

        # As an extra safeguard, ensure uniqueness by unique_id via set semantics
        unique_accounts = list(set(accounts))

        # Preserve the original relevance order where possible
        uid_order = {acc.unique_id: idx for idx, acc in enumerate(accounts)}
        unique_accounts.sort(key=lambda a: uid_order.get(a.unique_id, 1_000_000))

        # self._logger.info(
        #     f"TikTok custom search complete: {len(unique_accounts)} unique accounts returned"
        # )
        return unique_accounts

    def search(
        self,
        topic: str,
        location: str,
        keywords: List[str],
        platform: Platform,
        max_results: int = 50,
    ) -> List[Tuple[Any, int]]:
        """
        Search for influencers and content creators on a specific platform.

        Args:
            topic: The main topic or niche to search for (e.g., "fitness", "cooking")
            location: Geographic location to focus the search (e.g., "New York", "London")
            keywords: List of related keywords to enhance search (e.g., ["yoga", "wellness"])
            platform: The social media platform to search on
            max_results: Maximum number of results to return (default: 50)

        Returns:
            List of tuples containing (search_result, frequency_score) sorted by relevance

        Example:
            >>> engine = SearchEngine()
            >>> results = engine.search(
            ...     topic="fitness",
            ...     location="Los Angeles",
            ...     keywords=["yoga", "wellness", "nutrition"],
            ...     platform=Platform.INSTAGRAM
            ... )
            >>> for result, score in results[:5]:
            ...     print(f"Profile: {result.url} (Score: {score})")
        """
        # self._logger.info(
        #     f"Starting search for topic='{topic}', location='{location}', "
        #     f"platform={platform.value}, keywords={keywords}"
        # )

        # Generate search queries
        queries = self._formulate_queries(topic, location, keywords, platform)

        # Prepare queries for bulk search
        query_dict = {f"query_{i}": query for i, query in enumerate(queries)}

        # Perform bulk search using EXA service
        try:
            search_results = self._exa_service.bulk_search(query_dict)
            # self._logger.info(
            #     f"Bulk search completed with {len(search_results)} query results"
            # )
        except Exception as e:
            # self._logger.error(f"Error during bulk search: {e}")
            raise

        # Collect and filter results
        all_results = []
        for query_id, query_response in search_results.items():
            if isinstance(query_response, SearchResponse):
                # Filter results to only include valid profile URLs
                valid_results = [
                    result
                    for result in query_response.results
                    if self._url_parser.is_profile_url(result.url, platform)
                ]
                all_results.extend(valid_results)
                # self._logger.debug(
                #     f"Query {query_id}: {len(valid_results)} valid profiles found"
                # )

        # Rank results by frequency and relevance
        ranked_results = self._rank_results(all_results)

        # Limit results to max_results
        final_results = ranked_results[:max_results]

        # self._logger.info(
        #     f"Search completed. Found {len(final_results)} ranked results "
        #     f"from {len(all_results)} total results"
        # )

        return final_results

    def search_single_query(
        self, query: str, platform: Platform, filter_profiles: bool = True
    ) -> List[Any]:
        """
        Perform a single search query.

        Args:
            query: The search query string
            platform: The platform to search on
            filter_profiles: Whether to filter results to only profile URLs

        Returns:
            List of search results

        Example:
            >>> engine = SearchEngine()
            >>> results = engine.search_single_query(
            ...     'site:instagram.com "fitness influencer" "Los Angeles"',
            ...     Platform.INSTAGRAM
            ... )
        """
        # self._logger.info(f"Performing single query search: {query}")

        try:
            response = self._exa_service.search(query)
            results = response.results

            if filter_profiles:
                results = [
                    result
                    for result in results
                    if self._url_parser.is_profile_url(result.url, platform)
                ]

            # self._logger.info(f"Single query completed with {len(results)} results")
            return results

        except Exception as e:
            # self._logger.error(f"Error during single query search: {e}")
            raise

    def rank_results(self, results: List[Any]) -> List[Tuple[Any, int]]:
        """
        Public method to rank a list of results based on repetition frequency.

        Args:
            results: List of result objects with url and/or id attributes

        Returns:
            List of tuples where each tuple contains (result_object, frequency_score)

        Example:
            >>> engine = SearchEngine()
            >>> ranked = engine.rank_results(search_results)
            >>> for result, score in ranked:
            ...     print(f"URL: {result.url}, Score: {score}")
        """
        return self._rank_results(results)

    def _formulate_queries(
        self,
        topic: str,
        location: str,
        keywords: List[str],
        platform: Platform,
    ) -> List[str]:
        """
        Generate optimized search queries to surface real creator profile pages,
        using platform-specific include/exclude filters and strong influencer signals.
        """

        def or_group(terms: List[str]) -> str:
            terms = [t for t in terms if t]
            if not terms:
                return ""
            if len(terms) == 1:
                return terms[0]
            return f"({ ' OR '.join(terms) })"

        def quoted(s: str) -> str:
            s = s.strip()
            return f'"{s}"' if s and not (s.startswith('"') and s.endswith('"')) else s

        # Normalize inputs
        topic_term = quoted(topic) if topic else ""
        loc_term = quoted(location) if location else ""
        location_parts = (
            [p.strip() for p in location.split(",") if p.strip()] if location else []
        )
        location_part_terms = [quoted(p) for p in location_parts if p]
        # Location variants group: prefer full quoted location, fallback to parts
        location_group = or_group(
            ([loc_term] if loc_term else []) + location_part_terms
        )

        # Influencer-related signals
        influencer_terms = [
            '"influencer"',
            '"content creator"',
            '"digital creator"',
            '"creator"',
            '"public figure"',
            '"ugc creator"',
        ]
        bio_signals = [
            '"business inquiries"',
            '"business inquiry"',
            '"brand deals"',
            '"collab"',
            '"collaboration"',
            '"partnerships"',
            '"ambassador"',
            '"bookings"',
            '"management"',
            '"mgmt"',
            '"email"',
        ]

        # Keywords and hashtags
        kw_terms = [quoted(kw) for kw in (keywords or []) if kw]
        hashtag_terms = []
        if keywords:
            for kw in keywords:
                k = (kw or "").strip()
                if not k:
                    continue
                hashtag_terms.append(f'#{k.replace(" ", "").lower()}')
                # Common hashtag variation: remove punctuation/underscores
                comp = "".join(ch for ch in k if ch.isalnum())
                if comp and comp.lower() != k.replace(" ", "").lower():
                    hashtag_terms.append(f"#{comp.lower()}")

        kw_group = or_group(kw_terms)
        hashtag_group = or_group(hashtag_terms)

        # Platform-specific filters
        pv = platform.value.lower()
        domain = platform.domain

        site_token = f"site:{domain}"
        includes: List[str] = []
        excludes: List[str] = []

        if pv == "instagram":
            excludes = [
                "p",
                "reel",
                "reels",
                "stories",
                "explore",
                "tags",
                "tv",
                "about",
                "legal",
                "privacy",
                "help",
                "developers",
                "accounts",
                "directory",
                "web",
                "emailsignup",
            ]
            # No strict include; username paths vary, URLParser will validate.
        elif pv == "tiktok":
            excludes = [
                "video",
                "discover",
                "tag",
                "music",
                "privacy",
                "legal",
                "tos",
                "about",
                "login",
                "signup",
                "press",
            ]
            includes.append("inurl:@")
        elif pv in ("twitter", "x"):
            excludes = [
                "status",
                "search",
                "hashtag",
                "home",
                "i",
                "explore",
                "intent",
                "notifications",
                "settings",
                "messages",
                "tos",
                "privacy",
                "login",
                "signup",
            ]
        elif pv == "youtube":
            # Focus on channels/users, exclude content pages
            excludes = [
                "watch",
                "playlist",
                "shorts",
                "feed",
                "results",
                "embed",
                "live",
            ]
            includes.append("(inurl:/channel/ OR inurl:/user/)")
        elif pv == "linkedin":
            # LinkedIn individual profiles live under /in/
            site_token = "site:linkedin.com/in"
            excludes = [
                "jobs",
                "company",
                "learning",
                "feed",
                "pulse",
                "groups",
                "signup",
                "login",
                "legal",
                "help",
                "posts",
                "school",
            ]
        elif pv == "facebook":
            excludes = [
                "groups",
                "events",
                "marketplace",
                "help",
                "policies",
                "privacy",
                "legal",
                "login",
                "watch",
                "gaming",
            ]
            includes.append("(inurl:/people/ OR inurl:profile.php)")

        exclusions_str = " ".join(f"-inurl:{e}" for e in excludes) if excludes else ""
        includes_str = " ".join(includes) if includes else ""

        # Assemble high-signal groups
        infl_group = or_group(influencer_terms)
        bio_group = or_group(bio_signals)

        def assemble(parts: List[str]) -> str:
            # Remove empty tokens and extra spaces
            return " ".join(p for p in parts if p).strip()

        queries: List[str] = []
        seen = set()

        def add(q: str):
            if not q:
                return
            if q in seen:
                return
            seen.add(q)
            queries.append(q)

        # 1) Topic + Location, profile-focused
        add(
            assemble(
                [site_token, exclusions_str, includes_str, topic_term, location_group]
            )
        )

        # 2) Topic + Location + Influencer signals
        add(
            assemble(
                [
                    site_token,
                    exclusions_str,
                    includes_str,
                    topic_term,
                    location_group,
                    infl_group,
                ]
            )
        )

        # 3) Topic + Keywords + Location + Influencer signals
        if kw_group:
            add(
                assemble(
                    [
                        site_token,
                        exclusions_str,
                        includes_str,
                        topic_term,
                        kw_group,
                        location_group,
                        infl_group,
                    ]
                )
            )

        # 4) Topic + Hashtags + Location + Influencer signals
        if hashtag_group and pv in ("instagram", "twitter", "x", "tiktok"):
            add(
                assemble(
                    [
                        site_token,
                        exclusions_str,
                        includes_str,
                        topic_term,
                        hashtag_group,
                        location_group,
                        infl_group,
                    ]
                )
            )

        # 5) Topic + Location + Bio/contact signals (high intent to collaborate)
        add(
            assemble(
                [
                    site_token,
                    exclusions_str,
                    includes_str,
                    topic_term,
                    location_group,
                    bio_group,
                ]
            )
        )

        # 6) Broad: Location + Influencer + Keywords
        if kw_group:
            add(
                assemble(
                    [
                        site_token,
                        exclusions_str,
                        includes_str,
                        location_group,
                        infl_group,
                        kw_group,
                    ]
                )
            )

        # 7) Natural language variant
        if topic_term and loc_term:
            add(
                assemble(
                    [
                        site_token,
                        exclusions_str,
                        includes_str,
                        loc_term,
                        f"{topic} influencer",
                    ]
                )
            )

        # 8) Location parts, each as a separate focused query
        if location_part_terms and len(location_part_terms) > 1:
            for part in location_part_terms:
                add(
                    assemble(
                        [
                            site_token,
                            exclusions_str,
                            includes_str,
                            topic_term,
                            part,
                            infl_group,
                        ]
                    )
                )

        # self._logger.debug(
        #     f"Generated {len(queries)} optimized queries for {platform.value}"
        # )

        # 9) Simple broad query
        add(assemble([site_token, topic_term, location_group, infl_group]))

        # 10) Simple topic
        add(
            assemble(
                [
                    site_token,
                    topic_term,
                    "(influencer OR content creator OR blogger)",
                    location_group,
                ]
            )
        )
        return queries

    def _formulate_tiktok_queries(
        self,
        topic: str,
        location: str,
        keywords: List[str],
    ) -> List[str]:
        """
        Generate TikTok-specific queries focused on finding creators and bloggers.
        Emphasizes creator-specific hashtags, blogger identifiers, and content creator signals.
        """

        def norm(s: str) -> str:
            return (s or "").strip()

        def first_city(loc: str) -> str:
            loc = norm(loc)
            if not loc:
                return ""
            return (
                [p.strip() for p in loc.split(",") if p.strip()][0]
                if "," in loc
                else loc
            )

        def hashtag(s: str) -> str:
            s = "".join(ch for ch in s if ch.isalnum()).lower()
            return f"#{s}" if s else ""

        def has_arabic(s: str) -> bool:
            return any("\u0600" <= ch <= "\u06ff" for ch in s or "")

        topic = norm(topic)
        city = first_city(location)
        location_full = norm(location)
        kws = [norm(k) for k in (keywords or []) if norm(k)]

        queries: List[str] = []
        seen = set()

        def add_query(q: str):
            if q and q not in seen:
                seen.add(q)
                queries.append(q)

        # 1. Creator-focused hashtag combinations
        if city and topic:
            city_hash = hashtag(city)
            topic_hash = hashtag(topic)
            creator_hash = hashtag(f"{city}creator")
            blogger_hash = hashtag(f"{city}blogger")

            # Multiple creator-focused hashtag combos
            add_query(f"{city_hash} {topic_hash} {creator_hash}")
            add_query(f"{city_hash} {topic_hash} {blogger_hash}")
            add_query(f"{city_hash} #{topic}blogger #{topic}creator")

        # 2. Blogger/creator identification with topic
        if city and topic:
            add_query(f"{city} {topic} blogger")
            add_query(f"{city} {topic} content creator")
            add_query(f"{city} {topic} influencer")
            add_query(f"{topic} blogger {city}")
            add_query(f"{topic} creator {city}")

        # 3. Vlog and creator content patterns
        if city and topic:
            add_query(f"{city} {topic} vlog")
            add_query(f"{city} {topic} vlogger")
            add_query(f"{topic} vlog {city}")
            add_query(f"daily {topic} vlog {city}")

        # 4. Creator review and guide patterns
        if city and topic:
            add_query(f"{city} {topic} review creator")
            add_query(f"{topic} guide {city} blogger")
            add_query(f"{city} {topic} recommendations blogger")
            add_query(f"local {topic} creator {city}")

        # 5. Community and foodies creator hashtags
        if city:
            foodies_creator = hashtag(f"{city}foodiecreator")
            foodies_blogger = hashtag(f"{city}foodieblogger")
            add_query(f"{foodies_creator} {topic}")
            add_query(f"{foodies_blogger} {topic}")
            add_query(f"#{city}foodies creator {topic}")

        # 6. Natural language creator searches
        if city and topic:
            add_query(f'"{city} {topic} blogger"')
            add_query(f'"{topic} content creator {city}"')
            add_query(f'"{city} based {topic} creator"')
            add_query(f'"{local} {topic} influencer {city}"')

        # 7. Keywords with creator focus
        if kws and city and topic:
            for kw in kws[:2]:
                add_query(f"{city} {topic} {kw} creator")
                add_query(f"{topic} {kw} blogger {city}")

        # 8. Trending creator patterns
        if city and topic:
            add_query(f"trending {topic} creator {city}")
            add_query(f"{city} {topic} tiktoker")
            add_query(f"viral {topic} creator {city}")
            add_query(f"famous {topic} blogger {city}")

        # 9. Arabic creator variants (if applicable)
        if has_arabic(location) or has_arabic(topic):
            if city:
                add_query(f"{city} {topic} مؤثر")  # Arabic for influencer
                add_query(f"{city} {topic} مدون")  # Arabic for blogger

        # 10. Creator collaboration signals
        if city and topic:
            add_query(f"{city} {topic} creator collab")
            add_query(f"{topic} blogger {city} partnership")
            add_query(f"brand deal {topic} creator {city}")

        # 11. Channel/account specific searches
        if city and topic:
            add_query(f"{city} {topic} account")
            add_query(f"{topic} channel {city}")
            add_query(f"follow {city} {topic} creator")

        # 12. Day-in-life creator content
        if city and topic:
            add_query(f"day in life {topic} creator {city}")
            add_query(f"{city} {topic} lifestyle blogger")
            add_query(f"behind scenes {topic} creator {city}")

        # Return up to 20 creator-focused queries
        return queries[:10]

    def _rank_results(self, results: List[Any]) -> List[Tuple[Any, int]]:
        """
        Rank results based on URL repetition frequency across multiple searches.

        Higher frequency indicates the result appeared in multiple search queries,
        suggesting higher relevance.

        Args:
            results: List of search result objects

        Returns:
            List of tuples (result, frequency_score) sorted by score descending
        """
        if not results:
            return []

        # Count occurrences by URL (or ID as fallback)
        url_counts = defaultdict(int)
        url_to_result = {}

        for result in results:
            # Use URL as primary identifier, fallback to ID if URL is None
            identifier = getattr(result, "url", None) or getattr(result, "id", None)

            if identifier:
                url_counts[identifier] += 1
                # Keep the first occurrence of each result
                if identifier not in url_to_result:
                    url_to_result[identifier] = result

        # Create list of (result, score) tuples
        ranked_results = [
            (url_to_result[identifier], count)
            for identifier, count in url_counts.items()
        ]

        # Sort by frequency score in descending order
        ranked_results.sort(key=lambda x: x[1], reverse=True)

        # self._logger.debug(
        #     f"Ranked {len(ranked_results)} unique results. "
        #     f"Top score: {ranked_results[0][1] if ranked_results else 0}"
        # )

        return ranked_results

    def get_profile_info(
        self, url: str, platform: Platform
    ) -> Optional[Dict[str, Any]]:
        """
        Extract basic profile information from a URL.

        Args:
            url: The profile URL
            platform: The social media platform

        Returns:
            Dictionary containing profile information or None if extraction fails

        Example:
            >>> engine = SearchEngine()
            >>> info = engine.get_profile_info(
            ...     "https://instagram.com/john_doe",
            ...     Platform.INSTAGRAM
            ... )
            >>> print(info)
            {'username': 'john_doe', 'platform': 'instagram', 'url': 'https://instagram.com/john_doe'}
        """
        username = self._url_parser.extract_username(url, platform)

        if username:
            return {
                "username": username,
                "platform": platform.value,
                "url": url,
                "domain": platform.domain,
            }

        return None

    def basic_search(self, query: str, gl: str | None) -> BasicSearchResult:
        """
        Perform a basic Google Custom Search (using CSE) and return structured results.

        Args:
            query: The search query string
            gl: Optional geographic location code (e.g., "us", "lb")

        Returns:
            BasicSearchResult containing the search outcome
        """
        request_time = datetime.now()
        success = False
        error_message = ""
        response = None

        try:
            api_key = os.getenv("GOOGLE_API_KEY")
            search_engine_id = os.getenv("GOOGLE_SEARCH_ENGINE_ID")

            if not api_key or not search_engine_id:
                raise ValueError(
                    "GOOGLE_API_KEY and GOOGLE_SEARCH_ENGINE_ID must be set in environment variables"
                )

            service = build("customsearch", "v1", developerKey=api_key)
            result = (
                service.cse()
                .list(
                    q=query,
                    cx=search_engine_id,
                    gl=gl,  #! should be country code (e.g: "us", "lb")
                    num=10,  #! max 10
                )
                .execute()
            )

            items = result.get("items", [])
            response = [BasicSearchResultItem.from_dict(item) for item in items]
            success = True

        except Exception as e:
            error_message = str(e)
            # self._logger.error(f"Basic search error: {e}")

        finish_time = datetime.now()
        execution_time = (finish_time - request_time).total_seconds()

        return BasicSearchResult(
            query=query,
            request_time=request_time,
            finish_time=finish_time,
            execution_time=execution_time,
            success=success,
            error_message=error_message,
            response=response,
        )
