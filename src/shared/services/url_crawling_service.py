import os
import time

from crawl4ai import AsyncWebCrawler
from crawl4ai.async_configs import BrowserConfig, CrawlerRunConfig
from crawl4ai.deep_crawling import BFSDeepCrawlStrategy

from src.shared.utils import get_logger, FyuzeLogger


DEFAULT_MAX_DEPTH = 2
DEFAULT_MAX_PAGES = 10


class UrlCrawlingService:
    def __init__(self):
        self._logger: FyuzeLogger = get_logger(__name__)
        self._max_depth = int(os.getenv("CRAWLER_MAX_DEPTH", DEFAULT_MAX_DEPTH))
        self._max_pages = int(os.getenv("CRAWLER_MAX_PAGES", DEFAULT_MAX_PAGES))

    async def crawl_website(self, url: str) -> str:
        """
        Crawl a website and return the markdown content.

        Args:
            url: The URL of the website to crawl

        Returns:
            Markdown content of the crawled website
        """
        start_time = time.time()
        self._logger.info(f"Starting crawl for URL: {url}")

        async def _crawl(delay=0):
            browser_config = BrowserConfig()
            run_config = CrawlerRunConfig(
                deep_crawl_strategy=BFSDeepCrawlStrategy(
                    max_depth=self._max_depth,
                    max_pages=self._max_pages,
                ),
                delay_before_return_html=delay,
            )
            async with AsyncWebCrawler(config=browser_config) as crawler:
                return await crawler.arun(url=url, config=run_config)

        result = await _crawl()

        # Build website content
        website = ""
        if isinstance(result, list):
            for r in result:
                website += r.url + "\n"
                website += r.markdown + "\n\n"
        else:
            website = result.markdown

        # Handle empty or incomplete content
        if not website.strip() or len(website.strip()) < 200:
            self._logger.warning(
                f"Empty content for URL: {url}, retrying with delay..."
            )
            result = await _crawl(delay=3)
            if isinstance(result, list):
                website = ""
                for r in result:
                    website += r.url + "\n"
                    website += r.markdown + "\n\n"
            else:
                website = result.markdown

        end_time = time.time()
        elapsed_time = end_time - start_time
        self._logger.info(
            f"Crawl completed for URL: {url} in {elapsed_time:.2f} seconds"
        )

        return website
