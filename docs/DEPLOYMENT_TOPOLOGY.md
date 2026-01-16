# Deployment Topology – Supabase & AWS Fargate

This note simply records the architectural relationship between Supabase and the FastAPI application so future owners understand how the pieces fit together without digging through infrastructure code or run-books.

## High-Level Structure
- **Supabase layer**: Hosted Postgres + functions that store influencer payloads, cache crawler results, and expose RPC endpoints (`insert_creator_from_payload`, etc.). Internal teams also treated Supabase as the canonical interface for reading influencer data.
- **Application layer**: The FastAPI service defined in this repository (`fastapi_app.py`). It runs as a container derived from the project `Dockerfile` and is responsible for orchestrating Groq agents, Ensemble/Rapid services, and writing data back to Supabase.
- **Runtime host**: AWS ECS with **Fargate** tasks. Each deployment runs a single FastAPI container inside a Fargate service that sits behind an AWS Application Load Balancer. Environment variables provide the Supabase URL/key so the app can read/write to the database.

## Data Flow Summary
1. Clients send HTTPS requests to the public ALB.
2. The ALB forwards traffic to the FastAPI container running on Fargate.
3. FastAPI executes agent flows, gathers influencer data, and persists structured results through Supabase RPC calls.
4. External consumers pull reports directly from Supabase, making it the shared interface between the app and any downstream tooling.

## Migration Notes
- If you deploy the app to a new Fargate service, bring a Supabase project along (or restore the backup stored in `DB/`).
- Update the application’s environment variables (`SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY`) so the new service points to the correct Supabase instance.
- Downstream users consuming Supabase data must be notified when the URL changes, because Supabase remains the system-of-record interface even after the hosting environment moves.

There is no deeper guide here—this document is meant purely to describe how **Supabase ↔ AWS Fargate (FastAPI)** connect so handoffs stay clear.
