import os

from agno.storage.mongodb import MongoDbStorage
from agno.memory.v2.memory import Memory
from agno.memory.v2.db.mongodb import MongoMemoryDb
from pymongo import MongoClient

mongo_client = MongoClient(
    host=os.getenv("MONGODB_URI"),
)
database = mongo_client["agno"]
collection = database["temp"]

storage = MongoDbStorage(collection_name="Fyuze_Project", client=mongo_client)


memory_db = MongoMemoryDb(
    client=mongo_client,
)

# Create memory instance with MongoDB backend
memory = Memory(db=memory_db)  # type: ignore
