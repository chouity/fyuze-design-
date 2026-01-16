"""Test script for get_insta_report function.

Executes the function and saves comprehensive results including:
- Execution status (success/failure)
- Execution time
- Agent input data
- Agent response (both model dump and JSON)
- Error details if applicable
"""

import json
import time
import traceback
from datetime import datetime
from pathlib import Path

from dotenv import load_dotenv
from src.core.get_insta_report import get_insta_report

# Load environment variables
load_dotenv()


def test_get_insta_report(username: str, output_file: str = None):
    """
    Test the get_insta_report function and save detailed results.

    Args:
        username: Instagram username to analyze (e.g., "daddyfoody")
        output_file: Optional path to save results. Defaults to
                    "test_results_get_insta_report_{timestamp}.json"
    """
    # Initialize result dictionary
    result = {
        "test_metadata": {
            "username": username,
            "timestamp": datetime.now().isoformat(),
            "function": "get_insta_report",
        },
        "execution": {
            "status": None,
            "execution_time_seconds": None,
            "error": None,
            "error_traceback": None,
        },
        "agent_input": None,
        "agent_response": {
            "model_dump": None,
            "model_dump_json": None,
        },
    }

    # Track execution time
    start_time = time.time()

    try:
        print(f"[INFO] Testing get_insta_report for username: {username}")
        print("[INFO] Fetching Instagram profile data...")

        # Execute the function
        report = get_insta_report(username)

        # Calculate execution time
        execution_time = time.time() - start_time
        result["execution"]["execution_time_seconds"] = round(execution_time, 2)
        result["execution"]["status"] = "success"

        # Capture agent response
        result["agent_response"]["model_dump"] = report.model_dump()
        result["agent_response"]["model_dump_json"] = report.model_dump_json()

        print(f"[SUCCESS] Report generated successfully in {execution_time:.2f}s")
        print(f"[INFO] Summary: {report.summary_narrative[:100]}...")

    except Exception as e:
        # Calculate execution time even on failure
        execution_time = time.time() - start_time
        result["execution"]["execution_time_seconds"] = round(execution_time, 2)
        result["execution"]["status"] = "failed"
        result["execution"]["error"] = str(e)
        result["execution"]["error_traceback"] = traceback.format_exc()

        print(f"[ERROR] Test failed after {execution_time:.2f}s")
        print(f"[ERROR] {str(e)}")
        print("[ERROR] Full traceback saved to output file")

    # Generate output filename if not provided
    if output_file is None:
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        output_file = f"test_results_get_insta_report_{timestamp}.json"

    # Save results to file
    output_path = Path(output_file)
    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(result, f, indent=2, ensure_ascii=False)

    print(f"[INFO] Results saved to: {output_path.absolute()}")

    return result


def test_get_insta_report_with_input_capture(username: str, output_file: str = None):
    """
    Test the get_insta_report function with detailed input capture.

    This version captures the agent input data before running the agent,
    providing more visibility into what data was fed to the analysis.

    Args:
        username: Instagram username to analyze
        output_file: Optional path to save results
    """
    from src.modules.info_crawler import InfoCrawler
    from src.shared.services.rapid_service import RapidService

    # Initialize result dictionary
    result = {
        "test_metadata": {
            "username": username,
            "timestamp": datetime.now().isoformat(),
            "function": "get_insta_report_with_input_capture",
        },
        "execution": {
            "status": None,
            "execution_time_seconds": None,
            "error": None,
            "error_traceback": None,
        },
        "agent_input": {
            "ensemble_summary": None,
            "rapid_summary": None,
            "combined_input": None,
        },
        "agent_response": {
            "model_dump": None,
            "model_dump_json": None,
        },
    }

    # Track execution time
    start_time = time.time()

    try:
        print(f"[INFO] Testing get_insta_report for username: {username}")

        # Step 1: Fetch Instagram profile data
        print("[INFO] Step 1/3: Fetching Instagram profile data...")
        info_crawler = InfoCrawler()
        ensemble_account = info_crawler.crawl_instagram_usernames([username])[0]
        ensemble_summary = ensemble_account.get_agent_summary()
        result["agent_input"]["ensemble_summary"] = ensemble_summary

        # Step 2: Fetch audience demographics
        print("[INFO] Step 2/3: Fetching audience demographics...")
        rapid_service = RapidService()
        profile_url = f"https://www.instagram.com/{username}/"
        rapid_response = rapid_service.get_audience_snapshot(profile_url)
        rapid_summary = rapid_response.get_agent_summary()
        result["agent_input"]["rapid_summary"] = rapid_summary

        # Combine inputs
        combined_input = f"{ensemble_summary}\n\n{rapid_summary}"
        result["agent_input"]["combined_input"] = combined_input

        # Step 3: Run agent
        print("[INFO] Step 3/3: Generating insights report...")
        from src.agent.insta_marketing_expert import insta_marketing_expert

        report = insta_marketing_expert.run(combined_input)

        # Calculate execution time
        execution_time = time.time() - start_time
        result["execution"]["execution_time_seconds"] = round(execution_time, 2)
        result["execution"]["status"] = "success"

        # Capture agent response
        result["agent_response"]["model_dump"] = report.content.model_dump()
        result["agent_response"]["model_dump_json"] = report.content.model_dump_json()

        print(f"[SUCCESS] Report generated successfully in {execution_time:.2f}s")
        print(f"[INFO] Summary: {report.content.summary_narrative[:100]}...")

    except Exception as e:
        # Calculate execution time even on failure
        execution_time = time.time() - start_time
        result["execution"]["execution_time_seconds"] = round(execution_time, 2)
        result["execution"]["status"] = "failed"
        result["execution"]["error"] = str(e)
        result["execution"]["error_traceback"] = traceback.format_exc()

        print(f"[ERROR] Test failed after {execution_time:.2f}s")
        print(f"[ERROR] {str(e)}")
        print("[ERROR] Full traceback saved to output file")

    # Generate output filename if not provided
    if output_file is None:
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        output_file = f"test_results_get_insta_report_{timestamp}.json"

    # Save results to file
    output_path = Path(output_file)
    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(result, f, indent=2, ensure_ascii=False)

    print(f"[INFO] Results saved to: {output_path.absolute()}")

    return result


if __name__ == "__main__":
    # Test configuration
    TEST_USERNAME = "daddyfoody"  # Change this to test different accounts

    # Run test with detailed input capture
    print("=" * 80)
    print("TESTING get_insta_report WITH INPUT CAPTURE")
    print("=" * 80)
    test_get_insta_report_with_input_capture(TEST_USERNAME)

    print("\n" + "=" * 80)
    print("Test completed!")
    print("=" * 80)
