# Architecture – DailyMenu

## Executive Summary

DailyMenu is an iOS-only, online-first SwiftUI app that serves ready-to-use micro-ritual suggestions. Architecture centers on a hybrid AI path: fast on-device generation (Core ML) plus optional cloud LLM integration (e.g., OpenAI via backend proxy) with strict user consent and privacy guardrails. A lightweight backend accepts public user submissions, runs moderation/deduplication, and distributes approved activities. The client ships with a seeded library, caches content for resilience, and syncs preferences, favorites, history, and submissions when online.

## Project Initialization

- Create an Xcode “App” project with SwiftUI lifecycle (min iOS 17).  
- Enable capabilities: Push Notifications, Background Modes (fetch/processing), App Groups (future widgets/shares).  
- Add bundled activity seed JSON (100+). Initialize local store on first launch.  
- Add feature flags for: cloud LLM use, sync, public submissions, content packs.  
- Set up package/dependency versions in Xcode project (see Decision Summary).

## Decision Summary

| Category | Decision | Version | Affects FR Categories | Rationale |
| -------- | -------- | ------- | --------------------- | --------- |
| UI Stack | SwiftUI + async/await; SF Symbols; haptics optional | Swift 5.9 / iOS 17 SDK | Discovery, Library, Logging, Settings | Native, fast, modern APIs |
| State/Data | Core Data with NSPersistentCloudKitContainer-disabled (local only) + JSON seed; background saves | iOS 17 Core Data | Library, Suggestions, History | Reliable local store; easy caching |
| Networking | URLSession + async/await; REST/JSON; retry/backoff; reachability-aware | Foundation (iOS 17) | Suggestions, Submissions, Sync | Simple, testable, first-party |
| AI (on-device) | Core ML text generation model packaged or downloaded; prompt templates; safety filters local | Core ML (iOS 17) | Suggestions, Creation | Low-latency, private generation |
| AI (cloud optional) | Backend-proxied ChatGPT/LLM; user-consent gate; rate-limit and filter | API rev. as deployed | Suggestions, Creation | Richer ideas; keeps keys off-device |
| Notifications | UNUserNotificationCenter local; optional remote push for new packs/recaps; BackgroundTasks for scheduling | iOS 17 | Notifications, Engagement | Gentle reminders without streaks |
| Backend | Single REST service for submissions/moderation/feed; Postgres + queue (e.g., Sidekiq/Oban/Queue) | Postgres 15 | Submissions, Feed | Simple, durable, moderated public repo |
| Auth/Identity | Anonymous device ID + optional account; tokens in Keychain; submission writes require server-issued token | iOS Keychain | Submissions, Settings | Minimal PII; protects public repo |
| Logging/Analytics | Structured client logs (os_log) local; optional event export with user consent; no PII | iOS 17 os_log | All | Debuggable without privacy risk |
| Deployment | Client via App Store; backend containerized (e.g., Fly.io/Render) with HTTPS/TLS; CDN for packs/model | N/A | All online features | Simple ops, global edge for assets |

## Project Structure

```
DailyMenu/
  App/
    DailyMenuApp.swift
    AppDelegate.swift (notifications)
  Core/
    Data/
      Models/Activity.swift, Tag.swift, UserPrefs.swift, HistoryEntry.swift, Submission.swift
      Persistence/Store.swift (Core Data stack), SeedLoader.swift
    Network/
      APIClient.swift
      Endpoints.swift
      AuthTokenStore.swift (Keychain)
      Reachability.swift
    AI/
      PromptBuilder.swift
      LocalGenerator.swift (Core ML)
      CloudLLMService.swift (backend proxied)
      SafetyFilters.swift
    Notifications/
      ReminderScheduler.swift
    FeatureFlags/
      Flags.swift
  Features/
    Home/
      HomeView.swift
      FiltersView.swift
    Suggestions/
      SuggestionsView.swift
      SuggestionCardView.swift
      SuggestionViewModel.swift
    ActivityDetail/
      ActivityDetailView.swift
    Favorites/
      FavoritesView.swift
    History/
      HistoryView.swift
    Settings/
      SettingsView.swift
      ReminderSettingsView.swift
      DataResetView.swift
    Submissions/
      SubmitActivityView.swift
      SubmissionStatusView.swift
  Resources/
    Seed/activities.json
    Localization/Base.lproj
  Tests/
    Unit/
    Snapshot/
```

## FR Category to Architecture Mapping

- Content Discovery & Suggestion Flow: Features/Home, Suggestions; Core/AI (Local + Cloud), Core/Network, Core/Data.
- Activity Library & Personalization: Core/Data (Activity, Tag, Prefs), Features/Favorites, Filters in Home.
- Execution & Logging: Features/ActivityDetail, Core/Data (HistoryEntry), Core/Notifications.
- Notifications & Reminders: Core/Notifications, BackgroundTasks integration, Features/Settings.
- Data Handling & Sync: Core/Data, Core/Network; backend feed for submissions/packs.
- Tone & Safety: Core/AI/SafetyFilters, copy in Features views, no streaks baked into UI.

## Technology Stack Details

- Language/Runtime: Swift 5.9+, iOS 17 SDK.
- UI: SwiftUI, SF Symbols, Haptics.
- State/Data: Core Data; JSON seed bundled; lightweight cache; background save.
- Networking: URLSession, REST/JSON, exponential backoff, reachability-aware fetches.
- AI: Core ML text-generation model packaged/downloaded; prompt templates; safety filters. Optional cloud LLM via backend proxy (keeps API keys server-side, applies moderation).
- Notifications: UNUserNotificationCenter; BackgroundTasks for scheduling/local reminders; optional remote push for new packs/recaps.
- Backend (contract): REST endpoints for ideas feed, submissions, moderation status, packs/model manifest. Postgres + queue + CDN for assets/models.

## Integration Points

- App → Backend: REST/JSON over HTTPS for submissions, feed updates, model/pack manifests; auth via bearer from Keychain; rate-limited.
- App → Cloud LLM: Only via backend proxy; user-consented; backend applies moderation and redaction.
- App → Notifications: Local scheduling; optional remote push via APNs.
- Backend → CDN/Object Store: Hosts packs, model files, and sanitized public repo feed.

## Novel Pattern Designs

- Hybrid AI suggestion flow: attempt local Core ML generation first for speed/privacy; fall back to cached feed; optionally enrich with cloud LLM when user opts in and network is good. Safety filters applied pre/post generation. Deterministic seed suggestions remain available.
- Public submissions pipeline: client submits activity with minimal metadata; backend runs moderation/dedup; approved items flow into public feed/packs; client syncs feed incrementally.

## Implementation Patterns

- Naming: REST endpoints plural (`/activities`, `/submissions`); Swift types UpperCamelCase, files match type; Core Data entities singular.
- Organization: Feature-first folders; tests co-located in `Tests/Unit` with `*Tests.swift`; shared utils in Core.
- Error Handling: Use typed domain errors; surface inline messaging with gentle tone; log technical detail to console only.
- Logging: os_log with categories (network, ai, data); no PII in logs; sampling for noisy paths.
- Dates/Time: ISO 8601 UTC for API; store Dates in UTC; display with locale formatting.
- Networking: Idempotent GETs cached; retries with backoff for GET/POST where safe; 401 triggers token refresh; 429 backs off.
- AI: Prompt templates versioned; model selection flag-driven; safety filters strip PII and disallowed content before display.
- Data Reset: One path to clear Core Data store and Keychain tokens; confirmations in Settings.

## Consistency Rules

- Naming Conventions: Lower_snake_case JSON; Swift properties camelCase; Core Data attributes snake_case.
- Code Organization: Feature-first; Core for shared; keep view models slim (business logic in services).
- Error Handling: User-facing copy warm/non-guilt; technical errors never exposed raw.
- Logging Strategy: Structured os_log; include request IDs from backend when available.

## Data Architecture

- Entities: Activity(id, title, description, tags [time, energy, context, category], repeatability, source, moderation_status), UserPrefs(time_options, energy_defaults, context_defaults, flags), Favorite(activity_id, created_at), HistoryEntry(activity_id, completed_at, context_snapshot), Submission(id, payload, status, created_at).
- Storage: Core Data persistent store; Seed JSON ingested on first launch; migrations via lightweight mapping models.
- Caching: Feed cache with ETag/If-None-Match; model manifest cache with version pinning.

## API Contracts (high-level)

- GET /feed?since=etag → 200 {activities:[...], etag}  
- POST /submissions → 202 {submission_id, status:"pending"} (auth token required)  
- GET /submissions/{id} → 200 {status, notes}  
- GET /packs/manifest → 200 {packs:[...], models:[...]}  
- POST /llm/ideas → 200 {ideas:[...]} (backend-proxied to provider; applies moderation)

Request headers: Authorization: Bearer <token>, If-None-Match for feed. Responses include request-id for logging.

## Security Architecture

- Auth: Anonymous device token from backend; optional account later. Tokens in Keychain.
- Privacy: No camera/mic/location; minimal PII. Cloud LLM calls proxied server-side with redaction.
- Transport: HTTPS/TLS everywhere; certificate pinning optional.
- Rate limits: Enforced server-side per device token; client backs off on 429.
- Moderation: Backend filters/blocks unsafe submissions; AI safety filters on client outputs.

## Performance Considerations

- Fast launch: lazy Core Data stack; seed on background queue after first frame.  
- Suggestions: local generator first; cached feed fallback; cloud only when opted-in + on Wi‑Fi/Good network.  
- Caching: ETag-based feed updates; model manifest versioning; in-memory caches for recent cards.  
- Animations: SwiftUI performant defaults; avoid heavy layouts in lists.

## Deployment Architecture

- Client: App Store distribution; feature flags remote-config capable (baked in defaults).
- Backend: Single REST service + Postgres + queue; containerized; CDN for packs/models; APNs for optional push.
- Observability: Backend logs/metrics; client sampled logs; request-id propagation.

## Development Environment

- Xcode 15+, iOS 17 SDK; Swift 5.9+.  
- Dependencies via Swift Package Manager only.  
- Setup commands: open Xcode project; run tests via `xcodebuild -scheme DailyMenu -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 15' test`.

## Architecture Decision Records (key)

- ADR-001: SwiftUI + async/await for UI/state.  
- ADR-002: Core Data local store with seeded JSON; online-first sync for feed/submissions.  
- ADR-003: Hybrid AI (Core ML first, optional cloud LLM via backend proxy with consent).  
- ADR-004: REST/JSON over URLSession; backend handles moderation/dedup for public repo.  
- ADR-005: Anonymous device identity + Keychain tokens; minimal PII.  
- ADR-006: Notifications local-first; optional remote pushes for packs/recaps.  
- ADR-007: Feature-first project structure; typed errors, gentle UX copy.

---

_Generated by BMAD Decision Architecture Workflow v1.0_  
_Date: 2025-11-29_  
_For: BMad_
