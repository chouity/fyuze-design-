import os
import json
import logging
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import datetime, timedelta
from typing import Dict, Any, Optional, Sequence, Tuple
from supabase import create_client, Client


# logger = logging.getLogger(__name__)


class SupabaseService:
    """
    Service for interacting with Supabase database.

    This service provides methods to interact with the Supabase database,
    including creator management functionality.

    Environment Variables Required:
        SUPABASE_URL: The Supabase project URL
        SUPABASE_SERVICE_ROLE_KEY: Service role key for admin operations

    Environment Variables Optional:
        CREATOR_DATA_MAX_AGE_DAYS: Maximum age in days for creator data to be considered fresh (default: 7)
    """

    def __init__(
        self, supabase_url: Optional[str] = None, service_role_key: Optional[str] = None
    ):
        """
        Initialize the Supabase service.

        Args:
            supabase_url: Supabase project URL. If None, reads from SUPABASE_URL env var.
            service_role_key: Service role key. If None, reads from SUPABASE_SERVICE_ROLE_KEY env var.

        Raises:
            ValueError: If required environment variables are missing.
        """
        # Get configuration from parameters or environment variables
        self.supabase_url = supabase_url or os.getenv("SUPABASE_URL")
        self.service_role_key = service_role_key or os.getenv(
            "SUPABASE_SERVICE_ROLE_KEY"
        )

        # Get max age for creator data (default to 7 days)
        self.max_age_days = int(os.getenv("CREATOR_DATA_MAX_AGE_DAYS", "7"))

        if not self.supabase_url:
            raise ValueError(
                "SUPABASE_URL is required. Set it as environment variable or pass as parameter."
            )

        if not self.service_role_key:
            raise ValueError(
                "SUPABASE_SERVICE_ROLE_KEY is required. Set it as environment variable or pass as parameter."
            )

        try:
            # Initialize Supabase client with service role key for admin operations
            self.client: Client = create_client(
                self.supabase_url, self.service_role_key
            )
            # logger.info("Supabase service initialized successfully")
        except Exception as e:
            # logger.error(f"Failed to initialize Supabase client: {e}")
            raise

    def save_creator(
        self, username: str, platform: str, data: Dict[str, Any]
    ) -> Dict[str, Any]:
        """
        Save a creator using the insert_creator_from_payload database function.

        This method calls the PostgreSQL function `insert_creator_from_payload` to save
        creator information to the database.

        Args:
            username (str): The username of the creator (e.g., 'cristiano')
            platform (str): The social media platform (e.g., 'instagram', 'tiktok', 'youtube')
            data (Dict[str, Any]): Dictionary containing creator metadata such as:
                - name: Full name of the creator
                - category: Content category (e.g., 'sports', 'entertainment')
                - verified: Boolean indicating if account is verified
                - followers_count: Number of followers (optional)
                - bio: Creator's biography (optional)

        Returns:
            Dict[str, Any]: The result of the database operation

        Raises:
            Exception: If the database operation fails

        Example:
            >>> service = SupabaseService()
            >>> result = service.save_creator(
            ...     username='cristiano',
            ...     platform='instagram',
            ...     data={
            ...         'name': 'Cristiano Ronaldo',
            ...         'category': 'sports',
            ...         'verified': True,
            ...         'followers_count': 500000000,
            ...         'bio': 'Professional footballer'
            ...     }
            ... )
            >>> print(result)

            >>> # Minimal example
            >>> result = service.save_creator(
            ...     'selenagomez',
            ...     'instagram',
            ...     {'name': 'Selena Gomez', 'category': 'entertainment', 'verified': True}
            ... )
        """
        if not username or not username.strip():
            raise ValueError("Username cannot be empty")

        if not platform or not platform.strip():
            raise ValueError("Platform cannot be empty")

        if not isinstance(data, dict) or not data:
            raise ValueError("Data must be a non-empty dictionary")

        try:
            # Convert data dict to JSON string for PostgreSQL jsonb type
            data_json = json.dumps(data, ensure_ascii=False)

            # logger.info(f"Saving creator: {username} on {platform}")

            # Execute the SQL function
            result = self.client.rpc(
                "insert_creator_from_payload",
                {
                    "p_username": username.strip(),
                    "p_platform": platform.strip().lower(),
                    "p_data": data_json,
                },
            ).execute()

            # logger.info(f"Successfully saved creator: {username}")
            return result.data

        except Exception as e:
            error_msg = f"Failed to save creator {username} on {platform}: {str(e)}"
            # logger.error(error_msg)
            raise Exception(error_msg)

    def get_creator(
        self, username: str, platform: str, max_age_days: Optional[int] = None
    ) -> Optional[Dict[str, Any]]:
        """
        Retrieve a creator from the database if it exists and is not outdated.

        This method queries the 'creators' table to find a creator by username and platform,
        and checks if the data is fresh based on the updated_at timestamp.

        Args:
            username (str): The username of the creator (e.g., 'cristiano')
            platform (str): The social media platform (e.g., 'instagram', 'tiktok', 'youtube')
            max_age_days (Optional[int]): Maximum age in days for data to be considered fresh.
                                        If None, uses the service default or env variable.

        Returns:
            Optional[Dict[str, Any]]: Creator data if found and fresh, None otherwise.
                                    The returned dict contains all creator fields including:
                                    - id: Creator ID
                                    - username: Creator username
                                    - platform: Social media platform
                                    - data: JSON data with creator metadata
                                    - created_at: Creation timestamp
                                    - updated_at: Last update timestamp

        Example:
            >>> service = SupabaseService()
            >>> creator = service.get_creator('cristiano', 'instagram')
            >>> if creator:
            ...     print(f"Found creator: {creator['data']['name']}")
            ...     print(f"Last updated: {creator['updated_at']}")
            ... else:
            ...     print("Creator not found or data is outdated")

            >>> # Using custom max age
            >>> creator = service.get_creator('cristiano', 'instagram', max_age_days=3)
        """
        if not username or not username.strip():
            raise ValueError("Username cannot be empty")

        if not platform or not platform.strip():
            raise ValueError("Platform cannot be empty")

        # Use provided max_age_days or fall back to service default
        max_age = max_age_days if max_age_days is not None else self.max_age_days

        # Calculate the cutoff date for fresh data
        cutoff_date = datetime.now() - timedelta(days=max_age)
        cutoff_iso = cutoff_date.isoformat()

        try:
            # logger.info(
            #     f"Fetching creator: {username} on {platform} (max age: {max_age} days)"
            # )

            # Query the creators table
            result = (
                self.client.table("creators")
                .select("*")
                .eq("username", username.strip())
                .eq("platform", platform.strip().lower())
                .gte("updated_at", cutoff_iso)  # Only get records updated after cutoff
                .order("updated_at", desc=True)  # Get the most recent if multiple exist
                .limit(1)
                .execute()
            )

            if result.data and len(result.data) > 0:
                creator = result.data[0]
                # logger.info(f"Found fresh creator data for {username} on {platform}")
                return creator
            else:
                # logger.info(f"No fresh creator data found for {username} on {platform}")
                return None

        except Exception as e:
            error_msg = f"Failed to get creator {username} on {platform}: {str(e)}"
            # logger.error(error_msg)
            raise Exception(error_msg)

    def get_creators_parallel(
        self,
        requests: Sequence[Tuple[str, str]],
        max_workers: int = 5,
        max_age_days: Optional[int] = None,
    ) -> Dict[str, Any]:
        """Retrieve multiple creators by delegating to :meth:`get_creator` in parallel.

        Args:
            requests: Iterable of ``(username, platform)`` tuples.
            max_workers: Maximum number of worker threads to use.
            max_age_days: Optional override passed to :meth:`get_creator`.

        Returns:
            Dictionary with two keys:
                ``results``: list of items with ``username``, ``platform`` and
                ``creator`` (may be ``None`` when not found).
                ``errors``: list of errors that occurred for specific requests.

        Raises:
            ValueError: If the requests collection is empty or malformed.
        """

        if not requests:
            raise ValueError("At least one (username, platform) pair must be provided")

        cleaned_requests: list[Tuple[str, str]] = []
        for index, request in enumerate(requests):
            if not isinstance(request, tuple) or len(request) != 2:
                raise ValueError(
                    f"Request at index {index} must be a tuple of (username, platform)"
                )

            username, platform = request
            if not isinstance(username, str) or not username.strip():
                raise ValueError(
                    f"Username at index {index} must be a non-empty string"
                )
            if not isinstance(platform, str) or not platform.strip():
                raise ValueError(
                    f"Platform at index {index} must be a non-empty string"
                )

            cleaned_requests.append((username.strip(), platform.strip().lower()))

        if max_workers <= 0:
            raise ValueError("max_workers must be a positive integer")

        results: list[Dict[str, Any]] = []
        errors: list[Dict[str, Any]] = []

        with ThreadPoolExecutor(
            max_workers=min(max_workers, len(cleaned_requests))
        ) as executor:
            future_map = {
                executor.submit(
                    self.get_creator,
                    username,
                    platform,
                    max_age_days,
                ): (username, platform)
                for username, platform in cleaned_requests
            }

            for future in as_completed(future_map):
                username, platform = future_map[future]
                try:
                    creator = future.result()
                    results.append(
                        {
                            "username": username,
                            "platform": platform,
                            "creator": creator,
                        }
                    )
                except Exception as exc:  # pragma: no cover - defensive
                    errors.append(
                        {
                            "username": username,
                            "platform": platform,
                            "error": str(exc),
                        }
                    )

        return {"results": results, "errors": errors}

    def save_creators_parallel(
        self,
        creators: Sequence[Dict[str, Any]],
        max_workers: int = 5,
    ) -> Dict[str, Any]:
        """Persist multiple creators concurrently using :meth:`save_creator`.

        Args:
            creators: Iterable of dictionaries containing ``username``, ``platform``
                and ``data`` keys (same payload accepted by :meth:`save_creator`).
            max_workers: Maximum number of worker threads to use.

        Returns:
            Dictionary with two keys:
                ``saved``: list of successful saves with ``username``, ``platform`` and
                ``result`` fields.
                ``errors``: list of items that failed with ``username``, ``platform``
                and ``error`` message.

        Raises:
            ValueError: If the creators collection is empty or malformed.
        """

        if not creators:
            raise ValueError("Creators payload cannot be empty")

        if max_workers <= 0:
            raise ValueError("max_workers must be a positive integer")

        sanitized_creators: list[Dict[str, Any]] = []
        for index, entry in enumerate(creators):
            if not isinstance(entry, dict):
                raise ValueError(
                    f"Creator payload at index {index} must be a dictionary"
                )

            username = str(entry.get("username", "")).strip()
            platform = str(entry.get("platform", "")).strip().lower()
            data = entry.get("data")

            if not username or not platform:
                raise ValueError(
                    f"Creator payload at index {index} requires non-empty username and platform"
                )

            if not isinstance(data, dict) or not data:
                raise ValueError(
                    f"Creator payload at index {index} requires a non-empty data dictionary"
                )

            sanitized_creators.append(
                {
                    "username": username,
                    "platform": platform,
                    "data": data,
                }
            )

        saved: list[Dict[str, Any]] = []
        errors: list[Dict[str, Any]] = []

        with ThreadPoolExecutor(
            max_workers=min(max_workers, len(sanitized_creators))
        ) as executor:
            future_map = {
                executor.submit(
                    self.save_creator,
                    entry["username"],
                    entry["platform"],
                    entry["data"],
                ): entry
                for entry in sanitized_creators
            }

            for future in as_completed(future_map):
                entry = future_map[future]
                try:
                    result = future.result()
                    saved.append(
                        {
                            "username": entry["username"],
                            "platform": entry["platform"],
                            "result": result,
                        }
                    )
                except Exception as exc:  # pragma: no cover - defensive
                    errors.append(
                        {
                            "username": entry["username"],
                            "platform": entry["platform"],
                            "error": str(exc),
                        }
                    )

        return {"saved": saved, "errors": errors}

    def __enter__(self):
        """Context manager entry."""
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        """Context manager exit."""
        # Clean up resources if needed
        pass


# Example usage:
if __name__ == "__main__":
    # Example usage - ensure environment variables are loaded at application startup
    from dotenv import load_dotenv

    load_dotenv()

    try:
        with SupabaseService() as service:
            # Example 1: Basic creator save
            result = service.save_creator(
                "cristiano",
                "instagram",
                {
                    "name": "Cristiano Ronaldo",
                    "category": "sports",
                    "verified": True,
                    "followers_count": 500000000,
                },
            )
            print("Creator saved successfully:", result)

            # Example 2: Get creator data
            creator = service.get_creator("cristiano", "instagram")
            if creator:
                print(f"Found creator: {creator['data']['name']}")
                print(f"Last updated: {creator['updated_at']}")
            else:
                print("Creator not found or data is outdated")

            # Example 3: Get creator with custom max age
            fresh_creator = service.get_creator(
                "cristiano", "instagram", max_age_days=3
            )

            # Example 4: Parallel fetch
            fetch_results = service.get_creators_parallel(
                [
                    ("creator1", "instagram"),
                    ("creator2", "tiktok"),
                ],
                max_workers=4,
            )
            print("Parallel fetch results:", fetch_results)

            # Example 5: Parallel save
            save_payload = [
                {
                    "username": "creator1",
                    "platform": "instagram",
                    "data": {
                        "name": "Creator One",
                        "bio": "Lifestyle blogger",
                        "followers": 12000,
                        "is_verified": True,
                        "location": "lebanon",
                    },
                },
                {
                    "username": "creator2",
                    "platform": "tiktok",
                    "data": {
                        "full_name": "Creator Two",
                        "bio": "Foodie",
                        "followers": 8000,
                        "is_verified": False,
                        "location": "egypt",
                    },
                },
            ]

            save_results = service.save_creators_parallel(
                save_payload,
                max_workers=4,
            )
            print("Parallel save result:", save_results)

    except Exception as e:
        print(f"Error: {e}")
