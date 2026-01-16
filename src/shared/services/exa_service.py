from os import environ
import concurrent.futures
from typing import List, Dict, Any

from exa_py import Exa
from exa_py.api import SearchResponse

from src.shared.utils.logging import get_logger, FyuzeLogger
from src.shared.utils.retry import retry
from src.shared.exceptions import ConfigurationError


class ExaSearchService:
    def __init__(self):
        self._logger: FyuzeLogger = get_logger(__name__)
        self._exa: Exa | None = None

    def _init_client(self):
        api_key = environ.get("EXA_API_KEY")
        if api_key:
            self._logger.info("Initializing EXA client.")
            self._exa = Exa(api_key=api_key)
            self._logger.info("EXA client initialized successfully.")
        else:
            self._logger.error("EXA_API_KEY not found in environment variables.")
            raise ConfigurationError("EXA_API_KEY not found in environment variables.")

    @retry(max_attempts=3, delay=1)
    def search(self, query: str) -> SearchResponse:
        if not self._exa:
            self._init_client()

        self._logger.info(f"Performing search with query: {query}")
        try:
            results: SearchResponse = self._exa.search(
                query=query,
                # type="keyword",
            )
            self._logger.info(
                f"Search completed successfully with {len(results.results)} results."
            )
            return results
        except Exception as e:
            self._logger.error(f"Error during EXA search: {e}")
            raise

    def _search_worker(self, query_data: tuple) -> tuple[str, SearchResponse]:
        """
        Worker function for threaded bulk search.

        Args:
            query_data: Tuple containing (query_id, query_text)

        Returns:
            Tuple of (query_id, search_results)
        """
        query_id, query_text = query_data
        try:
            results = self.search(query=query_text)
            return query_id, results
        except Exception as e:
            self._logger.error(f"Error in search worker for query {query_id}: {e}")
            return query_id, []

    def bulk_search(
        self, queries: Dict[str, str], max_workers: int = 5
    ) -> Dict[str, List[Dict[str, Any]]]:
        """
        Perform multiple searches in parallel using multithreading.

        Args:
            queries: Dictionary mapping query IDs to query strings
            max_workers: Maximum number of threads to use

        Returns:
            Dictionary mapping query IDs to search results

        Example:
            >>> search_service = ExaSearchService()
            >>> queries = {
            ...     "q1": "quantum computing applications",
            ...     "q2": "machine learning algorithms"
            ... }
            >>> results = search_service.bulk_search(queries)
        """
        if not self._exa:
            self._init_client()

        self._logger.info(
            f"Performing bulk search with {len(queries)} queries using {max_workers} workers"
        )

        results = {}
        query_data = [
            (query_id, query_text) for query_id, query_text in queries.items()
        ]

        with concurrent.futures.ThreadPoolExecutor(max_workers=max_workers) as executor:
            future_to_query = {
                executor.submit(self._search_worker, qd): qd[0] for qd in query_data
            }

            for future in concurrent.futures.as_completed(future_to_query):
                query_id, query_results = future.result()
                results[query_id] = query_results

        self._logger.info(f"Bulk search completed with {len(results)} results")
        return results
