from os import environ
import concurrent.futures
from typing import List, Dict, Any, Optional

from apify_client import ApifyClient


from src.shared.utils import get_logger, FyuzeLogger, retry
from src.shared.exceptions import ConfigurationError
from src.shared.models import (
    ApifyInstaAccount,
    TikTokInfluencer,
    TikTokInfluencerFactory,
)


class ApifyService:
    def __init__(self):
        self._logger: FyuzeLogger = get_logger(__name__)
        self._client: ApifyClient | None = None

    def _init_client(self):
        api_token = environ.get("APIFY_API_TOKEN")
        if api_token:
            self._logger.info("Initializing Apify client.")
            self._client = ApifyClient(api_token)
            self._logger.info("Apify client initialized successfully.")
        else:
            self._logger.error("APIFY_API_TOKEN not found in environment variables.")
            raise ConfigurationError(
                "APIFY_API_TOKEN not found in environment variables."
            )

    @retry(max_attempts=3, delay=1)
    def run_actor(
        self, actor_id: str, run_input: Dict[str, Any]
    ) -> List[Dict[str, Any]]:
        """
        Run an Apify actor with the given configuration.

        Args:
            actor_id: The ID of the Apify actor to run
            run_input: The input configuration for the actor

        Returns:
            List of results from the actor's default dataset
        """
        if not self._client:
            self._init_client()

        self._logger.info(f"Running Apify actor: {actor_id}")
        try:
            run = self._client.actor(actor_id).call(run_input=run_input)
            results = list(
                self._client.dataset(run["defaultDatasetId"]).iterate_items()
            )
            self._logger.info(
                f"Actor {actor_id} completed successfully with {len(results)} results."
            )
            return results
        except Exception as e:
            self._logger.error(f"Error running Apify actor {actor_id}: {e}")
            raise

    def bulk_run_actors(
        self, actor_jobs: Dict[str, Dict[str, Any]], max_workers: int = 3
    ) -> Dict[str, List[Dict[str, Any]]]:
        """
        Run multiple Apify actors in parallel using multithreading.

        Args:
            actor_jobs: Dictionary mapping job IDs to actor configurations
                    Each configuration should have 'actor_id' and 'run_input' keys
            max_workers: Maximum number of threads to use

        Returns:
            Dictionary mapping job IDs to actor results

        Example:
            >>> apify_service = ApifyService()
            >>> jobs = {
            ...     "job1": {
            ...         "actor_id": "shu8hvrXbJbY3Eb9W",
            ...         "run_input": {"directUrls": ["https://www.instagram.com/user/"]}
            ...     },
            ...     "job2": {
            ...         "actor_id": "7hM7bDVcXMO8d09aN",
            ...         "run_input": {"usernames": ["user1"], "tiktokSource": "user"}
            ...     }
            ... }
            >>> results = apify_service.bulk_run_actors(jobs)
        """
        if not self._client:
            self._init_client()

        self._logger.info(
            f"Running bulk actors with {len(actor_jobs)} jobs using {max_workers} workers"
        )

        results = {}
        actor_data = [
            (job_id, config["actor_id"], config["run_input"])
            for job_id, config in actor_jobs.items()
        ]

        with concurrent.futures.ThreadPoolExecutor(max_workers=max_workers) as executor:
            future_to_job = {
                executor.submit(self._actor_worker, ad): ad[0] for ad in actor_data
            }

            for future in concurrent.futures.as_completed(future_to_job):
                job_id, job_results = future.result()
                results[job_id] = job_results

        self._logger.info(f"Bulk actor run completed with {len(results)} results")
        return results

    def scrape_instagram_profiles(
        self, usernames: List[str], results_limit: int = 25
    ) -> List[ApifyInstaAccount]:
        """
        Scrape Instagram profiles for given usernames.

        Args:
            usernames: List of Instagram usernames to scrape
            results_limit: Maximum number of results per profile

        Returns:
            List of Instagram influencer profiles
        """
        run_input = {
            "addParentData": False,
            "directUrls": [f"https://www.instagram.com/{u}/" for u in usernames],
            "enhanceUserSearchWithFacebookPage": False,
            "isUserReelFeedURL": False,
            "isUserTaggedFeedURL": False,
            "resultsLimit": results_limit,
            "resultsType": "details",
            "searchLimit": 1,
            "searchType": "hashtag",
        }
        default_response = self.run_actor(
            actor_id="shu8hvrXbJbY3Eb9W", run_input=run_input
        )

        return [ApifyInstaAccount.from_dict(item) for item in default_response]

    def scrape_tiktok_profiles(
        self, users: List[str], results_limit: int = 20
    ) -> List[TikTokInfluencer]:
        """
        Scrape TikTok posts for given URLs.

        Args:
            post_urls: List of TikTok post URLs to scrape
            results_limit: Number of results per page

        Returns:
            List of post data
        """
        run_input = {
            "excludePinnedPosts": False,
            "profileScrapeSections": ["videos"],
            "profileSorting": "latest",
            "profiles": users,
            "proxyCountryCode": "None",
            "resultsPerPage": results_limit,
            "scrapeRelatedVideos": False,
            "shouldDownloadAvatars": False,
            "shouldDownloadCovers": False,
            "shouldDownloadMusicCovers": False,
            "shouldDownloadSlideshowImages": False,
            "shouldDownloadSubtitles": False,
            "shouldDownloadVideos": False,
            "searchSection": "",
            "maxProfilesPerQuery": 10,
        }
        default_response = self.run_actor(
            actor_id="GdWCkxBtKWOsKjdch", run_input=run_input
        )
        print(default_response)
        return TikTokInfluencerFactory.list_from_posts(default_response)
