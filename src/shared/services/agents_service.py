from agno.agent import Agent
from agno.models.groq import Groq
from pydantic import BaseModel
from typing import Type


class AgentService:
    def build_agent(
        self,
        model_id: str,
        temperature: float,
        reasoning: bool,
        instructions: str,
        description: str,
        response_model: Type[BaseModel],
    ) -> Agent:
        """
        Builds and returns an agent for website summarization.

        Args:
            model_id (str): The ID of the model to use.
            temperature (float): The temperature for the model.
            reasoning (bool): Whether to enable reasoning for the agent.
            instructions (str): The instructions for the agent.
            description (str): The description of the agent's purpose.
            response_model (Type[BaseModel]): The Pydantic model for the response.

        Returns:
            Agent: The configured agent.
        """
        model = Groq(id=model_id, temperature=temperature)
        agent = Agent(
            model=model,
            instructions=instructions,
            description=description,
            reasoning=reasoning,
            response_model=response_model,
        )
        return agent
