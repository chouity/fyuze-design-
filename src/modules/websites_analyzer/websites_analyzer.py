import asyncio
from typing import Optional

from src.shared.models import WebsiteSummary

from src.shared.utils import get_logger, FyuzeLogger


DEFAULT_MODEL_ID = "openai/gpt-oss-20b"


class WebsitesAnalyzer:
    """
    Service to crawl a website and produce a structured summary.

    This composes the UrlCrawlingService for fetching markdown content and the
    AgentService for LLM-powered extraction into a WebsiteSummary schema.
    """

    def __init__(self) -> None:
        self._logger: FyuzeLogger = get_logger(__name__)
        # Lazy import to avoid importing optional heavy deps at module import time
        from src.shared.services.url_crawling_service import UrlCrawlingService
        from src.shared.services.agents_service import AgentService

        self._crawler = UrlCrawlingService()
        self._agents = AgentService()

    def analyze_website(
        self,
        url: str,
        *,
        model_id: str = DEFAULT_MODEL_ID,
        temperature: float = 0.2,
        reasoning: bool = False,
        instructions: Optional[str] = None,
        description: Optional[str] = None,
    ) -> WebsiteSummary:
        """
        Analyze a website at the given URL and return a WebsiteSummary.

        Args:
                url: The website URL to crawl and analyze. (required)
                model_id: The LLM model identifier. Defaults to open-source 20B.
                temperature: Sampling temperature for the model.
                reasoning: Enable model reasoning if supported.
                instructions: Optional custom system instructions for the agent.
                description: Optional short description of the agent purpose.

        Returns:
                WebsiteSummary: Structured summary of the website.
        """
        self._logger.info(f"Analyzing website: {url}")

        # 1) Crawl website content (sync wrapper over async crawler)
        website_markdown = self._run_async(self._crawler.crawl_website(url))

        # 2) Build agent
        agent_instructions = (
            instructions
            or "You are an expert web analyst. Given the content of a website, "
            "extract key information and provide a structured summary that fits the WebsiteSummary schema. "
            "Be accurate and concise. If data is unavailable, leave fields empty rather than guessing."
        )
        agent_description = (
            description
            or "Summarize the key information about a website into a structured JSON format."
        )

        agent = self._agents.build_agent(
            model_id=model_id,
            temperature=temperature,
            reasoning=reasoning,
            instructions=agent_instructions,
            description=agent_description,
            response_model=WebsiteSummary,
        )

        # 3) Run agent on content. Include URL hint to improve accuracy.
        content = f"URL: {url}\n\n{website_markdown}".strip()
        response = agent.run(content)

        # 4) Return parsed pydantic model
        summary: WebsiteSummary = response.content
        self._logger.info(f"Analysis complete for: {url}")
        return summary

    def _run_async(self, coro):
        """Run an async coroutine from sync context in a simple, safe way."""
        try:
            loop = asyncio.get_running_loop()
        except RuntimeError:
            loop = None

        if loop and loop.is_running():
            # If already inside an event loop (e.g., notebooks), run in a new loop in a thread
            import threading

            result_container = {}

            def _target():
                result_container["value"] = asyncio.run(coro)

            t = threading.Thread(target=_target, daemon=True)
            t.start()
            t.join()
            return result_container.get("value")
        else:
            return asyncio.run(coro)


def analyze_website(
    url: str,
    *,
    model_id: str = DEFAULT_MODEL_ID,
    temperature: float = 0.2,
    reasoning: bool = False,
    instructions: Optional[str] = None,
    description: Optional[str] = None,
) -> WebsiteSummary:
    """
    Synchronous convenience function to analyze a website into WebsiteSummary.

    Wraps WebsitesAnalyzer for a simple one-call API.
    """
    service = WebsitesAnalyzer()
    return service.analyze_website(
        url,
        model_id=model_id,
        temperature=temperature,
        reasoning=reasoning,
        instructions=instructions,
        description=description,
    )
