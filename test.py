# import time
# from src.shared.utils.storage import collection

# x =collection.find_one({'session_id':'stringv5'})
# x=x["memory"]["runs"][-1]["messages"][-1]
# collection.update_one(
#     {'session_id':'stringv5'},
#     {
#     "$push": {
#       "messages": {
#         "content": "Your new message here",
#         "from_history": False,
#         "stop_after_tool_call": False,
#         "role": "assistant",
#         "metrics": { "created_at": time.time()}
#       }
#     }
#   }
# )

# data = collection.find_one({"session_id": "stringv5"})

# print(x)

from dotenv import load_dotenv

load_dotenv()

from src.core.basic_search import basic_search

result = basic_search("food restaurants Tripoli Lebanon")
print(result)
