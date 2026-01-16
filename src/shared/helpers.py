import json
import re
import tempfile
from src.core.search_influencers import (
    search_insta_influencers,
    search_tiktok_influencers,
    search_tiktok_and_instagram,
    search_instagram_by_usernames,
    search_tiktok_by_usernames,
)
from src.shared.models.ensemble_insta_account import EnsembleInstaAccount
from src.shared.models.ensemble_tiktok_account import EnsembleTiktokAccount


def cleanup_temp_json_files():
    """Delete all .json files in the system temp directory."""
    import os
    import tempfile

    temp_dir = tempfile.gettempdir()
    target_files = ["insta_influencers.json", "tiktok_influencers.json"]
    for fname in target_files:
        file_path = os.path.join(temp_dir, fname)
        if os.path.exists(file_path):
            try:
                os.remove(file_path)
            except Exception:
                pass


def is_mock():
    import os
    from dotenv import load_dotenv

    load_dotenv()
    mock = os.getenv("MOCK_DATA")
    return mock == "1"


mock_data = is_mock()
import src.shared.context as context

_HANDLE_PATTERN = re.compile(r"@([a-zA-Z0-9_.]{2,})")


def extract_usernames_from_text(text: str | None) -> list[str]:
    """
    Extract potential social handles (prefixed with @) from free-form agent text.

    Returns a list of unique usernames (with leading '@') preserving input order.
    """

    if not text:
        return []

    seen: set[str] = set()
    usernames: list[str] = []

    for match in _HANDLE_PATTERN.findall(text):
        handle = f"@{match.strip()}"
        key = handle.lower()
        if key not in seen:
            usernames.append(handle)
            seen.add(key)

    return usernames


def search_tiktok_and_instagram_influencers(
    topic: str,
    location: str,
    keywords: list[str],
    search_results: int = 10,
):
    """
    Search for both TikTok and Instagram influencers in parallel and return agent data.
    Saves complete influencer data to files for later matching.
    """

    if mock_data:
        # Mock implementation - load existing data and save to platform-specific files
        with open("dicts mini insta.json", "r", encoding="utf-8") as f:
            instagram_agent_data = json.load(f)

        with open("dicts min tiktok.json", "r", encoding="utf-8") as f:
            tiktok_agent_data = json.load(f)

        # Return simplified agent data (extract key fields for agent consumption)
        agent_data = []

        # Add Instagram influencers list with platform field
        agent_data.append({"data": instagram_agent_data, "platform": "instagram"})

        # Add TikTok influencers list with platform field
        agent_data.append({"data": tiktok_agent_data, "platform": "tiktok"})
        return agent_data

    # from src.core.search_influencers import search_tiktok_and_instagram
    combined_results = search_tiktok_and_instagram(
        topic=topic,
        location=location,
        keywords=keywords,
        search_results=search_results,
    )

    # Convert profiles to dicts for both platforms (complete data)
    instagram_influencers_complete = [
        i.to_dict()
        for i in combined_results["instagram"]["profiles"]
        if isinstance(i, EnsembleInstaAccount)
    ]
    tiktok_influencers_complete = [
        i.to_dict()
        for i in combined_results["tiktok"]["profiles"]
        if isinstance(i, EnsembleTiktokAccount)
    ]

    # Save profiles to temp files for later matching
    import os

    # temp_dir = tempfile.gettempdir()
    # insta_path = os.path.join(temp_dir, "insta_influencers.json")
    # tiktok_path = os.path.join(temp_dir, "tiktok_influencers.json")
    # with open(insta_path, "w", encoding="utf-8") as f:
    #     json.dump(instagram_influencers_complete, f, ensure_ascii=False, indent=2)
    # with open(tiktok_path, "w", encoding="utf-8") as f:
    #     json.dump(tiktok_influencers_complete, f, ensure_ascii=False, indent=2)
    # Save profiles to MongoDB in one document per user/session
    from src.shared.utils.storage import collection

    # You must pass user_id and session_id to this function, or retrieve from context
    # For demonstration, using global context (replace with your context logic)
    try:
        import src.shared.context as context

        user_id = context.user_id
        session_id = context.session_id
    except ImportError:
        user_id = None
        session_id = None
    doc_id = f"{user_id}_{session_id}"
    # Merge both platforms' data
    # Stack influencer data instead of replacing
    new_data = instagram_influencers_complete + tiktok_influencers_complete
    doc = collection.find_one({"doc_id": doc_id})
    if doc and "influencer_data" in doc:
        merged_data = doc["influencer_data"] + new_data
    else:
        merged_data = new_data
    collection.update_one(
        {"doc_id": doc_id}, {"$set": {"influencer_data": merged_data}}, upsert=True
    )

    # Return agents grouped by platform, matching mock format
    agent_data = []
    agent_data.append(
        {"data": combined_results["instagram"]["agents"], "platform": "instagram"}
    )
    agent_data.append(
        {"data": combined_results["tiktok"]["agents"], "platform": "tiktok"}
    )
    return agent_data


def search_instagram_influencers(
    topic: str,
    location: str,
    keywords: list[str],
    search_results: int = 10,
):
    if mock_data:
        with open("dicts.json", "r", encoding="utf-8") as f:
            dicts = json.load(f)
        with open("insta_influencers.json", "r", encoding="utf-8") as f:
            influencers_infos = json.load(f)

        # Save to MongoDB in one document per user/session with stacking
        from src.shared.utils.storage import collection

        try:
            import src.shared.context as context

            user_id = context.user_id
            session_id = context.session_id
        except ImportError:
            user_id = None
            session_id = None
        doc_id = f"{user_id}_{session_id}"

        # Stack influencer data instead of replacing
        doc = collection.find_one({"doc_id": doc_id})
        if doc and "influencer_data" in doc:
            merged_data = doc["influencer_data"] + influencers_infos
        else:
            merged_data = influencers_infos
        collection.update_one(
            {"doc_id": doc_id}, {"$set": {"influencer_data": merged_data}}, upsert=True
        )
        return dicts
    full_infos, dicts = search_insta_influencers(
        topic=topic,
        location=location,
        keywords=keywords,
        search_results=search_results,
    )
    influencers_infos = [
        i.to_dict() for i in full_infos if isinstance(i, EnsembleInstaAccount)
    ]
    # Save to a named file in temp dir
    import os

    # temp_dir = tempfile.gettempdir()
    # json_path = os.path.join(temp_dir, "insta_influencers.json")
    # with open(json_path, "w", encoding="utf-8") as tmpfile:
    #     json.dump(influencers_infos, tmpfile, ensure_ascii=False, indent=2)
    # Save to MongoDB in one document per user/session
    from src.shared.utils.storage import collection

    try:
        import src.shared.context as context

        user_id = context.user_id
        session_id = context.session_id
    except ImportError:
        user_id = None
        session_id = None
    doc_id = f"{user_id}_{session_id}"
    # Stack influencer data instead of replacing
    doc = collection.find_one({"doc_id": doc_id})
    if doc and "influencer_data" in doc:
        merged_data = doc["influencer_data"] + influencers_infos
    else:
        merged_data = influencers_infos
    collection.update_one(
        {"doc_id": doc_id}, {"$set": {"influencer_data": merged_data}}, upsert=True
    )
    return dicts


def search_tiktoks_influencers(
    topic: str,
    location: str,
    keywords: list[str],
    search_results: int = 10,
):
    if mock_data:
        with open("dicts_tiktok.json", "r", encoding="utf-8") as f:
            dicts = json.load(f)
        return dicts
    full_infos, dicts = search_tiktok_influencers(
        topic=topic,
        location=location,
        keywords=keywords,
        search_results=search_results,
    )
    influencers_infos = [
        i.to_dict() for i in full_infos if isinstance(i, EnsembleTiktokAccount)
    ]
    # Save to a named file in temp dir
    import os

    # temp_dir = tempfile.gettempdir()
    # json_path = os.path.join(temp_dir, "tiktok_influencers.json")
    # with open(json_path, "w", encoding="utf-8") as tmpfile:
    #     json.dump(influencers_infos, tmpfile, ensure_ascii=False, indent=2)
    # Save to MongoDB in one document per user/session
    from src.shared.utils.storage import collection

    try:
        import src.shared.context as context

        user_id = context.user_id
        session_id = context.session_id
    except ImportError:
        user_id = None
        session_id = None
    doc_id = f"{user_id}_{session_id}"
    # Stack influencer data instead of replacing
    doc = collection.find_one({"doc_id": doc_id})
    if doc and "influencer_data" in doc:
        merged_data = doc["influencer_data"] + influencers_infos
    else:
        merged_data = influencers_infos
    collection.update_one(
        {"doc_id": doc_id}, {"$set": {"influencer_data": merged_data}}, upsert=True
    )
    return dicts


def get_full_influencer_data(usernames: list[str], file: str):
    """
    Loads the JSON file saved by search functions and returns influencer dicts whose usernames match the provided list.
    Supports single platform files or combined platform search.
    """
    # Handle combined platform search (both Instagram and TikTok)
    if file == "combined_platforms":
        matched = []
        import os

        temp_dir = tempfile.gettempdir()

        # Search in Instagram file
        try:
            insta_path = os.path.join(temp_dir, "insta_influencers.json")
            with open(insta_path, "r", encoding="utf-8") as f:
                instagram_influencers = json.load(f)

            usernames_set = set(u.lstrip("@").lower() for u in usernames)
            instagram_matched = [
                inf
                for inf in instagram_influencers
                if inf.get("username", "").lower() in usernames_set
            ]
            matched.extend(instagram_matched)
        except FileNotFoundError:
            pass

        # Search in TikTok file
        try:
            tiktok_path = os.path.join(temp_dir, "tiktok_influencers.json")
            with open(tiktok_path, "r", encoding="utf-8") as f:
                tiktok_influencers = json.load(f)

            usernames_set = set(u.lstrip("@").lower() for u in usernames)
            tiktok_matched = [
                inf
                for inf in tiktok_influencers
                if inf.get("unique_id", "").lower() in usernames_set
            ]
            matched.extend(tiktok_matched)
        except FileNotFoundError:
            pass
        cleanup_temp_json_files()
        # Check if temp files exist after cleanup
        import os

        temp_dir = tempfile.gettempdir()
        insta_path = os.path.join(temp_dir, "insta_influencers.json")
        tiktok_path = os.path.join(temp_dir, "tiktok_influencers.json")
        files_status = {}
        files_status["insta_influencers.json"] = os.path.exists(insta_path)
        files_status["tiktok_influencers.json"] = os.path.exists(tiktok_path)
        print("Temp file existence after cleanup:", files_status)
        return matched

    # Handle single platform files
    import os

    temp_dir = tempfile.gettempdir()
    file_path = os.path.join(temp_dir, file)
    with open(file_path, "r", encoding="utf-8") as f:
        influencers = json.load(f)
    # Try to match by username (case-insensitive)
    # Remove leading '@' from usernames if present
    if file == "insta_influencers.json":
        usernames_set = set(u.lstrip("@").lower() for u in usernames)
        matched = [
            inf
            for inf in influencers
            if inf.get("username", "").lower() in usernames_set
        ]
    elif file == "tiktok_influencers.json":
        usernames_set = set(u.lstrip("@").lower() for u in usernames)
        matched = [
            inf
            for inf in influencers
            if inf.get("unique_id", "").lower() in usernames_set
        ]
    else:
        return ["Unsupported platform"]
    cleanup_temp_json_files()
    import os

    temp_dir = tempfile.gettempdir()
    insta_path = os.path.join(temp_dir, "insta_influencers.json")
    tiktok_path = os.path.join(temp_dir, "tiktok_influencers.json")
    files_status = {}
    files_status["insta_influencers.json"] = os.path.exists(insta_path)
    files_status["tiktok_influencers.json"] = os.path.exists(tiktok_path)
    print("Temp file existence after cleanup:", files_status)
    return matched


def get_instagram_profiles_by_usernames(usernames: list[str]):
    """
    Directly fetch Instagram profiles by usernames without topic/keyword search.

    Args:
        usernames: List of Instagram usernames (e.g., ["cristiano", "leomessi"])

    Returns:
        List of simplified profile dictionaries for agent consumption
    """
    if mock_data:
        # For mock mode, filter from existing data
        with open("dicts.json", "r", encoding="utf-8") as f:
            dicts = json.load(f)
        # Filter by matching usernames
        usernames_lower = [u.lstrip("@").lower() for u in usernames]
        filtered = [
            d for d in dicts if d.get("username", "").lower() in usernames_lower
        ]
        return filtered

    # Fetch profiles directly by usernames
    full_infos, dicts = search_instagram_by_usernames(usernames=usernames)

    # Save complete data to temp file for potential later matching
    influencers_infos = [
        i.to_dict() for i in full_infos if isinstance(i, EnsembleInstaAccount)
    ]
    import os

    temp_dir = tempfile.gettempdir()
    json_path = os.path.join(temp_dir, "insta_influencers.json")
    with open(json_path, "w", encoding="utf-8") as tmpfile:
        json.dump(influencers_infos, tmpfile, ensure_ascii=False, indent=2)

    return dicts


def get_tiktok_profiles_by_usernames(usernames: list[str]):
    """
    Directly fetch TikTok profiles by usernames without topic/keyword search.

    Args:
        usernames: List of TikTok usernames (e.g., ["charlidamelio", "khaby.lame"])

    Returns:
        List of simplified profile dictionaries for agent consumption
    """
    # if mock_data:
    #     # For mock mode, filter from existing data
    #     with open("dicts_tiktok.json", "r", encoding="utf-8") as f:
    #         dicts = json.load(f)
    #     # Filter by matching usernames
    #     usernames_lower = [u.lstrip("@").lower() for u in usernames]
    #     filtered = [
    #         d for d in dicts if d.get("unique_id", "").lower() in usernames_lower
    #     ]
    #     return filtered

    # Fetch profiles directly by usernames
    full_infos, dicts = search_tiktok_by_usernames(usernames=usernames)

    # Save complete data to temp file for potential later matching
    influencers_infos = [
        i.to_dict() for i in full_infos if isinstance(i, EnsembleTiktokAccount)
    ]
    import os

    temp_dir = tempfile.gettempdir()
    json_path = os.path.join(temp_dir, "tiktok_influencers.json")
    with open(json_path, "w", encoding="utf-8") as tmpfile:
        json.dump(influencers_infos, tmpfile, ensure_ascii=False, indent=2)

    return dicts


def get_full_influencer_data_from_db(doc_id: str, usernames: list[str]):
    """
    Fetch influencer_data from MongoDB by doc_id and return influencer dicts whose
    usernames match the provided list. Matches both Instagram (username) and TikTok
    (unique_id) fields, case-insensitive, stripping leading '@'.
    """
    from src.shared.utils.storage import collection

    doc = collection.find_one({"doc_id": doc_id})
    if not doc:
        return []

    data = doc.get("influencer_data", [])
    if not isinstance(data, list):
        return []

    usernames_set = set(u.lstrip("@").lower() for u in usernames)

    matched = []
    for inf in data:
        if not isinstance(inf, dict):
            continue
        insta_username = str(inf.get("username", "")).lower()
        tiktok_id = str(inf.get("unique_id", "")).lower()
        if insta_username in usernames_set or tiktok_id in usernames_set:
            matched.append(inf)

    return matched
