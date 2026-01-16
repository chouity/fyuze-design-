from dotenv import load_dotenv
from time import time

load_dotenv()

start_time = time()

from src.agent.insta_marketing_expert import insta_marketing_expert

# load the input file
with open("agent_input_sample.txt", "r", encoding="utf-8") as f:
    agent_input = f.read()

# Run the agent with the input
response = insta_marketing_expert.run(input=agent_input)

# Print the response
print(response)
print(f"Execution Time: {time() - start_time} seconds")
