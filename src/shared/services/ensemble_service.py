from os import environ
import concurrent.futures
from typing import List, Optional, Tuple

from ensembledata.api import EDClient

from src.shared.utils import get_logger, FyuzeLogger, retry
from src.shared.exceptions import ConfigurationError
from src.shared.models import EnsembleInstaAccount, EnsembleTiktokAccount
from src.shared.models.ensemble_tiktok_account import TikTokVideos


class EnsembleService:
    """
    Service for interacting with the Ensemble Data API to scrape social media profiles.

    This service provides methods to fetch detailed profile information from Instagram
    and search for TikTok content creators using the Ensemble Data platform, which
    offers high-quality social media data. Supports both sequential and parallel
    processing for improved performance with multiple requests.
    """

    def __init__(self):
        """Initialize the EnsembleService with logger and client."""
        self._logger: FyuzeLogger = get_logger(__name__)
        self._client: Optional[EDClient] = None

    def _init_client(self) -> None:
        """
        Initialize the Ensemble Data client with API token from environment.

        Raises:
            ConfigurationError: If ENSEMBLE_API_KEY is not found in environment variables.
        """
        api_token = environ.get("ENSEMBLE_API_KEY")
        if api_token:
            self._logger.info("Initializing Ensemble Data client.")
            self._client = EDClient(token=api_token)
            self._logger.info("Ensemble Data client initialized successfully.")
        else:
            self._logger.error("ENSEMBLE_API_KEY not found in environment variables.")
            raise ConfigurationError(
                "ENSEMBLE_API_KEY not found in environment variables."
            )

    def _fetch_single_profile(
        self, username: str
    ) -> Tuple[str, Optional[EnsembleInstaAccount]]:
        """
        Fetch a single Instagram profile. Helper method for parallel processing.

        Args:
            username: Instagram username to scrape

        Returns:
            Tuple of (username, profile) where profile is None if failed
        """
        try:
            self._logger.info(f"Fetching profile data for username: {username}")

            # Get detailed user information from Ensemble Data API
            result = self._client.instagram.user_detailed_info(username=username)

            # Log API usage
            self._logger.info(
                f"API units charged for {username}: {result.units_charged}"
            )

            # Convert API response to EnsembleInstaAccount object
            profile = EnsembleInstaAccount.from_dict(result.data)

            self._logger.info(f"Successfully scraped profile for {username}")
            return username, profile

        except Exception as e:
            self._logger.error(f"Error scraping profile for {username}: {e}")
            return username, None

    def _search_single_tiktok_keyword(
        self,
        keyword: str,
        period: str = "90",
        max_results: Optional[int] = None,
    ) -> Tuple[str, List[EnsembleTiktokAccount]]:
        """
        Search TikTok for a single keyword. Helper method for parallel processing.

        Args:
            keyword: Search keyword/phrase
            period: Search period
            max_results: Maximum number of results to return

        Returns:
            Tuple of (keyword, accounts) where accounts is empty list if failed
        """
        try:
            self._logger.info(f"Searching TikTok for keyword: '{keyword}'")

            # Search TikTok using Ensemble Data API
            result = self._client.tiktok.keyword_search(
                keyword=keyword,
                period=period,
            )

            # Log API usage
            self._logger.info(
                f"TikTok search API units charged for '{keyword}': {result.units_charged}"
            )

            # Extract data and convert to our models
            accounts = []
            if result.data and "data" in result.data:
                search_results = result.data["data"]

                # Apply max_results limit if specified
                if max_results:
                    search_results = search_results[:max_results]

                for item in search_results:
                    try:
                        # Extract author/account data and video data
                        aweme_info = item.get("aweme_info", {})
                        author_data = aweme_info.get("author", {})

                        # Create account with the single video from search result
                        videos_data = [aweme_info] if aweme_info else []

                        account = EnsembleTiktokAccount.from_dict(
                            author_data, videos_data
                        )
                        accounts.append(account)

                        self._logger.debug(
                            f"Successfully parsed TikTok account: @{account.unique_id}"
                        )

                    except Exception as e:
                        self._logger.warning(
                            f"Failed to parse TikTok account data: {e}"
                        )
                        continue

            self._logger.info(
                f"Successfully found {len(accounts)} TikTok accounts for keyword: '{keyword}'"
            )
            return keyword, accounts

        except Exception as e:
            self._logger.error(f"Error searching TikTok for keyword '{keyword}': {e}")
            return keyword, []

    def _fetch_single_tiktok_user_videos(
        self, username: str, depth: int = 1
    ) -> Tuple[str, Optional[TikTokVideos]]:
        """
        Fetch videos from a single TikTok user. Helper method for parallel processing.

        Args:
            username: TikTok username to fetch videos from
            depth: Number of pages to fetch (default: 1)

        Returns:
            Tuple of (username, videos) where videos is None if failed
        """
        try:
            self._logger.info(f"Fetching TikTok videos for username: {username}")

            # Get user posts from Ensemble Data API
            result = self._client.tiktok.user_posts_from_username(
                username=username,
                depth=depth,
            )

            # Log API usage
            self._logger.info(
                f"TikTok user videos API units charged for {username}: {result.units_charged}"
            )

            # Extract videos data
            videos = None
            if result.data and "data" in result.data:
                videos_data = result.data["data"]
                videos = TikTokVideos.from_dict(videos_data)
                self._logger.info(
                    f"Successfully fetched {videos.count} videos for @{username}"
                )
            else:
                self._logger.warning(f"No video data found for @{username}")
                print(f"No video data found for @{username}")

            return username, videos

        except Exception as e:
            self._logger.error(f"Error fetching TikTok videos for {username}: {e}")
            return username, None

    def _fetch_single_tiktok_user_info(
        self, username: str
    ) -> Tuple[str, Optional[EnsembleTiktokAccount]]:
        """
        Fetch TikTok user info from a single username. Helper method for parallel processing.

        Args:
            username: TikTok username to fetch info from (without @ symbol)

        Returns:
            Tuple of (username, account) where account is None if failed
        """
        try:
            self._logger.info(f"Fetching TikTok user info for username: {username}")

            # Get user info from Ensemble Data API
            result = self._client.tiktok.user_info_from_username(
                username=username,
            )

            # Log API usage
            self._logger.info(
                f"TikTok user info API units charged for {username}: {result.units_charged}"
            )

            # Convert API response to EnsembleTiktokAccount object
            account = None
            if result.data:
                account = EnsembleTiktokAccount.from_direct_dict(result.data, [])
                self._logger.info(f"Successfully fetched user info for @{username}")

            return username, account

        except Exception as e:
            self._logger.error(f"Error fetching TikTok user info for {username}: {e}")
            return username, None

    @retry(max_attempts=3, delay=1)
    def scrape_instagram_profiles_parallel(
        self,
        usernames: List[str],
        max_workers: int = 5,
    ) -> List[EnsembleInstaAccount]:
        """
        Scrape Instagram profiles in parallel for faster processing.

        This method uses ThreadPoolExecutor to fetch multiple profiles concurrently,
        significantly reducing total execution time for large lists of usernames.

        Args:
            usernames: List of Instagram usernames to scrape (without @ symbol)
            max_workers: Maximum number of concurrent threads (default: 5)

        Returns:
            List of EnsembleInstaAccount objects containing profile data

        Raises:
            ConfigurationError: If API client is not properly configured

        Example:
            >>> ensemble_service = EnsembleService()
            >>> profiles = ensemble_service.scrape_instagram_profiles_parallel(
            ...     ["user1", "user2", "user3"], max_workers=3
            ... )
            >>> print(f"Scraped {len(profiles)} profiles")
        """
        if not self._client:
            self._init_client()

        self._logger.info(
            #     f"Scraping Instagram profiles in parallel for {len(usernames)} usernames "
            f"using {max_workers} workers"
        )

        profiles = []

        with concurrent.futures.ThreadPoolExecutor(max_workers=max_workers) as executor:
            # Submit all profile fetch tasks
            future_to_username = {
                executor.submit(self._fetch_single_profile, username): username
                for username in usernames
            }

            # Collect results as they complete
            for future in concurrent.futures.as_completed(future_to_username):
                username, profile = future.result()
                if profile:
                    profiles.append(profile)

        self._logger.info(
            f"Successfully scraped {len(profiles)} out of {len(usernames)} profiles in parallel"
        )
        return profiles

    @retry(max_attempts=3, delay=1)
    def fetch_tiktok_user_videos_parallel(
        self,
        usernames: List[str],
        depth: int = 1,
        max_workers: int = 5,
    ) -> List[TikTokVideos]:
        """
        Fetch TikTok user videos in parallel for faster processing.

        This method uses ThreadPoolExecutor to fetch videos from multiple users concurrently,
        significantly reducing total execution time for large lists of usernames.

        Args:
            usernames: List of TikTok usernames to fetch videos from (without @ symbol)
            depth: Number of pages to fetch per user (default: 1)
            max_workers: Maximum number of concurrent threads (default: 5)

        Returns:
            List of TikTokVideos objects containing video data

        Raises:
            ConfigurationError: If API client is not properly configured

        Example:
            >>> ensemble_service = EnsembleService()
            >>> videos_list = ensemble_service.fetch_tiktok_user_videos_parallel(
            ...     ["user1", "user2", "user3"], depth=2, max_workers=3
            ... )
            >>> print(f"Fetched videos from {len(videos_list)} users")
        """
        if not self._client:
            self._init_client()

        self._logger.info(
            #     f"Fetching TikTok videos in parallel for {len(usernames)} usernames "
            f"using {max_workers} workers with depth={depth}"
        )

        videos_list = []

        with concurrent.futures.ThreadPoolExecutor(max_workers=max_workers) as executor:
            # Submit all video fetch tasks
            future_to_username = {
                executor.submit(
                    self._fetch_single_tiktok_user_videos, username, depth
                ): username
                for username in usernames
            }

            # Collect results as they complete
            for future in concurrent.futures.as_completed(future_to_username):
                username, videos = future.result()
                if videos:
                    videos_list.append(videos)

        self._logger.info(
            f"Successfully fetched videos from {len(videos_list)} out of {len(usernames)} users in parallel"
        )
        return videos_list

    @retry(max_attempts=3, delay=1)
    def get_tiktok_by_username_parallel(
        self,
        usernames: List[str],
        max_workers: int = 5,
    ) -> List[EnsembleTiktokAccount]:
        """
        Get TikTok user information by username in parallel for faster processing.

        This method uses ThreadPoolExecutor to fetch user info from multiple TikTok
        accounts concurrently, significantly reducing total execution time for large
        lists of usernames.

        Args:
            usernames: List of TikTok usernames to fetch info from (without @ symbol)
            max_workers: Maximum number of concurrent threads (default: 5)

        Returns:
            List of EnsembleTiktokAccount objects containing user information

        Raises:
            ConfigurationError: If API client is not properly configured

        Example:
            >>> ensemble_service = EnsembleService()
            >>> accounts = ensemble_service.get_tiktok_by_username_parallel(
            ...     ["daviddobrik", "charlidamelio", "addisonre"], max_workers=3
            ... )
            >>> for account in accounts:
            ...     print(f"@{account.unique_id}: {account.follower_count} followers")
        """
        if not self._client:
            self._init_client()

        self._logger.info(
            #     f"Fetching TikTok user info in parallel for {len(usernames)} usernames "
            f"using {max_workers} workers"
        )

        accounts = []

        with concurrent.futures.ThreadPoolExecutor(max_workers=max_workers) as executor:
            # Submit all user info fetch tasks
            future_to_username = {
                executor.submit(self._fetch_single_tiktok_user_info, username): username
                for username in usernames
            }

            # Collect results as they complete
            for future in concurrent.futures.as_completed(future_to_username):
                username, account = future.result()
                if account:
                    accounts.append(account)

        # Get

        self._logger.info(
            f"Successfully fetched user info for {len(accounts)} out of {len(usernames)} accounts in parallel"
        )
        return accounts

    @retry(max_attempts=3, delay=1)
    def search_tiktok_parallel(
        self,
        keywords: List[str],
        period: str = "90",
        max_results_per_keyword: Optional[int] = None,
        max_workers: int = 5,
    ) -> List[EnsembleTiktokAccount]:
        """
        Search TikTok for multiple keywords in parallel for faster processing.

        This method uses ThreadPoolExecutor to search multiple keywords concurrently,
        significantly reducing total execution time for large lists of keywords.
        Accounts are scored based on frequency across searches and returned in order.

        Args:
            keywords: List of search keywords/phrases
            period: Search period - "1" for recent, other values may be supported
            max_results_per_keyword: Maximum number of results per keyword (optional)
            max_workers: Maximum number of concurrent threads (default: 5)

        Returns:
            List of EnsembleTiktokAccount objects sorted by relevance score (highest first)

        Raises:
            ConfigurationError: If API client is not properly configured

        Example:
            >>> ensemble_service = EnsembleService()
            >>> accounts = ensemble_service.search_tiktok_parallel(
            ...     ["Lebanese Food", "Tripoli Restaurant", "Food Blog"],
            ...     max_workers=3
            ... )
            >>> print(f"Found {len(accounts)} accounts across all keywords")
        """
        if not self._client:
            self._init_client()

        self._logger.info(
            #     f"Searching TikTok in parallel for {len(keywords)} keywords "
            f"using {max_workers} workers"
        )

        account_scores = {}  # Track accounts and their scores
        account_objects = {}  # Store the actual account objects

        with concurrent.futures.ThreadPoolExecutor(max_workers=max_workers) as executor:
            # Submit all keyword search tasks
            future_to_keyword = {
                executor.submit(
                    self._search_single_tiktok_keyword,
                    keyword,
                    period,
                    max_results_per_keyword,
                ): keyword
                for keyword in keywords
            }

            # Collect results as they complete
            for future in concurrent.futures.as_completed(future_to_keyword):
                keyword, accounts = future.result()
                if accounts:
                    for account in accounts:
                        uid = account.unique_id
                        # Increment score for each appearance
                        account_scores[uid] = account_scores.get(uid, 0) + 1
                        # Store the account object (first occurrence)
                        if uid not in account_objects:
                            account_objects[uid] = account

        self._logger.info(
            #     f"Aggregated results from {len(keywords)} keywords, "
            f"found {len(account_objects)} unique accounts before scoring"
        )
        # Sort accounts by score (highest first)
        sorted_accounts = sorted(
            account_objects.items(), key=lambda x: account_scores[x[0]], reverse=True
        )

        # Extract just the account objects in sorted order
        unique_accounts = [account for _, account in sorted_accounts]

        self._logger.info(
            f"Accounts sorted by relevance score based on frequency across keywords"
        )
        total_results = sum(account_scores.values())
        self._logger.info(
            #     f"Successfully found {len(unique_accounts)} unique TikTok accounts "
            #     f"from {len(keywords)} keywords in parallel "
            f"(total results before deduplication: {total_results}, sorted by relevance)"
        )
        return unique_accounts

    @retry(max_attempts=3, delay=1)
    def scrape_instagram_profiles(
        self, usernames: List[str], parallel: bool = True, max_workers: int = 5
    ) -> List[EnsembleInstaAccount]:
        """
        Scrape Instagram profiles for given usernames using Ensemble Data API.

        This method fetches detailed profile information for each username including
        bio, follower counts, posts, and other profile metadata.

        Args:
            usernames: List of Instagram usernames to scrape (without @ symbol)
            parallel: Whether to use parallel processing (default: True)
            max_workers: Maximum number of concurrent threads when parallel=True (default: 5)

        Returns:
            List of EnsembleInstaAccount objects containing profile data

        Raises:
            ConfigurationError: If API client is not properly configured
            Exception: If API request fails after retries

        Example:
            >>> ensemble_service = EnsembleService()
            >>> # Parallel processing (default)
            >>> profiles = ensemble_service.scrape_instagram_profiles(["username1", "username2"])
            >>> # Sequential processing
            >>> profiles = ensemble_service.scrape_instagram_profiles(["username1"], parallel=False)
        """
        if parallel and len(usernames) > 1:
            return self.scrape_instagram_profiles_parallel(usernames, max_workers)

        # Sequential processing
        if not self._client:
            self._init_client()

        self._logger.info(f"Scraping Instagram profiles for {len(usernames)} usernames")

        profiles = []

        for username in usernames:
            username, profile = self._fetch_single_profile(username)
            if profile:
                profiles.append(profile)

        self._logger.info(
            f"Successfully scraped {len(profiles)} out of {len(usernames)} profiles"
        )
        return profiles

    def get_profile_by_username(self, username: str) -> Optional[EnsembleInstaAccount]:
        """
        Get a single Instagram profile by username.

        Convenience method for fetching a single profile instead of a list.

        Args:
            username: Instagram username to scrape (without @ symbol)

        Returns:
            EnsembleInstaAccount object if successful, None if failed

        Example:
            >>> ensemble_service = EnsembleService()
            >>> profile = ensemble_service.get_profile_by_username("username")
            >>> if profile:
            ...     print(f"Found profile: {profile.full_name}")
        """
        profiles = self.scrape_instagram_profiles([username])
        return profiles[0] if profiles else None

    def get_tiktok_by_username(self, username: str) -> Optional[EnsembleTiktokAccount]:
        """
        Get a single TikTok user account by username.

        Convenience method for fetching a single TikTok user instead of a list.

        Args:
            username: TikTok username to fetch (without @ symbol)

        Returns:
            EnsembleTiktokAccount object if successful, None if failed

        Example:
            >>> ensemble_service = EnsembleService()
            >>> account = ensemble_service.get_tiktok_by_username("daviddobrik")
            >>> if account:
            ...     print(f"Found account: @{account.unique_id} with {account.follower_count} followers")
        """
        accounts = self.get_tiktok_by_username_parallel([username])
        return accounts[0] if accounts else None

    @retry(max_attempts=3, delay=1)
    def search_tiktok(
        self,
        keywords: List[str],
        period: str = "1",
        max_results_per_keyword: Optional[int] = None,
        parallel: bool = True,
        max_workers: int = 5,
    ) -> List[EnsembleTiktokAccount]:
        """
        Search TikTok for content creators and influencers using keywords.

        This method uses the Ensemble Data API to search for TikTok accounts
        based on keywords and returns detailed account information including
        follower counts, videos, and engagement metrics.

        Args:
            keywords: List of search keywords/phrases (e.g., ["Food Blog", "Lebanese Cuisine"])
            period: Search period - "1" for recent, other values may be supported
            max_results_per_keyword: Maximum number of results per keyword (optional)
            parallel: Whether to use parallel processing (default: True)
            max_workers: Maximum number of concurrent threads when parallel=True (default: 5)

        Returns:
            List of EnsembleTiktokAccount objects containing account data

        Raises:
            ConfigurationError: If API client is not properly configured
            Exception: If API request fails after retries

        Example:
            >>> ensemble_service = EnsembleService()
            >>> # Parallel processing (default)
            >>> accounts = ensemble_service.search_tiktok(["Food Blogger Lebanon", "Lebanese Cuisine"])
            >>> # Sequential processing
            >>> accounts = ensemble_service.search_tiktok(["Food Blog"], parallel=False)
            >>> for account in accounts:
            ...     print(f"@{account.unique_id}: {account.follower_count} followers")
        """
        if parallel and len(keywords) > 1:
            return self.search_tiktok_parallel(
                keywords, period, max_results_per_keyword, max_workers
            )

        # Sequential processing
        if not self._client:
            self._init_client()

        self._logger.info(f"Searching TikTok for {len(keywords)} keywords sequentially")

        all_accounts = []

        for keyword in keywords:
            keyword, accounts = self._search_single_tiktok_keyword(
                keyword, period, max_results_per_keyword
            )
            if accounts:
                all_accounts.extend(accounts)

        # Remove duplicates based on unique_id (same account might appear in multiple searches)
        seen_uids = set()
        unique_accounts = []
        for account in all_accounts:
            if account.unique_id not in seen_uids:
                seen_uids.add(account.unique_id)
                unique_accounts.append(account)

        self._logger.info(
            #     f"Successfully found {len(unique_accounts)} unique TikTok accounts "
            #     f"from {len(keywords)} keywords sequentially "
            f"(total results before deduplication: {len(all_accounts)})"
        )
        return unique_accounts

    @retry(max_attempts=3, delay=1)
    def fetch_tiktok_user_videos(
        self,
        usernames: List[str],
        depth: int = 1,
        parallel: bool = True,
        max_workers: int = 5,
    ) -> List[TikTokVideos]:
        """
        Fetch TikTok user videos for given usernames using Ensemble Data API.

        This method fetches videos from TikTok user profiles, including video metadata,
        engagement metrics, and content details.

        Args:
            usernames: List of TikTok usernames to fetch videos from (without @ symbol)
            depth: Number of pages to fetch per user (default: 1)
            parallel: Whether to use parallel processing (default: True)
            max_workers: Maximum number of concurrent threads when parallel=True (default: 5)

        Returns:
            List of TikTokVideos objects containing video data

        Raises:
            ConfigurationError: If API client is not properly configured
            Exception: If API request fails after retries

        Example:
            >>> ensemble_service = EnsembleService()
            >>> # Parallel processing (default)
            >>> videos_list = ensemble_service.fetch_tiktok_user_videos(
            ...     ["user1", "user2"], depth=2
            ... )
            >>> # Sequential processing
            >>> videos_list = ensemble_service.fetch_tiktok_user_videos(
            ...     ["user1"], parallel=False
            ... )
            >>> for videos in videos_list:
            ...     print(f"Found {videos.count} videos")
        """
        if parallel and len(usernames) > 1:
            return self.fetch_tiktok_user_videos_parallel(usernames, depth, max_workers)

        # Sequential processing
        if not self._client:
            self._init_client()

        self._logger.info(
            f"Fetching TikTok videos for {len(usernames)} usernames sequentially with depth={depth}"
        )

        videos_list = []

        for username in usernames:
            username, videos = self._fetch_single_tiktok_user_videos(username, depth)
            if videos:
                videos_list.append(videos)

        self._logger.info(
            f"Successfully fetched videos from {len(videos_list)} out of {len(usernames)} users"
        )
        return videos_list
