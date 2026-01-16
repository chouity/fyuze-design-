"""Generate marketing insights report for Instagram influencers.

Uses InfoCrawler to fetch Instagram profile data (with caching), RapidService
to get audience demographics, and the marketing expert agent to analyze and
generate a comprehensive insights report.
"""

from dotenv import load_dotenv
from src.modules.info_crawler import InfoCrawler
from src.shared.services.rapid_service import RapidService
from src.agent.insta_marketing_expert import insta_marketing_expert
from src.shared.models.marketing_insights_report import MarketingInsightsReport

# Load environment variables
load_dotenv()

# Initialize services
INFO_CRAWLER = InfoCrawler()
RAPID_SERVICE = RapidService()


def get_insta_report(username: str) -> MarketingInsightsReport:
    """Generate a comprehensive marketing insights report for an Instagram profile.

    This function orchestrates the complete workflow:
    1. Fetches Instagram profile data using InfoCrawler (with caching)
    2. Fetches audience demographics using RapidService
    3. Combines the data and generates insights using the marketing expert agent

    Args:
        username: Instagram username (e.g., "daddyfoody").

    Returns:
        A MarketingInsightsReport object containing:
        - Account overview and niche analysis
        - Audience insights and demographics
        - Content performance analysis
        - Engagement quality metrics
        - Growth forecasting
        - Strategic recommendations
        - Executive summary narrative

    Example:
        >>> report = get_insta_report("daddyfoody")
        >>> print(report.summary_narrative)
    """
    # Step 1: Fetch Instagram profile data (with caching)
    ensemble_account = INFO_CRAWLER.crawl_instagram_usernames([username])[0]
    ensemble_summary = ensemble_account.get_agent_summary()

    # Step 2: Fetch audience demographics
    profile_url = f"https://www.instagram.com/{username}/"
    rapid_response = RAPID_SERVICE.get_audience_snapshot(profile_url)
    rapid_summary = rapid_response.get_agent_summary()

    # Step 3: Combine data and generate insights report
    combined_input = f"{ensemble_summary}\n\n{rapid_summary}"
    report = insta_marketing_expert.run(combined_input)

    return report.content


def get_insta_report_ensemble_only(username: str) -> MarketingInsightsReport:
    """Generate a marketing insights report using only profile data.

    This is a fallback function when audience demographics are not available
    or not needed. The agent will infer probable audience based on content
    style and engagement patterns. Uses InfoCrawler with caching.

    Args:
        username: Instagram username (e.g., "daddyfoody").

    Returns:
        A MarketingInsightsReport object with insights based on profile data only.

    Example:
        >>> report = get_insta_report_ensemble_only("daddyfoody")
        >>> print(report.strategic_recommendations)
    """
    # Fetch Instagram profile data (with caching)
    ensemble_account = INFO_CRAWLER.crawl_instagram_usernames([username])[0]
    ensemble_summary = ensemble_account.get_agent_summary()

    # Generate insights report from profile data only
    report = insta_marketing_expert.run(ensemble_summary)

    return report.content
