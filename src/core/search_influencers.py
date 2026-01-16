"""Search and fetch Instagram influencer profiles.

Uses the SearchEngine to find candidate profile URLs and InfoCrawler to
retrieve structured profile data for a list of usernames.
"""

import concurrent.futures
import math

from dotenv import load_dotenv
from src.protected.search_engine import SearchEngine
from src.shared.enums import Platform
from src.modules.info_crawler import InfoCrawler
from src.shared.models.ensemble_insta_account import EnsembleInstaAccount
from src.shared.models.ensemble_tiktok_account import EnsembleTiktokAccount

# Load environment variables
load_dotenv()

# Initialize main components
SEARCH_ENGINE = SearchEngine()
INFO_CRAWLER = InfoCrawler()


def search_insta_influencers(
    topic: str,
    location: str,
    keywords: list[str],
    search_results: int = 10,
) -> tuple[list[EnsembleInstaAccount], list[dict[str, any]]]:
    """Find Instagram influencers by topic/location and fetch their data.

    Args:
        topic: Niche to search (e.g., "fitness").
        location: Target location (e.g., "London").
        keywords: Extra terms to refine the search.
        search_results: Max ranked search results to keep.

    Returns:
        A list of EnsembleInstaAccount objects and their simplified dicts.
    """

    # Search for profile URLs
    search_results = SEARCH_ENGINE.search(
        topic=topic,
        location=location,
        keywords=keywords,
        platform=Platform.INSTAGRAM,
        max_results=search_results,
    )

    # if search_results is empty, retry
    if not search_results:
        search_results = SEARCH_ENGINE.search(
            topic=topic,
            location=location,
            keywords=keywords,
            platform=Platform.INSTAGRAM,
            max_results=search_results,
        )

    # Extract usernames from profile URLs
    usernames = [result[0].url.split("/")[-2] for result in search_results]

    # Fetch profile details (and optionally related profiles)
    info = INFO_CRAWLER.crawl_instagram_usernames(
        usernames=usernames,
    )

    # Convert to simplified dicts for downstream agents
    agents_info = [i.to_agent_dict() for i in info]

    return info, agents_info


def search_tiktok_influencers(
    topic: str,
    location: str,
    keywords: list[str],
    search_results: int = 10,
) -> tuple[list[EnsembleTiktokAccount], list[dict[str, any]]]:
    """Find TikTok influencers by topic/location and fetch their data.

    Args:
        topic: Niche to search (e.g., "fitness").
        location: Target location (e.g., "London").
        keywords: Extra terms to refine the search.
        search_results: Max ranked search results to keep.

    Returns:
        A list of EnsembleTiktokAccount objects and their simplified dicts.
    """

    # Search for profile URLs
    results = SEARCH_ENGINE.search_tiktok_accounts(
        topic=topic,
        location=location,
        keywords=keywords,
        max_workers=10,
    )

    # Extract usernames from profile URLs
    usernames = [r.unique_id for r in results[:search_results]]
    results = results[:search_results]

    # Fetch profile details (and optionally related profiles)
    info = INFO_CRAWLER.crawl_tiktok_accounts(
        accounts=results,
    )

    # Convert to simplified dicts for downstream agents
    agents_info = [i.to_agent_dict() for i in info]

    return info, agents_info


def search_tiktok_and_instagram(
    topic: str,
    location: str,
    keywords: list[str],
    search_results: int = 10,
) -> dict[str, dict[str, list]]:
    """Find both TikTok and Instagram influencers in parallel.

    Args:
        topic: Niche to search (e.g., "fitness").
        location: Target location (e.g., "London").
        keywords: Extra terms to refine the search.
        search_results: Total search results to split between platforms (5 each if 10 total).

    Returns:
        A dictionary with 'tiktok' and 'instagram' keys containing their respective results.
        Each platform contains both raw objects and simplified agent dictionaries.
    """
    # Split search results evenly between platforms
    results_per_platform = math.ceil(search_results / 2)

    # Run both searches in parallel
    with concurrent.futures.ThreadPoolExecutor(max_workers=2) as executor:
        # Submit both tasks
        instagram_future = executor.submit(
            search_insta_influencers,
            topic=topic,
            location=location,
            keywords=keywords,
            search_results=results_per_platform,
        )

        tiktok_future = executor.submit(
            search_tiktok_influencers,
            topic=topic,
            location=location,
            keywords=keywords,
            search_results=results_per_platform,
        )

        # Wait for both to complete
        instagram_info, instagram_agents = instagram_future.result()
        tiktok_info, tiktok_agents = tiktok_future.result()

    # Return combined results in the requested format
    return {
        "instagram": {"profiles": instagram_info, "agents": instagram_agents},
        "tiktok": {"profiles": tiktok_info, "agents": tiktok_agents},
    }


def search_instagram_by_usernames(
    usernames: list[str],
) -> tuple[list[EnsembleInstaAccount], list[dict[str, any]]]:
    """Directly fetch Instagram influencer profiles by usernames.

    Args:
        usernames: List of Instagram usernames to fetch (e.g., ["cristiano", "leomessi"]).

    Returns:
        A tuple containing:
        - List of EnsembleInstaAccount objects with full profile data
        - List of simplified dictionaries for agent consumption
    """
    if not usernames:
        return [], []

    # Fetch profile details directly by usernames
    info = INFO_CRAWLER.crawl_instagram_usernames(usernames=usernames)

    # Convert to simplified dicts for downstream agents
    agents_info = [i.to_agent_dict() for i in info]

    return info, agents_info


def search_tiktok_by_usernames(
    usernames: list[str],
) -> tuple[list[EnsembleTiktokAccount], list[dict[str, any]]]:
    """Directly fetch TikTok influencer profiles by usernames.

    Args:
        usernames: List of TikTok usernames to fetch (e.g., ["charlidamelio", "khaby.lame"]).

    Returns:
        A tuple containing:
        - List of EnsembleTiktokAccount objects with full profile data
        - List of simplified dictionaries for agent consumption
    """
    if not usernames:
        return [], []

    info = INFO_CRAWLER.crawl_tiktok_usernames(usernames=usernames)

    # Convert to simplified dicts for downstream agents
    agents_info = [i.to_agent_dict() for i in info]

    return info, agents_info
