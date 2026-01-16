import json
import src.shared.context as context
from fastapi.middleware.cors import CORSMiddleware
from fastapi import FastAPI, HTTPException, Body
from agno.run.response import RunResponse
from main import run_agent
from src.shared.utils.storage import memory,storage
from src.core.website_analysis import analyze_website
from src.core.basic_search import basic_search
from src.shared.models.website_summary import WebsiteSummary
from src.shared.models.sys_models import (
    FyuzeResponse,
    FyuzeRequest,
    SearchInstaRequest,
    WebsiteUrlRequest,
    BasicSearchRequest,
)
from src.shared.helpers import (
    get_full_influencer_data,
    get_instagram_profiles_by_usernames,
    get_tiktok_profiles_by_usernames,
    extract_usernames_from_text,
    is_mock,
    get_full_influencer_data_from_db,
    
)
from src.core.search_influencers import (
    search_insta_influencers,
    search_tiktok_influencers,
)
from agno.agent import RunResponse
mock = is_mock()

# Initialize FastAPI app
app = FastAPI(
    title="Fyuze Influencer API",
    description="API for finding Instagram influencers using AI agents",
    version="1.0.0",
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {"status": "healthy", "message": "Fyuze API is running"}


@app.get("/")
def root():
    return {"status": "ok"}


@app.post("/find-influencers", response_model=FyuzeResponse)
async def find_influencers(request: FyuzeRequest):
    """Find Instagram influencers based on user request"""
    if not all([request.message, request.user_id, request.session_id]):
        raise HTTPException(
            status_code=400,
            detail="Missing required parameters: message, user_id, and session_id are required",
        )
    context.user_id = request.user_id
    context.session_id = request.session_id
    
    
    try:
        influencers_data = []
        response = run_agent(request.message, request.user_id, request.session_id)
        text = response.text
        role = getattr(response, "role", "assistant")
        platform = response.platform.value if response.platform else None

        raw_usernames = [u for u in response.influencers_usernames or [] if u]
        if not raw_usernames:
            raw_usernames = extract_usernames_from_text(text)

        unique_usernames: list[str] = []
        seen_handles: set[str] = set()
        for handle in raw_usernames:
            normalized = handle.strip()
            if not normalized:
                continue
            key = normalized.lower()
            if key not in seen_handles:
                unique_usernames.append(normalized)
                seen_handles.add(key)
        
        if unique_usernames:
            
            try:
                influencers_data = get_full_influencer_data_from_db(
                    f"{request.user_id}_{request.session_id}", unique_usernames
                )
            except Exception as e:
                print(f"DB lookup ERROR: {e}")
                influencers_data = []

        if not influencers_data and unique_usernames:
            if platform == "instagram":
                file_name = "insta_influencers.json"
            elif platform == "tiktok":
                file_name = "tiktok_influencers.json"
            elif (
                platform in ["combined platforms", "combined_platforms"]
                or platform is None
            ):
                file_name = "combined_platforms"
            else:
                raise HTTPException(
                    status_code=400,
                    detail=f"Invalid platform received from agent: {platform}. Expected 'Instagram', 'TikTok', or combined platforms.",
                )

            try:
                influencers_data = get_full_influencer_data(
                    unique_usernames, file=file_name
                )
            except FileNotFoundError:
                print(f"Warning: Could not find influencer data file '{file_name}'.")
                influencers_data = []

            # if json temp failed, make the refetch (Plan C)
            if not influencers_data:
                normalized = [username.lstrip("@") for username in unique_usernames]
                fallback_data: list[dict] = []
                try:
                    if platform == "instagram":
                        fallback_data = get_instagram_profiles_by_usernames(normalized)
                    elif platform == "tiktok":
                        fallback_data = get_tiktok_profiles_by_usernames(normalized)
                    else:
                        try:
                            fallback_data.extend(
                                get_instagram_profiles_by_usernames(normalized)
                            )
                        except Exception:
                            pass
                        try:
                            fallback_data.extend(
                                get_tiktok_profiles_by_usernames(normalized)
                            )
                        except Exception:
                            pass
                except Exception as fetch_error:
                    print(
                        "Warning: fallback profile lookup failed for "
                        f"{normalized}: {fetch_error}"
                    )
            #if fetch worked, use that data
                if fallback_data:
                    influencers_data = fallback_data


        final_response = FyuzeResponse.model_validate(
            {
                "text": text,
                "role": role,
                "influencers_found": influencers_data,
            }
        )
        return final_response

    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Internal server error: {str(e)}"
        ) from e

@app.post("/analyze_website", response_model=WebsiteSummary)
def analyze_website_post_endpoint(body: WebsiteUrlRequest = Body(...)):
    """
    Analyze a website and return a structured summary (POST).
    """
    if mock:
        with open("website_summary.json", "r", encoding="utf-8") as f:
            data = json.load(f)
        return data
    summary = analyze_website(str(body.url))
    return summary.model_dump()

@app.post("/search_insta_influencers")
def search_insta_influencers_endpoint(req: SearchInstaRequest = Body(...)):
    """
    Search for Instagram influencers and return both the full ensemble model and agent dicts.
    """
    if mock:
        # Return static data
        with open("fyuze_influencers_infos.json", "r", encoding="utf-8") as f:
            data = json.load(f)
        return {"platform_data": data}
    num_results = req.search_results if req.search_results is not None else 10
    if num_results > 10:
        raise HTTPException(
            status_code=400, detail="search_results must be at most 10."
        )
    elif num_results < 1:
        num_results = 1
    ensemble_objs, agent_dicts = search_insta_influencers(
        topic=req.topic,
        location=req.location,
        keywords=req.keywords,
        search_results=num_results,
    )
    ensemble_json = [obj.to_dict() for obj in ensemble_objs]
    return {"platform_data": ensemble_json}

@app.post("/search_tiktok_influencers")
def search_tiktok_influencers_endpoint(req: SearchInstaRequest = Body(...)):
    """
    Search for Instagram influencers and return both the full ensemble model and agent dicts.
    """
    if mock:
        # Return static data
        with open("fyuze_influencers_infos_tiktok.json", "r", encoding="utf-8") as f:
            data = json.load(f)
        return {"platform_data": data}

    num_results = req.search_results if req.search_results is not None else 10
    if num_results > 10:
        raise HTTPException(
            status_code=400, detail="search_results must be at most 10."
        )
    elif num_results < 1:
        num_results = 1
    ensemble_objs, agent_dicts = search_tiktok_influencers(
        topic=req.topic,
        location=req.location,
        keywords=req.keywords,
        search_results=num_results,
    )
    ensemble_json = [obj.to_dict() for obj in ensemble_objs]
    return {"platform_data": ensemble_json}

@app.post("/basic_search")
def basic_search_endpoint(body: BasicSearchRequest = Body(...)):
    """
    Perform a basic Google Custom Search and return structured results.
    """
    try:
        if mock:
            with open("basic_search.json", "r", encoding="utf-8") as f:
                data = json.load(f)
            return data
        result = basic_search(body.query, body.gl)
        return result.to_dict()
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Internal server error: {str(e)}"
        ) from e


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)