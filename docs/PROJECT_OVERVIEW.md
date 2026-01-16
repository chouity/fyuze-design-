# Fyuze AI – Handover Overview

This document gives new contributors a high-level understanding of the Fyuze AI influencer-discovery platform, how it is structured, how major flows work, and what is required to operate or extend it safely.

## Product At A Glance
- **Mission**: Full-stack conversational assistant that helps marketers discover Instagram / TikTok influencers, review websites, and retrieve structured marketing insight reports through an intuitive web interface.
- **Architecture**: React TypeScript frontend (`fyuze-frontend/`) + FastAPI backend (`fastapi_app.py`) with AI-powered chat interface and dynamic multi-platform creator discovery.
- **Primary interface**: Modern React SPA with AI chat, creator dashboard, profile pages, URL analyzer, and subscription management, communicating with REST API endpoints.
- **Core intelligence**: Groq-hosted LLMs orchestrated via the [`agno`](https://pypi.org/project/agno/) agent framework with tool-calling for search, crawling, and enrichment tasks.
- **Data sources**: EnsembleData API, Apify actors, RapidAPI demographic endpoints, Exa search, MongoDB (temporary storage), Supabase (medium-term cache + authentication), Playwright/Crawl4AI website crawlers, and optional JSON fixtures when `MOCK_DATA=1`.
- **Deployment**: Python 3.11 backend service with Playwright-enabled Docker image + Vite-built React frontend served statically or via development server.

## High-Level Architecture
```
React Frontend (fyuze-frontend/) 
    ↓ HTTP/REST API
FastAPI Backend (fastapi_app.py)
    ↓
run_agent → Agno Agent (src/agent/fyuze_agent.py)
    ↘ platform endpoints (/search_*, /basic_search, /analyze_website)
Agent tools → src/core search/analysis modules → src/modules crawlers
    ↓
Shared services (src/shared/services) → External APIs (Ensemble, Rapid, Apify, Exa)
    ↓
Mongo/Supabase persistence via src/shared/utils/storage
```

### Frontend Architecture (React + TypeScript)
```
User Interface
    ↓
React Components (pages/, components/)
    ↓
Context Providers (Auth, Chat, Theme, Toast)
    ↓
Custom Hooks (useChat, useCreatorsParsing, usePlatformCreators)
    ↓
Services & Adapters (PlatformService, Supabase Client)
    ↓
Backend API + Supabase (Auth & Data)
```

Key execution surfaces:

**Frontend (fyuze-frontend/)**:
- **Main application**: React SPA with routing (`App.tsx`), authentication flow, and protected routes
- **Core pages**: Chat interface (`/app`), Creator Dashboard (`/creators`), Creator Profile (`/creators/:id`), URL Analyzer, Admin Dashboard, Subscription Plans
- **Platform abstraction**: Dynamic multi-platform system supporting Instagram, TikTok, YouTube, Twitter/X, and extensible to new platforms
- **State management**: Context API for Auth, Chat, Theme, and Toast notifications + TanStack Query for server state
- **UI components**: Reusable, platform-agnostic components for profiles, dashboards, cards, and analytics

**Backend (FastAPI server)**:
- **API endpoints**: `/health`, `/find-influencers`, `/search_insta_influencers`, `/search_tiktok_influencers`, `/basic_search`, `/analyze_website`
- **Agent runtime**: `src/agent/fyuze_agent.py` (customer-facing) and `src/agent/insta_marketing_expert.py` (internal marketing insights agent). Agents use Groq OSS models for both response generation and structured parsing
- **Background scripts/tests**: curated Python scripts in repository root (`test_get_insta_report.py`, `test_insta_agent.py`, `test.py`) plus `scripts/build_protected_search_engine.py` for compiling intellectual-property-sensitive search code

## Directory Orientation

### Backend (Python/FastAPI)
| Path | Purpose |
| --- | --- |
| `fastapi_app.py`, `main.py` | API entry points. `main.py` exposes `run_agent` used by HTTP handler and any CLI/SDK consumers. |
| `DB/` | Supabase backup bundle plus operational notes on restoring/using the database snapshot. |
| `src/agent/` | Agno agent definitions and prompts. Controls tool wiring, Groq models, parser model, retry/backoff, and storage integration. |
| `src/core/` | Thin orchestration layers for influencer search (`search_influencers.py`), Basic Google Custom Search (`basic_search.py`), website analysis (`website_analysis.py`), and Instagram report generation (`get_insta_report.py`). |
| `src/modules/` | Higher-level service objects (e.g., `info_crawler.InfoCrawler`, `websites_analyzer.WebsitesAnalyzer`) that compose third-party APIs, caching, and persistence. |
| `src/protected/search_engine/` | Loader for proprietary compiled search engine (`dist/protected/search_engine`). Rebuild via `python scripts/build_protected_search_engine.py`. |
| `src/shared/` | Common models (`models/`), enums, services (Supabase, Ensemble, Apify, Rapid, Exa, URL crawling, agent factory), helpers, context, and utilities (logging, retry, cache, MongoDB storage). |
| `docs/` | Human-facing documentation (this file, deployment topology, MongoDB setup). |
| `scripts/` | Maintenance utilities (currently only protected search engine build script). |
| `requirements.txt` | Locked dependency list (Groq SDK, Agno, FastAPI, Playwright/Crawl4AI, Mongo, Supabase, EnsembleData client, etc.). |

### Frontend (React/TypeScript)
| Path | Purpose |
| --- | --- |
| `fyuze-frontend/src/` | Main source directory for React application |
| `fyuze-frontend/src/components/` | Reusable UI components organized by feature (admin, chatInterface, common, creators, dashboard, influencerCard, profile, sidebar) |
| `fyuze-frontend/src/pages/` | Top-level page components (AuthPage, CreatorDashboardPage, CreatorProfilePage, ContactUsPage, AdminDashboardPage, UrlAnalyzerPage, etc.) |
| `fyuze-frontend/src/contexts/` | React Context providers (AuthContext, ChatContext, ThemeContext, ToastContext) for global state management |
| `fyuze-frontend/src/hooks/` | Custom React hooks (useChat, useCreatorsParsing, usePlatformCreators, useAICreatorSearch, useUrlAnalyzer, useSubscription, etc.) |
| `fyuze-frontend/src/services/` | Platform abstraction layer with PlatformService and adapters (InstagramAdapter, TikTokAdapter) for unified multi-platform handling |
| `fyuze-frontend/src/types/` | TypeScript type definitions (platform.types.ts, influencer types, chat types, database types) |
| `fyuze-frontend/src/utils/` | Utility functions (number formatting, date handling, platform data extraction, validation) |
| `fyuze-frontend/src/config/` | Configuration files (platforms.ts for multi-platform configs, colors.ts for theme settings) |
| `fyuze-frontend/src/lib/` | Third-party library initialization (Supabase client, TanStack Query client) |
| `fyuze-frontend/src/Layout/` | Layout components (ChatInterface) |
| `fyuze-frontend/public/` | Static assets |
| `fyuze-frontend/package.json` | Frontend dependencies (React 19, TypeScript, Vite, Supabase, TanStack Query, Tailwind CSS, etc.) |
| `fyuze-frontend/vite.config.ts` | Vite build configuration |
| `fyuze-frontend/tailwind.config.js` | Tailwind CSS configuration with dark mode support |
| `fyuze-frontend/*.md` | Frontend documentation (README, PLATFORM_SYSTEM_GUIDE, DATA_FLOW_VERIFICATION, THEME_CONTEXT_GUIDE, USAGE_EXAMPLE) |

## Core Application Flows

### 1. Frontend User Journey
1. **Authentication**: User lands on AuthPage, signs up/logs in via Supabase Auth (magic link or password). Email verification required.
2. **Main App**: After authentication, user enters the main app (`/app`) with sidebar navigation, chat interface, and theme toggle.
3. **AI Chat Discovery**: User asks natural language questions in chat (e.g., "Find Italian food creators in Dubai"), which calls `/find-influencers` backend endpoint.
4. **Results Display**: Chat shows AI response with influencer cards. User can view creator profiles, add to favorites, or continue conversation.
5. **Creator Dashboard**: Navigate to creators page to browse/search database of cached creators, with filters for platform, location, engagement, etc.
6. **Creator Profile**: Click any creator card to view detailed profile with stats, posts, insights, and platform-specific analytics.
7. **URL Analyzer**: Analyze websites for marketing insights using the URL analyzer tool.
8. **Subscription Management**: View/upgrade subscription plans (if enabled) for premium features.

### 2. Conversational Influencer Discovery (`/find-influencers`)
1. Frontend sends message to `fastapi_app.find_influencers` which validates `FyuzeRequest`, populates `src.shared.context` with `user_id` and `session_id`, then calls `run_agent` from `main.py`.
2. `src/agent/fyuze_agent.py` (Groq `openai/gpt-oss-120b`) decides whether to call tools exposed through `src/shared/helpers` (Instagram/TikTok search, username lookup) or `src/core.website_analysis`.
3. Tool functions go through `src/core.search_influencers`, which in turn calls `SearchEngine` (protected binary) and `InfoCrawler` for detailed profiles. `InfoCrawler` pulls and caches data via `EnsembleService`, `SupabaseService`, and optionally `RapidService` for audience stats.
4. While the agent runs, all tool outputs are persisted as `influencer_data` documents in Mongo (`src/shared/utils/storage.collection`) keyed by `f"{user_id}_{session_id}"` for later enrichment.
5. After the agent replies, `/find-influencers` deduplicates handles, looks up cached details (Mongo first, temp JSON fallback, live profile fetch as last resort), and responds with `FyuzeResponse` (text + structured influencer payload).
6. Frontend receives response, displays AI message in chat, and renders influencer cards with platform-specific data using the PlatformService abstraction layer.

### 3. Direct Search APIs
- **`/search_insta_influencers` / `/search_tiktok_influencers`** delegate to `src/core/search_influencers` to run keyword/location searches via the protected `SearchEngine`, fetch profile details using `InfoCrawler`, and return serialized ensemble objects. TikTok search splits queries and uses multi-threaded crawls.
- **`/basic_search`** calls `src/core/basic_search.basic_search`, which is a wrapper around `SearchEngine.basic_search` returning `BasicSearchResult` models (structured Google Custom Search data).
- Frontend can call these endpoints directly from the Creator Dashboard for database queries and advanced search.

### 4. Website Analysis (`/analyze_website`)
- Frontend URL analyzer sends URL to backend
- `src/core.website_analysis.analyze_website` orchestrates `WebsitesAnalyzer`, which crawls content with `UrlCrawlingService` (Playwright+Crawl4AI) and summarizes it via an `AgentService`-built Groq model returning `WebsiteSummary`.
- Results displayed in frontend with structured insights

### 5. Marketing Insight Reports (`get_insta_report.py`)
1. `InfoCrawler` fetches Instagram profile data (with Supabase cache).
2. `RapidService` hits the RapidAPI demographics endpoint for audience snapshots.
3. Summaries are merged and passed to the `insta_marketing_expert` agent, which emits a `MarketingInsightsReport` Pydantic model consumed by tests or future API exposure.

### 6. Frontend Data Flow - Chat to Profile
1. **Static/AI Response**: Chat receives creator data from backend with `originalPlatformData` preserved
2. **Transformation**: `useChat` hook transforms data into unified `Influencer` interface maintaining platform-specific fields
3. **Navigation**: `useProfileNavigation` hook transforms influencer to `Creator` object, preserving `platform_data` and setting `dataSource: 'ai_search'`
4. **Profile Display**: `CreatorProfilePage` receives creator via navigation state, uses `useCreatorsParsing` to process platform-specific data
5. **Platform Abstraction**: `PlatformService` detects platform and uses appropriate adapter (InstagramAdapter/TikTokAdapter) to extract unified profile structure
6. **Component Rendering**: Platform-agnostic components (ProfileHeader, ProfileStats, ProfilePosts, ProfileInsights) render data with platform-specific styling

## Key Supporting Services

### Backend Services
- **SearchEngine (`src/protected/search_engine`)**: proprietary module compiled to bytecode; supports Google Custom Search, Instagram/TikTok scraping heuristics, and result ranking. Always rebuild after changing `src/modules/search_engine` via `scripts/build_protected_search_engine.py`.
- **InfoCrawler**: central crawler that coordinates Instagram/TikTok scraping, Supabase caching, Mongo writes, and Rapid audience enrichment. Handles retries, fallback, and ensures username order is preserved.
- **Shared services**: `SupabaseService`, `EnsembleService`, `ApifyService`, `RapidService`, `ExaSearchService`, `UrlCrawlingService`, and `AgentService` each encapsulate vendor-specific auth + concurrency patterns.
- **MongoDB storage**: configured in `src/shared/utils/storage.py`, using `MONGODB_URI` to back both Agno agent state (`MongoDbStorage`) and custom `collection` operations for influencer blobs.
- **Logging & diagnostics**: `src/shared/utils/logging.py` defines `FyuzeLogger` with rotating file handlers under `logs/`. Most services instantiate this logger; ensure the path is writable in deployment environments.

## Key Supporting Services

### Backend Services
- **SearchEngine (`src/protected/search_engine`)**: proprietary module compiled to bytecode; supports Google Custom Search, Instagram/TikTok scraping heuristics, and result ranking. Always rebuild after changing `src/modules/search_engine` via `scripts/build_protected_search_engine.py`.
- **InfoCrawler**: central crawler that coordinates Instagram/TikTok scraping, Supabase caching, Mongo writes, and Rapid audience enrichment. Handles retries, fallback, and ensures username order is preserved.
- **Shared services**: `SupabaseService`, `EnsembleService`, `ApifyService`, `RapidService`, `ExaSearchService`, `UrlCrawlingService`, and `AgentService` each encapsulate vendor-specific auth + concurrency patterns.
- **MongoDB storage**: configured in `src/shared/utils/storage.py`, using `MONGODB_URI` to back both Agno agent state (`MongoDbStorage`) and custom `collection` operations for influencer blobs.
- **Logging & diagnostics**: `src/shared/utils/logging.py` defines `FyuzeLogger` with rotating file handlers under `logs/`. Most services instantiate this logger; ensure the path is writable in deployment environments.

### Frontend Services & Architecture
- **PlatformService**: Central orchestrator for multi-platform support with automatic platform detection, dynamic field extraction, and adapter-based processing. Currently supports Instagram, TikTok, YouTube, Twitter/X, Facebook, LinkedIn, Snapchat, Pinterest, and Twitch.
- **Platform Adapters**: Each platform has a dedicated adapter (InstagramAdapter, TikTokAdapter) implementing the `PlatformAdapter` interface for platform-specific data extraction, post processing, engagement normalization, and data validation.
- **AuthContext**: Manages user authentication via Supabase Auth, handles login/signup/logout, email verification flow, and password reset functionality.
- **ChatContext**: Manages conversation state, message history, conversation switching, and local storage persistence for chat interface.
- **ThemeContext**: Provides dark/light mode theming with localStorage persistence, system preference detection, and Tailwind CSS integration.
- **ToastContext**: Global toast notification system for user feedback on actions, errors, and success messages.
- **Custom Hooks**: 
  - `useCreatorsParsing`: Processes raw creator data with platform detection and normalization
  - `usePlatformCreators`: Fetches and manages platform-specific creator data from Supabase
  - `useAICreatorSearch`: Handles AI-powered creator search with natural language queries
  - `useUrlAnalyzer`: Integrates with backend website analysis endpoint
  - `useSubscription`: Manages user subscription state and Stripe integration
  - `useChat`: Handles message sending, streaming responses, and influencer card rendering
- **Supabase Integration**: 
  - Authentication (magic links, password auth, email verification)
  - Database queries for creator data with RPC functions
  - Real-time subscriptions (if enabled)
  - Storage for user-generated content
- **TanStack Query**: Server state management with caching, background refetching, optimistic updates, and devtools for debugging.

## Frontend Technology Stack

### Core Framework & Build Tools
- **React 19.1**: Latest React with concurrent features, automatic batching, and transitions
- **TypeScript 5.8**: Strict type checking for enhanced developer experience and fewer runtime errors
- **Vite 7.1**: Lightning-fast build tool with HMR (Hot Module Replacement) for instant feedback during development
- **React Router DOM 7.8**: Client-side routing with type-safe navigation and nested routes

### UI & Styling
- **Tailwind CSS 4.1**: Utility-first CSS framework with custom configuration for dark mode support
- **Tailwind Typography**: Plugin for beautiful typographic defaults
- **Lucide React**: Modern icon library with 1000+ icons
- **FontAwesome**: Brand and social media icons for platform badges
- **React Icons**: Supplementary icon set
- **React Pro Sidebar**: Professional sidebar component with collapse/expand functionality

### State Management & Data Fetching
- **TanStack Query 5.85** (React Query): Powerful async state management with:
  - Automatic background refetching
  - Smart caching and deduplication
  - Optimistic updates
  - Infinite queries and pagination
  - DevTools for debugging
- **React Context API**: Global state for auth, chat, theme, and notifications
- **Local Storage**: Persistence for user preferences and chat history

### Backend Integration
- **Supabase JS 2.56**: Full-featured SDK for:
  - Authentication (email/password, magic links, OAuth)
  - PostgreSQL database queries
  - Real-time subscriptions
  - File storage
  - Row Level Security (RLS)
- **Supabase CLI 2.34**: Database migrations, type generation, local development

### Forms & Validation
- **React DatePicker 8.7**: Date/time selection for filters and scheduling
- **CLSX 2.1**: Utility for constructing className strings conditionally

### Markdown & Content
- **React Markdown 10.1**: Markdown rendering in chat interface
- **Remark GFM 4.0**: GitHub Flavored Markdown support (tables, task lists, strikethrough)
- **Rehype Highlight 7.0**: Syntax highlighting for code blocks in markdown

### Testing Infrastructure
- **Vitest 3.2**: Fast unit test runner powered by Vite
- **React Testing Library 16.3**: Component testing with user-centric queries
- **Jest DOM 6.8**: Custom matchers for DOM node assertions
- **jsdom 26.1**: JavaScript implementation of web standards for Node.js testing

### Code Quality
- **ESLint 9.33**: Linting with React hooks and Query plugins
- **TypeScript ESLint 8.39**: TypeScript-specific linting rules
- **Prettier** (via editor config): Code formatting for consistency

### Development Experience
- **Hot Module Replacement**: Instant updates without full page reload
- **TypeScript IntelliSense**: Auto-completion and type hints in IDE
- **React DevTools**: Component tree inspection and props debugging
- **TanStack Query DevTools**: Cache and query state visualization
- **Source Maps**: Easy debugging in browser DevTools

## Frontend Key Features

### 1. Dynamic Multi-Platform System
- **Platform Abstraction Layer**: Unified interface for Instagram, TikTok, YouTube, Twitter/X, Facebook, LinkedIn, Snapchat, Pinterest, Twitch
- **Automatic Platform Detection**: Identifies platform from data structure without manual specification
- **Extensible Architecture**: Add new platforms with ~100 lines of code (adapter + config)
- **Field Mapping System**: Normalizes platform-specific fields to unified schema
- **90% Code Reduction**: Achieved by replacing platform-specific logic with adapters

### 2. AI-Powered Creator Discovery
- **Natural Language Search**: Ask questions like "Find Italian food creators in Dubai"
- **Conversational Interface**: Multi-turn conversations with context retention
- **Influencer Cards**: Rich preview cards with stats, bio, and quick actions
- **Profile Navigation**: Seamless transition from chat to detailed profile pages
- **Data Preservation**: Original platform data maintained through navigation flow

### 3. Advanced Creator Dashboard
- **Multi-Source Data**: Combines database cache, AI search, and real-time API data
- **Platform Filtering**: Filter by Instagram, TikTok, or view all platforms
- **Advanced Filters**: 
  - Location/country
  - Follower range
  - Engagement rate
  - Verification status
- **Search Modes**: Keyword search, AI search, and database queries
- **View Modes**: Table view and card grid view
- **Pagination**: Efficient handling of large creator lists
- **Sorting**: Sort by followers, engagement, or relevance

### 4. Comprehensive Creator Profiles
- **Platform-Agnostic Components**: Same UI components work across all platforms
- **Profile Header**: Avatar, verification badge, bio, contact info, social links
- **Statistics Dashboard**: Followers, following, posts, engagement rate with visual indicators
- **Content Grid**: Posts/videos with hover previews, like/comment counts
- **Performance Insights**: 
  - Engagement analysis
  - Best performing content
  - Audience demographics (when available)
  - Growth trends
- **Action Buttons**: Save to favorites, export data, share profile

### 5. Authentication & User Management
- **Multiple Auth Methods**: 
  - Email/password
  - Magic link (passwordless)
  - OAuth providers (extensible)
- **Email Verification**: Required verification with resend capability
- **Password Reset**: Secure reset flow with email confirmation
- **Session Management**: Automatic session refresh and token handling
- **Protected Routes**: Route guards for authenticated-only pages
- **User Profile**: Name, email, preferences, subscription status

### 6. Theme System
- **Dark/Light Mode**: Full theme support with smooth transitions
- **System Sync**: Auto-detect user's OS theme preference
- **Persistent Preference**: Saves choice to localStorage
- **Tailwind Integration**: Uses Tailwind's class-based dark mode
- **Custom Theme Utilities**: Helper functions for theme-aware styling
- **Gradient Backgrounds**: Platform-specific gradient colors

### 7. Real-Time Chat Interface
- **Streaming Responses**: AI responses stream token-by-token
- **Conversation Management**: 
  - Multiple conversations with auto-generated titles
  - Conversation switching
  - Delete conversations
  - Conversation persistence
- **Message Types**: 
  - User messages
  - AI text responses
  - Influencer cards
  - Error messages
- **Input Features**: 
  - Auto-resize textarea
  - Send on Enter (Shift+Enter for new line)
  - Loading states
  - Character/token counting (if needed)

### 8. URL Analyzer Tool
- **Website Analysis**: Paste any URL for AI-powered analysis
- **Content Extraction**: Crawls and summarizes website content
- **Marketing Insights**: Identifies brand positioning, target audience, content strategy
- **Integration Ready**: Connects to backend Playwright/Crawl4AI service

### 9. Responsive Design
- **Mobile-First**: Optimized for mobile devices
- **Breakpoint System**: Tailwind's responsive utilities (sm, md, lg, xl, 2xl)
- **Adaptive Layouts**: Components adjust to screen size
- **Touch-Friendly**: Large tap targets, swipe gestures
- **Sidebar Behavior**: 
  - Overlay on mobile
  - Fixed sidebar on desktop
  - Collapse/expand functionality

### 10. Performance Optimizations
- **Code Splitting**: Lazy loading for heavy components (dashboard, profile, admin)
- **React Suspense**: Fallback UI during component loading
- **Query Caching**: TanStack Query prevents redundant API calls
- **Memoization**: React.memo for expensive components
- **Virtual Scrolling**: Ready for large lists (can be implemented)
- **Image Optimization**: Lazy loading images, responsive sizes
- **Bundle Size**: Vite's tree-shaking and minification

### 11. Developer Experience
- **Type Safety**: Comprehensive TypeScript coverage
- **Auto-Complete**: IntelliSense for props, functions, types
- **Hot Reload**: Instant feedback during development
- **Error Boundaries**: Graceful error handling (expandable)
- **Console Logging**: Strategic logging for debugging
- **Dev Tools**: React DevTools, Query DevTools, browser extensions
- **Code Organization**: Feature-based folder structure

## Configuration & Environment

### Backend Environment Variables
Create a `.env` file (not committed) and provide at minimum:

| Variable | Purpose |
| --- | --- |
| `GROQ_API_KEY` | Required by Agno Groq models. |
| `MONGODB_URI` | Connection string for agent storage + influencer temp cache. |
| `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY`, `CREATOR_DATA_MAX_AGE_DAYS` | Enable Supabase caching layer inside `InfoCrawler`. |
| `ENSEMBLE_API_KEY` | Ensemble Data scraping (Instagram/TikTok). |
| `RAPID_API_KEY`, `RAPID_API_HOST` | Instagram demographic snapshots. |
| `APIFY_API_TOKEN` | Optional Apify-based scrapers. |
| `EXA_API_KEY` | Exa semantic search service. |
| `CRAWLER_MAX_DEPTH`, `CRAWLER_MAX_PAGES` | Optional overrides for Crawl4AI depth/breadth. |
| `MOCK_DATA` | Set to `1` to bypass external calls and use bundled JSON fixtures in development. |

### Frontend Environment Variables
Create `fyuze-frontend/.env` file:

| Variable | Purpose |
| --- | --- |
| `VITE_SUPABASE_URL` | Supabase project URL for authentication and database queries. |
| `VITE_SUPABASE_ANON_KEY` | Supabase anonymous key for client-side operations. |
| `VITE_API_BASE_URL` | Backend API base URL (e.g., `http://localhost:8000` for development). |

Other vendor-specific variables may be required if extending integrations; search for `os.getenv(` in backend or `import.meta.env` in frontend to locate them.

## Running Locally

### Backend Setup (Python/FastAPI)
1. **Python environment** (Windows PowerShell example):
	```powershell
	python -m venv venv
	.\venv\Scripts\Activate.ps1
	pip install --upgrade pip
	pip install -r requirements.txt
	```
2. **Environment variables**: copy `.env.template` if available or create `.env` manually with the keys above.
3. **Protected search engine** (only needed after modifying source):
	```powershell
	python scripts/build_protected_search_engine.py
	```
4. **Run FastAPI**:
	```powershell
	uvicorn fastapi_app:app --host 0.0.0.0 --port 8000 --reload
	```
5. **Sample requests** (PowerShell):
	```powershell
	Invoke-RestMethod -Method Post `
	  -Uri http://localhost:8000/find-influencers `
	  -Body (@{message="Find Italian food creators in Dubai"; user_id="demo"; session_id="s1"} | ConvertTo-Json) `
	  -ContentType "application/json"
	```
6. **Docker**: `docker build -t fyuze-ai . && docker run -p 8000:8000 --env-file .env fyuze-ai` (Playwright dependencies are baked into the image).

### Frontend Setup (React/TypeScript)
1. **Navigate to frontend directory**:
	```powershell
	cd fyuze-frontend
	```
2. **Install dependencies**:
	```powershell
	npm install
	```
3. **Environment variables**: Create `.env` file with Supabase credentials:
	```env
	VITE_SUPABASE_URL=your-project-url
	VITE_SUPABASE_ANON_KEY=your-anon-key
	VITE_API_BASE_URL=http://localhost:8000
	```
4. **Start development server**:
	```powershell
	npm run dev
	```
	Application runs at `http://localhost:5173` (or configured port)
5. **Build for production**:
	```powershell
	npm run build
	npm run preview  # Preview production build locally
	```
6. **Database types regeneration** (if Supabase schema changes):
	```powershell
	npx supabase gen types typescript --project-id "your-project-id" --schema public > database.types.ts
	```

### Full Stack Development
1. Start backend: `uvicorn fastapi_app:app --host 0.0.0.0 --port 8000 --reload`
2. Start frontend: `cd fyuze-frontend && npm run dev`
3. Access application at frontend URL (typically `http://localhost:5173`)
4. Backend API available at `http://localhost:8000`
5. API documentation at `http://localhost:8000/docs` (Swagger UI)

## Testing & QA

### Backend Testing
- **Agent regression**: `python test_insta_agent.py` loads `agent_input_sample.txt` and exercises `insta_marketing_expert`.
- **End-to-end Instagram report**: `python test_get_insta_report.py daddyfoody` (writes timestamped JSON with timing + agent outputs). Use mock mode or throttle accounts to respect API quotas.
- **Basic search smoke**: `python test.py` currently demonstrates the Google Custom Search wrapper.
- Consider adding `pytest`-style suites for new modules; rely on `MOCK_DATA=1` to avoid external calls in CI.

### Frontend Testing
- **Type checking**: `npm run build` in `fyuze-frontend/` runs TypeScript compiler
- **Linting**: `npm run lint` checks code quality with ESLint
- **Unit tests**: Testing infrastructure setup with Vitest (`@testing-library/react`, `@testing-library/jest-dom`, `jsdom`)
- **Manual testing checklist**:
  - Authentication flow (signup, login, magic link, email verification, password reset)
  - Chat interface (message sending, creator card display, conversation switching)
  - Creator dashboard (filtering, searching, pagination, platform switching)
  - Creator profile (data display, platform detection, post rendering)
  - URL analyzer functionality
  - Theme switching (dark/light mode persistence)
  - Responsive design across devices
  - Navigation and routing
  
### Integration Testing
- Test full user journey: signup → chat query → view creator profile → dashboard search
- Verify platform abstraction with different creator types (Instagram, TikTok)
- Test data flow from backend API → frontend display → navigation state
- Verify Supabase auth integration and database queries
- Test error handling and loading states

## Operations & Monitoring

### Backend Operations
- **Logging**: structured logs land under `logs/` (both info and error files per module). Tail these files or route them to centralized logging when deploying.
- **Mongo footprint**: `collection = database["temp"]` stores influencer payload stacks; clean up periodically to avoid unbounded growth.
- **Supabase sync**: `InfoCrawler` writes crawled profiles back via `save_creators_parallel`; monitor Supabase quotas and errors logged as warnings.
- **Debug settings**: both agents currently enable `debug_mode=True`; disable in production to avoid verbose traces and potential information leakage.
- **CORS**: `fastapi_app` allows all origins. Lock this down if exposing the API publicly.

### Frontend Operations
- **Build optimization**: Vite provides code splitting, lazy loading, and optimized production builds
- **Performance monitoring**: React Query devtools available in development for cache inspection
- **Error boundaries**: Consider adding React error boundaries for graceful error handling
- **Analytics**: Integration points available for user analytics and tracking
- **SEO**: Single-page app considerations for search engine optimization
- **Asset optimization**: Static assets served from `public/` or Supabase storage
- **Browser compatibility**: Modern browsers (ES2020+), check caniuse.com for specific features

### Deployment Considerations
- **Backend**: FastAPI on cloud platform (AWS, GCP, Azure) or containerized with Docker
- **Frontend**: 
  - Static hosting: Vercel, Netlify, AWS S3 + CloudFront, GitHub Pages
  - Build output: `fyuze-frontend/dist/` directory contains production build
  - Environment variables: Configure platform-specific env vars (VITE_SUPABASE_URL, etc.)
- **Database**: Supabase hosted service (auth + PostgreSQL)
- **Monitoring**: 
  - Backend: API response times, error rates, external API usage
  - Frontend: Page load times, user interactions, error tracking (Sentry, LogRocket)
- **Scaling**: 
  - Backend: Horizontal scaling with load balancer, async task queue for heavy operations
  - Frontend: CDN distribution, caching strategies, service workers
  - Database: Supabase connection pooling, read replicas if needed

## Known Sensitivities & TODOs

### Backend
- Protected search engine artifacts must exist in `dist/protected/search_engine/__init__.pyc`. Rebuild after repository clean or when onboarding new environments.
- MongoDB, Supabase, Ensemble, Rapid, Apify, Exa, and Groq each enforce quotas; add alerting if you run long-lived workloads.
- JSON backups (`insta_influencers.json`, `tiktok_influencers.json`) are saved to the OS temp directory for short-term fallbacks; helper utilities remove them after use but long-running sessions should monitor disk.
- `InfoCrawler` writes to Supabase in bulk; transient failures trigger sequential retries logged to stdout. Consider background workers or DLQ if you see repeated failures.
- Add authentication/authorization (currently none) before exposing endpoints beyond trusted networks.
- Expand unit/integration coverage beyond manual scripts to prevent regressions when altering agents or core services.

### Frontend
- **Authentication**: Email verification required for new signups; magic link and password auth both supported
- **Platform extensibility**: New platforms can be added by creating adapter + config (see `fyuze-frontend/PLATFORM_SYSTEM_GUIDE.md`)
- **Data source compatibility**: Platform abstraction handles AI search, database queries, and direct API responses
- **Type safety**: Comprehensive TypeScript coverage, but runtime validation should be added for external data
- **State persistence**: Chat conversations stored in localStorage; consider backend persistence for multi-device sync
- **Error handling**: Toast notifications for user feedback; consider more granular error boundaries
- **Performance**: Lazy loading for heavy components (dashboard, profile pages); consider virtual scrolling for large lists
- **Accessibility**: Basic ARIA support; needs comprehensive audit and keyboard navigation improvements
- **Mobile optimization**: Responsive design implemented; test across various devices and screen sizes
- **Real-time features**: Supabase real-time subscriptions available but not fully utilized
- **Offline support**: No offline mode; consider service workers and local caching
- **Security**: 
  - XSS protection via React's default escaping
  - CSRF protection needed if adding forms with state-changing operations
  - Rate limiting should be implemented on backend API endpoints
  - Supabase RLS (Row Level Security) policies should be reviewed and strengthened

## Handover Checklist

### Backend
- ✅ Verify `.env` contains all API keys listed above and Playwright browsers are installed (auto-handled in Docker).
- ✅ Ensure MongoDB and Supabase connectivity before running influencer searches; otherwise the agent will fall back to slower re-crawls.
- ✅ Rebuild the protected search engine if the repo was freshly cloned or `src/modules/search_engine` changed.
- ✅ Decide whether to run with `MOCK_DATA=1` (development/demo) or real data (ensure quota headroom).
- ✅ Review `fyuze_agent` prompt/behaviour if marketing strategy or compliance requirements change.
- ✅ Turn off `debug_mode` and restrict CORS before productionizing.

### Frontend
- ✅ Verify `fyuze-frontend/.env` contains Supabase credentials (URL and anon key).
- ✅ Ensure backend API is running and `VITE_API_BASE_URL` points to correct endpoint.
- ✅ Test authentication flow end-to-end (signup, email verification, login, password reset).
- ✅ Verify platform abstraction works with sample Instagram and TikTok data.
- ✅ Test responsive design on mobile, tablet, and desktop viewports.
- ✅ Review Supabase RLS policies before going to production.
- ✅ Build production bundle (`npm run build`) and verify no TypeScript errors.
- ✅ Configure deployment platform (Vercel/Netlify/etc.) with environment variables.
- ✅ Set up error tracking (Sentry, LogRocket) and analytics if needed.
- ✅ Review and update CORS settings on backend to match frontend domain.

### Documentation
- ✅ Review `fyuze-frontend/README.md` for frontend architecture details
- ✅ Check `fyuze-frontend/PLATFORM_SYSTEM_GUIDE.md` for adding new platforms
- ✅ See `fyuze-frontend/THEME_CONTEXT_GUIDE.md` for theming system
- ✅ Reference `fyuze-frontend/DATA_FLOW_VERIFICATION.md` for data flow understanding
- ✅ Consult `docs/DEPLOYMENT_TOPOLOGY.md` and `docs/MONGODB_SETUP_GUIDE.md` for infrastructure

For deeper dives, inspect the source files referenced throughout this overview—each module is heavily documented and designed for composition.
