"""
Simple Instagram and TikTok profile crawler using ApifyService.

This module exposes a small API to fetch profiles for Instagram and TikTok
usernames, with optional related-profile discovery for Instagram.
"""

from typing import List, Optional, Dict, Any
import json

from src.shared.enums import Platform
from src.shared.services import EnsembleService
from src.shared.services.rapid_service import RapidService
from src.shared.services.supabase_service import SupabaseService

from src.shared.utils import get_logger, FyuzeLogger
from src.shared.models import (
    EnsembleInstaAccount,
    TikTokInfluencer,
    EnsembleTiktokAccount,
    AudienceSnapshot,
)


class InfoCrawler:
    """
    High-level helpers to crawl Instagram and TikTok profiles.

    This class provides methods to:
    - Crawl Instagram profiles by username
    - Crawl TikTok accounts and fetch their videos
    - Handle database caching and synchronization
    - Support both parallel and sequential processing
    """

    def __init__(self, enable_sync: bool = True) -> None:
        """
        Initialize the InfoCrawler.

        Args:
            enable_sync: Whether to use database sync layer (default: True)
        """
        self._ensemble = EnsembleService()
        self._rapid = RapidService()
        self._logger: FyuzeLogger = get_logger(__name__)
        self._enable_sync = enable_sync

        # Initialize SupabaseService if sync is enabled
        if self._enable_sync:
            try:
                self._supabase = SupabaseService()
                self._logger.info("Database sync layer enabled")
            except Exception as e:
                self._logger.warning(
                    f"Failed to initialize SupabaseService: {e}. Continuing without sync."
                )
                self._enable_sync = False
        else:
            self._supabase = None
            self._logger.info("Database sync layer disabled")

    def crawl_instagram_usernames(
        self,
        usernames: List[str],
    ) -> List[EnsembleInstaAccount]:
        """Fetch Instagram profiles and optionally their related profiles.

        Args:
            usernames: Instagram handles (with or without leading @)

        Returns:
            List of EnsembleInstaAccount objects
        """
        base_usernames = [u.strip().lstrip("@") for u in usernames if u and u.strip()]
        if not base_usernames:
            return []

        self._logger.info(
            f"Processing {len(base_usernames)} Instagram usernames ({base_usernames})"
        )

        # If sync is disabled, use the original crawling approach
        if not self._enable_sync:
            self._logger.info("Sync disabled - crawling all usernames")
            accounts = self._ensemble.scrape_instagram_profiles_parallel(
                usernames=base_usernames,
                max_workers=5,
            )
            return accounts
        # Sync layer: check existing data first
        existing_accounts = []
        usernames_to_crawl: List[str] = []

        try:
            parallel_fetch = self._supabase.get_creators_parallel(
                [(username, "instagram") for username in base_usernames],
                max_workers=min(5, len(base_usernames)),
            )
        except Exception as exc:
            self._logger.warning(
                f"Bulk fetch for Instagram usernames failed ({exc}); will crawl all usernames"
            )
            usernames_to_crawl = list(base_usernames)
        else:
            results_map = {
                item["username"]: item.get("creator")
                for item in parallel_fetch.get("results", [])
            }
            error_map = {
                item.get("username"): item.get("error")
                for item in parallel_fetch.get("errors", [])
                if item.get("username")
            }

            for username in base_usernames:
                if username in error_map:
                    self._logger.warning(
                        f"Error checking cached data for {username}: {error_map[username]}"
                    )
                    usernames_to_crawl.append(username)
                    continue

                existing_data = results_map.get(username)

                if existing_data:
                    # Parse existing data from database
                    platform_data = existing_data.get("platform_data", {})
                    if isinstance(platform_data, str):
                        platform_data = json.loads(platform_data)

                    raw_data = platform_data.get("raw_data", {})
                    if raw_data:
                        account = EnsembleInstaAccount.from_dict(raw_data)
                        existing_accounts.append(account)
                        self._logger.info(
                            f"Using cached data for Instagram user: {username}"
                        )
                    else:
                        self._logger.warning(
                            f"Invalid cached data format for {username}, will re-crawl"
                        )
                        usernames_to_crawl.append(username)
                else:
                    usernames_to_crawl.append(username)

        # Crawl missing usernames
        new_accounts = []
        if usernames_to_crawl:
            self._logger.info(
                f"Crawling {len(usernames_to_crawl)} new Instagram usernames"
            )
            new_accounts = self._ensemble.scrape_instagram_profiles_parallel(
                usernames=usernames_to_crawl,
                max_workers=5,
            )

            # Save newly crawled accounts to database
            save_payload = [
                {
                    "username": account.username,
                    "platform": "instagram",
                    "data": account.to_dict(),
                }
                for account in new_accounts
            ]

            if save_payload:
                account_lookup = {account.username: account for account in new_accounts}
                try:
                    save_results = self._supabase.save_creators_parallel(
                        save_payload,
                        max_workers=min(5, len(save_payload)),
                    )

                    for entry in save_results.get("saved", []):
                        self._logger.info(
                            f"Saved Instagram user to database: {entry.get('username')}"
                        )

                    for entry in save_results.get("errors", []):
                        username = entry.get("username")
                        self._logger.error(
                            f"Failed to save {username} to database: {entry.get('error')}"
                        )
                        account = account_lookup.get(username)
                        if account:
                            try:
                                self._supabase.save_creator(
                                    username=account.username,
                                    platform="instagram",
                                    data=account.to_dict(),
                                )
                                self._logger.info(
                                    f"Retried and saved Instagram user: {account.username}"
                                )
                            except Exception as retry_exc:
                                self._logger.error(
                                    f"Retry failed for {account.username}: {retry_exc}"
                                )
                                print(
                                    f"Failed to save {account.username} to database: {retry_exc}"
                                )
                except Exception as exc:
                    self._logger.error(
                        f"Bulk save for Instagram accounts failed ({exc}); falling back to sequential"
                    )
                    for account in new_accounts:
                        try:
                            self._supabase.save_creator(
                                username=account.username,
                                platform="instagram",
                                data=account.to_dict(),
                            )
                            self._logger.info(
                                f"Saved Instagram user to database: {account.username}"
                            )
                        except Exception as retry_exc:
                            self._logger.error(
                                f"Failed to save {account.username} to database: {retry_exc}"
                            )
                            print(
                                f"Failed to save {account.username} to database: {retry_exc}"
                            )

        # Combine existing and new accounts
        all_accounts = existing_accounts + new_accounts
        self._logger.info(
            f"Returning {len(all_accounts)} Instagram accounts ({len(existing_accounts)} cached, {len(new_accounts)} newly crawled)"
        )

        return all_accounts

    def crawl_insta_stats(
        self,
        usernames: List[str],
        parallel: bool = True,
        max_workers: int = 5,
    ) -> Dict[str, AudienceSnapshot]:
        """Fetch Instagram audience demographic statistics for multiple profiles.

        This method retrieves demographic data including gender distribution, geographic
        distribution, follower types, reachability, interests, and more for the specified
        Instagram profiles using the RapidAPI endpoint.

        Args:
            usernames: Instagram handles (with or without leading @)
            parallel: Whether to fetch statistics in parallel (default: True)
            max_workers: Maximum number of concurrent requests if parallel=True (default: 5)

        Returns:
            Dictionary mapping Instagram URLs to AudienceSnapshot objects.
            Returns empty dict if no data was successfully fetched.

        Example:
            >>> crawler = InfoCrawler()
            >>> stats = crawler.crawl_insta_stats(["therock", "cristiano"])
            >>> for url, snapshot in stats.items():
            ...     print(f"{url}: {snapshot.gender_split.male * 100:.1f}% male followers")
        """
        base_usernames = [u.strip().lstrip("@") for u in usernames if u and u.strip()]
        if not base_usernames:
            self._logger.warning(
                "No valid usernames provided for Instagram stats crawl"
            )
            return {}

        self._logger.info(
            f"Fetching audience statistics for {len(base_usernames)} Instagram profiles "
            f"({'parallel' if parallel else 'sequential'} mode)"
        )

        # Convert usernames to full Instagram URLs
        instagram_urls = [
            f"https://www.instagram.com/{username}/" for username in base_usernames
        ]

        try:
            # Fetch snapshots using RapidService
            snapshots = self._rapid.get_audience_snapshots(
                instagram_urls=instagram_urls,
                parallel=parallel,
                max_workers=max_workers,
            )

            # Map URLs to their corresponding snapshots
            stats_map = {}
            for url, snapshot in zip(instagram_urls, snapshots):
                if snapshot:
                    stats_map[url] = snapshot
                    self._logger.info(f"Successfully fetched stats for {url}")
                else:
                    self._logger.warning(f"Failed to fetch stats for {url}")

            self._logger.info(
                f"Retrieved audience statistics for {len(stats_map)} out of {len(instagram_urls)} profiles"
            )

            return stats_map

        except Exception as e:
            self._logger.error(f"Error fetching Instagram statistics: {e}")
            return {}

    def crawl_tiktok_usernames(
        self,
        usernames: List[str],
        depth: int = 1,
    ) -> List[EnsembleTiktokAccount]:
        """Fetch TikTok accounts by usernames and enrich them with videos.

        Args:
            usernames: TikTok handles (with or without leading @)
            depth: Number of pages to fetch for video data (default: 1)

        Returns:
            List of EnsembleTiktokAccount objects
        """

        base_usernames = [u.strip().lstrip("@") for u in usernames if u and u.strip()]
        if not base_usernames:
            return []

        fetched_accounts: List[EnsembleTiktokAccount] = []
        try:
            fetched_accounts = self._ensemble.get_tiktok_by_username_parallel(
                usernames=base_usernames,
                max_workers=min(5, len(base_usernames)),
            )
        except Exception as exc:
            print(f"Failed to fetch TikTok accounts via Ensemble: {exc}")

        # Preserve requested order and create placeholders for any misses
        fetched_map = {
            account.unique_id.lower(): account for account in fetched_accounts
        }

        ordered_accounts: List[EnsembleTiktokAccount] = []
        for username in base_usernames:
            account = fetched_map.get(username.lower())
            if not account:
                account = EnsembleTiktokAccount(
                    uid="",
                    unique_id=username,
                    nickname=username,
                )
            ordered_accounts.append(account)

        return self.crawl_tiktok_accounts(accounts=ordered_accounts, depth=depth)

    def crawl_tiktok_accounts(
        self,
        accounts: List[EnsembleTiktokAccount],
        depth: int = 1,
    ) -> List[EnsembleTiktokAccount]:
        """
        Crawl TikTok accounts and fetch their videos if not already present.

        This method takes a list of EnsembleTiktokAccount objects, checks if they exist
        in the database with complete video data, and fetches videos for accounts that
        don't have them. Accounts are then saved to the database.

        Args:
            accounts: List of EnsembleTiktokAccount objects to process
            depth: Number of pages to fetch for video data (default: 1)

        Returns:
            List of EnsembleTiktokAccount objects with complete video data
        """
        if not accounts:
            return []

        self._logger.info(f"Processing {len(accounts)} TikTok accounts for video data")

        # If sync is disabled, fetch videos for all accounts without database interaction
        if not self._enable_sync:
            self._logger.info("Sync disabled - fetching videos for all accounts")
            return self._fetch_videos_for_accounts(accounts, depth)

        # Sync layer: check existing data first
        existing_accounts: List[EnsembleTiktokAccount] = []
        accounts_to_process: List[EnsembleTiktokAccount] = []

        fetchable_accounts = [account for account in accounts if account.unique_id]
        parallel_fetch = {"results": [], "errors": []}

        if fetchable_accounts:
            try:
                parallel_fetch = self._supabase.get_creators_parallel(
                    [(account.unique_id, "tiktok") for account in fetchable_accounts],
                    max_workers=min(5, len(fetchable_accounts)),
                )
            except Exception as exc:
                self._logger.warning(
                    f"Bulk fetch for TikTok accounts failed ({exc}); processing all accounts"
                )
                accounts_to_process = list(accounts)

        if not accounts_to_process:
            results_map = {
                item["username"]: item.get("creator")
                for item in parallel_fetch.get("results", [])
            }
            error_map = {
                item.get("username"): item.get("error")
                for item in parallel_fetch.get("errors", [])
                if item.get("username")
            }

            for account in accounts:
                if not account.unique_id:
                    self._logger.info(
                        "Account without unique_id detected, will process directly"
                    )
                    accounts_to_process.append(account)
                    continue

                if account.unique_id in error_map:
                    self._logger.warning(
                        f"Error checking cached data for {account.unique_id}: {error_map[account.unique_id]}"
                    )
                    accounts_to_process.append(account)
                    continue

                existing_data = results_map.get(account.unique_id)

                if existing_data:
                    platform_data = existing_data.get("platform_data", {})
                    if isinstance(platform_data, str):
                        platform_data = json.loads(platform_data)

                    raw_data = platform_data.get("raw_data", {})
                    videos_data = platform_data.get("videos", {})

                    if raw_data and videos_data and videos_data.get("count", 0) > 0:
                        cached_account = EnsembleTiktokAccount.from_dict(
                            raw_data, videos_data.get("videos", [])
                        )
                        existing_accounts.append(cached_account)
                        self._logger.info(
                            f"Using cached TikTok data for user: {account.unique_id} "
                            f"({videos_data.get('count', 0)} videos)"
                        )
                    else:
                        self._logger.info(
                            f"Account {account.unique_id} found in DB but missing video data, will fetch videos"
                        )
                        accounts_to_process.append(account)
                else:
                    accounts_to_process.append(account)

        # Process accounts that need video data
        processed_accounts = []
        if accounts_to_process:
            self._logger.info(
                f"Fetching videos for {len(accounts_to_process)} TikTok accounts"
            )
            processed_accounts = self._fetch_videos_for_accounts(
                accounts_to_process, depth
            )

            # Save processed accounts to database
            save_payload = [
                {
                    "username": account.unique_id,
                    "platform": "tiktok",
                    "data": account.to_dict(),
                }
                for account in processed_accounts
                if account.unique_id
            ]

            if save_payload:
                account_lookup = {
                    account.unique_id: account
                    for account in processed_accounts
                    if account.unique_id
                }

                try:
                    save_results = self._supabase.save_creators_parallel(
                        save_payload,
                        max_workers=min(5, len(save_payload)),
                    )

                    for entry in save_results.get("saved", []):
                        self._logger.info(
                            f"Saved TikTok account to database: {entry.get('username')}"
                        )

                    for entry in save_results.get("errors", []):
                        username = entry.get("username")
                        self._logger.error(
                            f"Failed to save {username} to database: {entry.get('error')}"
                        )
                        account = account_lookup.get(username)
                        if account:
                            try:
                                self._supabase.save_creator(
                                    username=account.unique_id,
                                    platform="tiktok",
                                    data=account.to_dict(),
                                )
                                self._logger.info(
                                    f"Retried and saved TikTok account: {account.unique_id}"
                                )
                            except Exception as retry_exc:
                                self._logger.error(
                                    f"Retry failed for {account.unique_id}: {retry_exc}"
                                )
                                print(
                                    f"Failed to save {account.unique_id} to database: {retry_exc}"
                                )
                except Exception as exc:
                    self._logger.error(
                        f"Bulk save for TikTok accounts failed ({exc}); falling back to sequential"
                    )
                    for account in processed_accounts:
                        if not account.unique_id:
                            continue
                        try:
                            self._supabase.save_creator(
                                username=account.unique_id,
                                platform="tiktok",
                                data=account.to_dict(),
                            )
                            self._logger.info(
                                f"Saved TikTok account to database: {account.unique_id}"
                            )
                        except Exception as retry_exc:
                            self._logger.error(
                                f"Failed to save {account.unique_id} to database: {retry_exc}"
                            )
                            print(
                                f"Failed to save {account.unique_id} to database: {retry_exc}"
                            )

        # Combine existing and processed accounts
        all_accounts = existing_accounts + processed_accounts
        self._logger.info(
            f"Returning {len(all_accounts)} TikTok accounts "
            f"({len(existing_accounts)} cached, {len(processed_accounts)} newly processed)"
        )

        return all_accounts

    def _fetch_videos_for_accounts(
        self, accounts: List[EnsembleTiktokAccount], depth: int = 1
    ) -> List[EnsembleTiktokAccount]:
        """
        Fetch videos for TikTok accounts using EnsembleService.

        Args:
            accounts: List of EnsembleTiktokAccount objects to fetch videos for
            depth: Number of pages to fetch per account

        Returns:
            List of EnsembleTiktokAccount objects with updated video data
        """
        if not accounts:
            return []

        # Extract usernames from accounts
        usernames = [account.unique_id for account in accounts]

        try:
            # Fetch videos using EnsembleService parallel processing
            videos_list = self._ensemble.fetch_tiktok_user_videos(
                usernames=usernames,
                depth=depth,
                parallel=True,
                max_workers=min(
                    5, len(usernames)
                ),  # Limit workers based on account count
            )

            # Create mapping of username to videos
            username_to_videos = {}
            for i, videos in enumerate(videos_list):
                if i < len(usernames) and videos:
                    username_to_videos[usernames[i]] = videos

            # Update accounts with fetched videos
            updated_accounts = []
            for account in accounts:
                if account.unique_id in username_to_videos:
                    # Update account with fetched videos
                    videos = username_to_videos[account.unique_id]
                    account.videos = videos
                    updated_accounts.append(account)
                    self._logger.info(
                        f"Updated {account.unique_id} with {videos.count} videos"
                    )
                else:
                    # No videos found, but still include the account
                    self._logger.warning(
                        f"No videos found for {account.unique_id}, keeping account without videos"
                    )
                    updated_accounts.append(account)

            return updated_accounts

        except Exception as e:
            self._logger.error(f"Error fetching videos for TikTok accounts: {e}")
            # Return original accounts even if video fetching fails
            return accounts
