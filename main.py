from src.agent.fyuze_agent import fyuze_agent


def run_agent(message: str, user_id: str, session_id: str):
    """Run the Fyuze agent with the given message, user ID, and session ID"""
    response = fyuze_agent.run(
        message=message,
        user_id=user_id,
        session_id=session_id,
    )
    return response.content
