from os import environ
import concurrent.futures
from typing import List, Optional, Tuple

import requests

from src.shared.utils import get_logger, FyuzeLogger, retry
from src.shared.exceptions import ConfigurationError
from src.shared.models import AudienceSnapshot


class RapidService:
    """
    Service for interacting with the RapidAPI social media master endpoint.

    This service provides methods to fetch Instagram demographic data and audience
    snapshots using the RapidAPI platform. Supports both sequential and parallel
    processing for improved performance with multiple requests.
    """

    BASE_URL = "https://social-media-master.p.rapidapi.com"
    DEMOGRAPHIC_ENDPOINT = f"{BASE_URL}/instagram-user-demographic"

    def __init__(self):
        """Initialize the RapidService with logger and headers."""
        self._logger: FyuzeLogger = get_logger(__name__)
        self._headers: Optional[dict] = None

    def _init_headers(self) -> None:
        """
        Initialize headers with RapidAPI credentials from environment.

        Raises:
            ConfigurationError: If required API keys are not found in environment variables.
        """
        api_key = environ.get("RAPID_API_KEY")
        api_host = environ.get("RAPID_API_HOST", "social-media-master.p.rapidapi.com")

        if not api_key:
            self._logger.error("RAPID_API_KEY not found in environment variables.")
            raise ConfigurationError(
                "RAPID_API_KEY not found in environment variables."
            )

        self._headers = {
            "x-rapidapi-key": api_key,
            "x-rapidapi-host": api_host,
        }
        self._logger.info("RapidAPI headers initialized successfully.")

    def _fetch_single_audience_snapshot(
        self, instagram_url: str
    ) -> Tuple[str, Optional[AudienceSnapshot]]:
        """
        Fetch a single Instagram audience snapshot. Helper method for parallel processing.

        Args:
            instagram_url: Instagram profile URL (e.g., https://www.instagram.com/username)

        Returns:
            Tuple of (url, snapshot) where snapshot is None if failed
        """
        try:
            if not self._headers:
                self._init_headers()

            self._logger.info(f"Fetching audience snapshot for: {instagram_url}")

            params = {"url": instagram_url}
            response = requests.get(
                self.DEMOGRAPHIC_ENDPOINT,
                headers=self._headers,
                params=params,
                timeout=30,
            )
            response.raise_for_status()

            raw_data = response.json()

            # Convert API response to AudienceSnapshot object
            snapshot = AudienceSnapshot.from_raw(raw_data)

            self._logger.info(f"Successfully fetched snapshot for: {instagram_url}")
            return instagram_url, snapshot

        except requests.exceptions.RequestException as e:
            self._logger.error(
                f"Request error fetching audience snapshot for {instagram_url}: {e}"
            )
            return instagram_url, None
        except Exception as e:
            self._logger.error(
                f"Error fetching audience snapshot for {instagram_url}: {e}"
            )
            return instagram_url, None

    @retry(max_attempts=3, delay=1)
    def get_audience_snapshot(self, instagram_url: str) -> Optional[AudienceSnapshot]:
        """
        Get audience snapshot for a single Instagram profile.

        Convenience method for fetching a single audience snapshot.

        Args:
            instagram_url: Instagram profile URL (e.g., https://www.instagram.com/username)

        Returns:
            AudienceSnapshot object if successful, None if failed

        Example:
            >>> rapid_service = RapidService()
            >>> snapshot = rapid_service.get_audience_snapshot(
            ...     "https://www.instagram.com/therock"
            ... )
            >>> if snapshot:
            ...     print(f"Top countries: {snapshot.top_countries}")
        """
        _, snapshot = self._fetch_single_audience_snapshot(instagram_url)
        return snapshot

    @retry(max_attempts=3, delay=1)
    def get_audience_snapshots_parallel(
        self,
        instagram_urls: List[str],
        max_workers: int = 5,
    ) -> List[AudienceSnapshot]:
        """
        Fetch audience snapshots for multiple Instagram profiles in parallel.

        This method uses ThreadPoolExecutor to fetch multiple audience snapshots
        concurrently, significantly reducing total execution time for large lists.

        Args:
            instagram_urls: List of Instagram profile URLs to fetch snapshots for
            max_workers: Maximum number of concurrent threads (default: 5)

        Returns:
            List of AudienceSnapshot objects containing demographic data

        Raises:
            ConfigurationError: If API credentials are not properly configured

        Example:
            >>> rapid_service = RapidService()
            >>> urls = [
            ...     "https://www.instagram.com/therock",
            ...     "https://www.instagram.com/cristiano",
            ... ]
            >>> snapshots = rapid_service.get_audience_snapshots_parallel(
            ...     urls, max_workers=3
            ... )
            >>> print(f"Fetched {len(snapshots)} snapshots")
        """
        if not self._headers:
            self._init_headers()

        self._logger.info(
            f"Fetching {len(instagram_urls)} audience snapshots in parallel "
            f"using {max_workers} workers"
        )

        snapshots = []

        with concurrent.futures.ThreadPoolExecutor(max_workers=max_workers) as executor:
            # Submit all snapshot fetch tasks
            future_to_url = {
                executor.submit(self._fetch_single_audience_snapshot, url): url
                for url in instagram_urls
            }

            # Collect results as they complete
            for future in concurrent.futures.as_completed(future_to_url):
                url = future_to_url[future]
                try:
                    _, snapshot = future.result()
                    if snapshot:
                        snapshots.append(snapshot)
                except Exception as e:
                    self._logger.error(
                        f"Error retrieving snapshot for {url} from executor: {e}"
                    )

        self._logger.info(
            f"Successfully fetched {len(snapshots)} out of {len(instagram_urls)} audience snapshots in parallel"
        )
        return snapshots

    @retry(max_attempts=3, delay=1)
    def get_audience_snapshots(
        self,
        instagram_urls: List[str],
        parallel: bool = True,
        max_workers: int = 5,
    ) -> List[AudienceSnapshot]:
        """
        Get audience snapshots for multiple Instagram profiles.

        This method provides a flexible interface to fetch multiple audience snapshots
        with optional sequential or parallel processing.

        Args:
            instagram_urls: List of Instagram profile URLs to fetch snapshots for
            parallel: Whether to fetch in parallel (default: True)
            max_workers: Maximum number of concurrent threads if parallel=True (default: 5)

        Returns:
            List of AudienceSnapshot objects containing demographic data

        Example:
            >>> rapid_service = RapidService()
            >>> urls = [
            ...     "https://www.instagram.com/therock",
            ...     "https://www.instagram.com/cristiano",
            ... ]
            >>> snapshots = rapid_service.get_audience_snapshots(
            ...     urls, parallel=True, max_workers=3
            ... )
            >>> for snapshot in snapshots:
            ...     print(f"Top countries: {snapshot.top_countries}")
        """
        if parallel:
            return self.get_audience_snapshots_parallel(
                instagram_urls, max_workers=max_workers
            )

        # Sequential processing
        snapshots = []
        for url in instagram_urls:
            _, snapshot = self._fetch_single_audience_snapshot(url)
            if snapshot:
                snapshots.append(snapshot)

        return snapshots
