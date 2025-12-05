# DailyMenu - Epic Breakdown

**Author:** BMad
**Date:** 2025-11-29
**Project Level:** BMad Method
**Target Scale:** Large

---

## Overview

This document provides the complete epic and story breakdown for DailyMenu, decomposing the requirements from the [PRD](./PRD.md) into implementable stories.

**Living Document Notice:** This is the initial version. It will be updated after UX Design and Architecture workflows add interaction and technical details to stories.

### Epic Structure (proposed sequencing)

1) **Foundation & Seeded Library** — Create SwiftUI app shell, navigation, seeded 100+ activity library, local/offline store, warm tone surface; sets feature flags and guardrails. *(Prereqs for all epics.)*
2) **Contextual Discovery & Suggestion Cards** — Time/energy/context selection, 1–3 cards, micro-steps, new-suggestion refresh without repeats, fast perceived response, warm/non-judgmental copy. *(FR1–FR7, FR21–FR22.)*
3) **Personalization & Library Management** — Favorites, hide/ban, preferences (outside/driving/partner-kids), categories, smarter rotation across sessions. *(FR8–FR13, FR21.)*
4) **Gentle Reminders & Re-engagement** — Opt-in reminder window(s), warm copy, deep links into suggestion flow. *(FR17–FR18, FR21–FR22.)*
5) **Progress & Reflection** — “I did this” logging and simple history (growth: 7–30 days grouped by day). *(FR14–FR15.)*
6) **Resilience & Data Control** — Offline-first behavior, sync integrity if enabled, data reset for favorites/history/preferences, reliability/performance hardening. *(FR16, FR19–FR20, FR21–FR22.)*

**Rationale**
- Delivers user-visible value early (suggestions in Epic 2) while grounding with a usable library (Epics 1–3).
- Keeps tone/warmth baked into user-facing epics (2, 3, 4) and resilience in Epic 6 to protect trust.
- Sequencing minimizes rework: foundation → core flow → personalization → reminders → history → reliability hardening.

## Workflow Mode

- Mode: CREATE (new project; no prior epics to continue)
- Rationale: Starting fresh from PRD with current context

## Available Context

- ✅ PRD: docs/prd.md
- ✅ Architecture: docs/bmm-architecture-2025-11-29.md
- ⚠️ UX Design: docs/ux-design-specification.md (placeholder content; no detailed flows yet)
- ⚪ Product brief: Not provided
- ⚪ Domain brief: Not provided

---

## Functional Requirements Inventory

**Functional Requirements**
- FR1: Users can select a time window (5–10, 15–30, 30+ minutes) on launch.
- FR2: Users can select an energy level (Low, Okay, Up for something).
- FR3: Users can choose context (Solo / With someone) and the system biases suggestions accordingly.
- FR4: System surfaces 1–3 suggestion cards matching time/energy/context with minimal latency.
- FR5: Users can request a new suggestion; system avoids repeats within the current session.
- FR6: Suggestion cards show title, 1–2 line description, expected time, and actions (“Do this,” “New suggestion,” “Save,” “Hide”).
- FR7: Cards expand to show up to three micro-steps and tag chips (time, energy, context, category).
- FR8: System ships with at least 100 prewritten activities tagged by time, energy, context, category, and repeatability.
- FR9: Categories include Starters (5–10), Mains (15–30), Desserts (30–60), Connection, and Low-Battery.
- FR10: Users can favorite/unfavorite activities; favorites list is accessible and filterable by category.
- FR11: Users can hide activities; hidden items do not appear in future suggestions unless unhidden.
- FR12: System respects user preferences (outside, driving/store, partner-kids relevance) when suggesting.
- FR13: System reduces repetition across sessions unless an activity is favorited or recently completed.
- FR14: Users can mark “I did this,” logging activity ID and timestamp locally.
- FR15: Users can view a simple history of completions (growth: last 7–30 days grouped by day).
- FR16: Users can reset activity data (favorites/history/preferences) from settings.
- FR17: Users can opt in/out of reminders and configure time windows (one window in MVP; two in growth).
- FR18: Reminder text is gentle and actionable and deep-links into the suggestion flow.
- FR19: Core flows (suggestions, favorites, hide list, “I did this” logging) work offline after initial content download.
- FR20: Sync, if implemented, preserves local state integrity when reconnecting.
- FR21: UI and copy avoid productivity or guilt language; celebrate small wins.
- FR22: No streak mechanics, leaderboards, or social pressure in v1.

**Non-Functional & Constraints**
- Performance: home + first suggestion load under 2s after initial content download; suggestion refresh feels ~instant (<1s perceived).
- Accessibility: legible typography, sufficient contrast, large tap targets; supports OS text scaling; WCAG-aware warm copy.
- Platform: Native iOS (SwiftUI, iOS 17), offline-first after seed download; app size kept lean; no payments/reg data.
- Security/Privacy: Minimal PII (preferences, favorites, history); local storage; encrypted transport if sync added.
- Tone: Warm, non-judgmental microcopy; no pressure visuals.

**Scope Boundaries**
- MVP: Core suggestion flow (FR1–7), seeded library (FR8–13), offline operation (FR19), single reminder window (FR17), data reset (FR16), warm tone (FR21–22).
- Growth (post-MVP): History depth (FR15 growth window), smarter rotation (FR13), two reminder windows (FR17 growth), weekly recap/trends (per PRD growth note), improved suggestion smarts.
- Vision (future): Adaptive suggestions, micro-ritual packs, sharing completions with friends, calendar/wearable signals, web companion.

**Users & Goals**
- Primary: Mobile users wanting quick, low-effort micro-rituals; choose time/energy/context and get 1–3 ready-to-do suggestions fast.
- Goals: Replace doomscrolling with attainable joy; keep experience warm, guilt-free, and offline-capable; revisit favorites and hide weak suggestions; receive gentle reminders without pressure.

---

## FR Coverage Map

**FR-to-Epic Mapping**
- FR1 (time window selection) → Epic 2
- FR2 (energy selection) → Epic 2
- FR3 (context selection) → Epic 2
- FR4 (1–3 matched suggestion cards, fast) → Epic 2
- FR5 (new suggestion, no repeats in session) → Epic 2
- FR6 (card fields + actions) → Epic 2
- FR7 (card expand with micro-steps + tags) → Epic 2
- FR8 (100+ seeded activities with tags) → Epics 1, 3
- FR9 (menu categories Starters/Mains/Desserts/Connection/Low-Battery) → Epics 1, 3
- FR10 (favorites list/filter) → Epic 3
- FR11 (hide/ban list) → Epic 3
- FR12 (preferences: outside/driving/partner-kids) → Epic 3
- FR13 (reduced repetition across sessions) → Epic 3
- FR14 (“I did this” logging) → Epic 5
- FR15 (history view, growth depth) → Epic 5
- FR16 (data reset) → Epic 6
- FR17 (opt-in reminders, windows) → Epic 4
- FR18 (warm reminder copy + deep links) → Epic 4
- FR19 (offline flows post-seed) → Epic 6
- FR20 (sync preserves state) → Epic 6
- FR21 (warm, non-guilt tone) → Epics 2, 3, 4, 6
- FR22 (no streaks/leaderboards/social pressure) → Epics 2, 4, 6

**Coverage Check**
- All FRs mapped; tone/safety explicitly attached to user-facing epics.
- Dependencies flow: Epic 1 → 2/3 → 4 → 5 → 6; Epic 6 hardens reliability after core value is live.

---

## Epic 1: Foundation & Seeded Library

Goal: Ship a SwiftUI app shell with seeded activity content, local/offline storage, feature flags, and warm tone baselines to enable all user-facing flows.

### Story 1.1: App project setup and scaffolding
As a developer,
I want a SwiftUI iOS app project with core folders, build settings, and dependencies,
So that all subsequent feature work sits on a clean, consistent foundation.
**Acceptance Criteria:**
- **Given** a clean repo
  **When** I open the project
  **Then** I see SwiftUI lifecycle, target iOS 17, and feature-first folder structure as per architecture doc.
- **And** shared utilities, theming constants, and feature flag stubs are present.
- **And** build succeeds in Debug/Release without warnings.
**Prerequisites:** None
**Technical Notes:** Create SwiftUI App entry; enable Push/Background modes and App Groups (future widgets/shares); set min iOS 17; align folder layout per architecture doc (App, Core/Data, Core/AI, Core/Network, Features/*); add feature flag struct; include warm tone copy constants; set os_log categories; keep dependencies via SPM.

### Story 1.2: Data model and persistence setup
As a developer,
I want Core Data entities and a store configured for activities, tags, prefs, favorites, history,
So that the app can persist offline-first state.
**Acceptance Criteria:**
- **Given** the app launches
  **When** the store initializes
  **Then** entities exist for Activity, Tag, UserPrefs, Favorite, HistoryEntry with attributes per architecture doc.
- **And** background saves are enabled; migrations are lightweight; unit test proves create/read/write.
**Prerequisites:** 1.1
**Technical Notes:** Use NSPersistentContainer (CloudKit disabled, local store); model Activity/Tag/UserPrefs/Favorite/HistoryEntry/Submission; include schema JSON for seed ingest; add type-safe fetchers; ensure background saves and lightweight migration.

### Story 1.3: Seeded activity library ingest (100+ items)
As a user,
I want a preloaded set of 100+ tagged activities,
So that suggestions work instantly without network.
**Acceptance Criteria:**
- **Given** first launch
  **When** the app initializes
  **Then** the seed JSON is parsed and stored locally with tags for time, energy, context, category, repeatability.
- **And** categories cover Starters/Mains/Desserts/Connection/Low-Battery.
- **And** a smoke test can query 3 random activities with tags present.
**Prerequisites:** 1.2
**Technical Notes:** Bundle seed JSON under Resources/Seed; idempotent ingest; guard against duplicates; log failures via os_log; ensure size stays lean; keep tag coverage aligned to categories.

### Story 1.4: Tone and UX foundations
As a user,
I want the app tone to feel warm and non-judgmental from the first screens,
So that I feel invited rather than pressured.
**Acceptance Criteria:**
- **Given** onboarding/empty states
  **When** copy renders
  **Then** no streak/guilt language appears; supportive microcopy is used.
- **And** typography and colors meet contrast guidelines; tap targets are large.
**Prerequisites:** 1.1
**Technical Notes:** Align with architecture UX principles; add base theme, spacing, haptics optional; prepare accessibility defaults; set typography/contrast tokens consistent with iOS 17 defaults.

### Story 1.5: Feature flags and guardrails
As a developer,
I want feature flags and safety guardrails,
So that experimental online features (LLM, sync) can be toggled safely.
**Acceptance Criteria:**
- **Given** app settings/remote config defaults
  **When** flags are toggled
  **Then** AI/cloud paths stay off by default and require explicit opt-in.
- **And** code paths are stubbed without crashing when disabled.
**Prerequisites:** 1.1, 1.2
**Technical Notes:** Flag struct; defaults off for cloud LLM/sync/submissions; guard network calls behind flags; log flag state; keep backend base URL/config versioned; store tokens in Keychain when introduced.

### Story 1.6: Offline cache bootstrap
As a user,
I want the app to work after initial load without network,
So that I can get suggestions anywhere.
**Acceptance Criteria:**
- **Given** first run completes
  **When** device is offline
  **Then** seed data, preferences, favorites, hide list, and suggestions still function.
- **And** a status indicator shows offline mode without blocking usage.
**Prerequisites:** 1.3
**Technical Notes:** Pre-warm caches; reachability check; graceful degradation messaging; avoid blocking spinners; keep offline mode using local Core Data; queue outbound tasks for later.

---

## Epic 2: Contextual Discovery & Suggestion Cards (FR1–FR7, FR21–FR22)

Goal: Let users pick time/energy/context and instantly see 1–3 warm, non-repetitive suggestion cards with micro-steps and tags.

### Story 2.1: Time selection (FR1)
As a user,
I want to choose a time window (5–10, 15–30, 30+),
So that suggestions match the time I have.
**Acceptance Criteria:**
- **Given** the home screen
  **When** I tap a time option
  **Then** the selection is visibly active and stored for the session.
- **And** options are one-tap, accessible, and reachable via VoiceOver.
**Prerequisites:** 1.4
**Technical Notes:** SwiftUI segmented chips; persist selection in session state; haptic tap feedback.

### Story 2.2: Energy selection (FR2)
As a user,
I want to choose my energy level (Low, Okay, Up for something),
So that suggestions fit my current energy.
**Acceptance Criteria:**
- **Given** the home screen
  **When** I pick an energy level
  **Then** it is active and combined with time for filtering.
- **And** copy is warm (no shame language); accessible labels present.
**Prerequisites:** 2.1
**Technical Notes:** Chips with semantic colors; state stored with time selection; default to low friction choice.

### Story 2.3: Context selection (FR3)
As a user,
I want to choose Solo/With someone,
So that suggestions bias toward my social context.
**Acceptance Criteria:**
- **Given** the selection area
  **When** I choose Solo/With someone
  **Then** the choice is sticky for the session and influences suggestion ranking.
**Prerequisites:** 2.2
**Technical Notes:** Toggle buttons; feed context into query; allow clear selection.

### Story 2.4: Suggestion engine v1 (1–3 cards, fast) (FR4)
As a user,
I want 1–3 matching suggestion cards to load quickly,
So that I can act immediately.
**Acceptance Criteria:**
- **Given** I selected time/energy/context
  **When** I tap “Show suggestions”
  **Then** 1–3 cards render within target perceived speed with titles, descriptions, time tag.
- **And** at least one suggestion always appears if the library has matches; loading state is warm and non-judgmental.
**Prerequisites:** 2.3, 1.3
**Technical Notes:** Local query over seeded store; simple ranking; prefetch cards; instrument load time; avoid blocking on network; optional Core ML/local generator behind flag with fallback to cached feed; cloud LLM path only via backend proxy and user consent (flagged).

### Story 2.5: New suggestion without repeats in-session (FR5)
As a user,
I want to refresh suggestions without repeats in the same session,
So that I don’t see the same card over and over.
**Acceptance Criteria:**
- **Given** suggestions are shown
  **When** I tap “New suggestion”
  **Then** the cards rotate to unseen items until the pool is exhausted, then reset gracefully.
- **And** a brief toast explains when the pool resets; state persists until app quit.
**Prerequisites:** 2.4
**Technical Notes:** Track session IDs; in-memory seen set; reshuffle on pool exhaustion; reuse local data.

### Story 2.6: Suggestion card presentation (fields + actions) (FR6)
As a user,
I want each card to show key info and actions,
So that I understand and can act quickly.
**Acceptance Criteria:**
- **Given** cards are visible
  **When** I view a card
  **Then** I see title, 1–2 line description, expected time, and actions: Do this, New suggestion, Save, Hide.
- **And** buttons are large, warm copy; no streaks or guilt.
**Prerequisites:** 2.4
**Technical Notes:** SwiftUI cards; action handlers wired; safe haptics; accessibility labels; respects theme; keep card layout aligned to architecture UI stack (SwiftUI + async/await).

### Story 2.7: Card expand with micro-steps and tags (FR7)
As a user,
I want to expand a card to see micro-steps and tags,
So that I know what to do and why it fits me.
**Acceptance Criteria:**
- **Given** a card
  **When** I expand it
  **Then** I see up to three micro-steps and chips for time, energy, context, category.
- **And** collapse/expand is smooth; state persists per card during session.
**Prerequisites:** 2.6
**Technical Notes:** Disclosure pattern; animation at 60fps; dynamic type support; chips reuse theme tokens.

### Story 2.8: Tone and safety guardrails in suggestions (FR21–FR22)
As a user,
I want suggestions and UI copy to stay warm and non-judgmental,
So that I feel encouraged, not pressured.
**Acceptance Criteria:**
- **Given** any suggestion state
  **When** I read titles, descriptions, and actions
  **Then** there is no streak/leaderboard language, and messages are supportive.
- **And** empty/error states avoid shame; success states celebrate lightly (“Nice, that counts.”).
**Prerequisites:** 2.6
**Technical Notes:** Copy review; lint strings; include accessibility for tone; QA against tone checklist.

---

## Epic 3: Personalization & Library Management (FR8–FR13, FR21)

Goal: Let users shape the library via favorites, hide list, preferences, categories, and smarter rotation.

### Story 3.1: Favorites save and list (FR10)
As a user,
I want to favorite/unfavorite activities and view them,
So that I can return to what I like.
**Acceptance Criteria:**
- **Given** a suggestion card
  **When** I tap Save
  **Then** the item is added to Favorites and reflected in the favorites list and card state.
- **And** the favorites list is filterable by category and accessible offline.
**Prerequisites:** 2.6
**Technical Notes:** Persist Favorite entity in Core Data; toggle UI state; list view with filters; sync-ready model; store timestamps for future rotation/sync.

### Story 3.2: Hide/ban list (FR11)
As a user,
I want to hide activities,
So that unwanted items stop appearing.
**Acceptance Criteria:**
- **Given** a suggestion
  **When** I tap Hide
  **Then** it disappears and is excluded from future suggestions until unhidden.
- **And** a hidden list exists to restore items.
**Prerequisites:** 2.5
**Technical Notes:** Hidden flag per activity; exclusion in queries; undo snack; manage pool size; persist to Core Data for offline fidelity.

### Story 3.3: Preferences for context fit (FR12)
As a user,
I want to set preferences (outside, driving/store, partner-kids relevance),
So that suggestions match my constraints.
**Acceptance Criteria:**
- **Given** settings/preferences
  **When** I toggle options
  **Then** suggestion ranking and filtering respect them immediately.
- **And** prefs persist across sessions and offline.
**Prerequisites:** 2.3, 1.2
**Technical Notes:** Prefs model; include in query predicates; defaults safe; accessible controls; persist in Core Data; expose via Settings; ready for sync when flag enabled.

### Story 3.4: Category navigation and filters (FR8–FR9)
As a user,
I want to browse by menu categories,
So that I can explore activities that fit my mood.
**Acceptance Criteria:**
- **Given** the library or favorites
  **When** I filter by Starters/Mains/Desserts/Connection/Low-Battery
  **Then** lists/cards show only matching items with tag chips intact.
**Prerequisites:** 3.1
**Technical Notes:** Filter UI; reuse chips; ensure data tagged correctly from seed; store category counts for QA.

### Story 3.5: Session and cross-session rotation (FR13)
As a user,
I want reduced repetition across days unless I favorited or recently completed an item,
So that variety stays high.
**Acceptance Criteria:**
- **Given** prior sessions
  **When** I request suggestions on a new day
  **Then** recently shown items are deprioritized unless favorited.
- **And** favorited items can still appear with gentle weighting; hidden items never appear.
**Prerequisites:** 2.5, 3.2
**Technical Notes:** Simple decay scoring using last-seen timestamps; store session metadata in Core Data; deterministic fallback; reset logic per session; optional feed weighting if cloud feed enabled later.

### Story 3.6: Library integrity and tagging QA (FR8–FR9)
As a developer,
I want validation for seed tags and categories,
So that suggestions remain consistent.
**Acceptance Criteria:**
- **Given** the seed and any updates
  **When** validation runs
  **Then** all activities have required tags (time, energy, context, category, repeatability) and category counts meet targets.
**Prerequisites:** 1.3
**Technical Notes:** QA script/test; log missing tags; prevent bad data ingest; integrate into CI; validate against architecture entity schema.

---

## Epic 4: Gentle Reminders & Re-engagement (FR17–FR18, FR21–FR22)

Goal: Offer opt-in, warm reminders that deep-link into the suggestion flow.

### Story 4.1: Notification permission flow with warm copy (FR17, FR21)
As a user,
I want a gentle prompt to opt in to reminders,
So that I can choose re-engagement without pressure.
**Acceptance Criteria:**
- **Given** the app after initial use
  **When** I see the reminder prompt
  **Then** copy is warm, optional, and explains value; system permission is requested only after intent.
- **And** declining keeps the app usable; settings allow revisiting.
**Prerequisites:** 1.4
**Technical Notes:** Two-step ask; UNUserNotificationCenter; no dark patterns; record choice; copy vetted for warm tone; defer system prompt until intent.

### Story 4.2: Reminder window scheduling (single window MVP) (FR17)
As a user,
I want to set one reminder window,
So that I get a gentle nudge at a good time.
**Acceptance Criteria:**
- **Given** I opted in
  **When** I pick a window
  **Then** a local notification schedules in that window with jitter to avoid sameness.
- **And** turning it off cancels scheduled notifications.
**Prerequisites:** 4.1
**Technical Notes:** BackgroundTasks for scheduling; handle time zones; persistence in prefs; jitter send times; allow cancel/update; remote push path off by default.

### Story 4.3: Deep link into suggestion flow (FR18)
As a user,
I want reminder taps to open directly to fresh suggestions,
So that I can act immediately.
**Acceptance Criteria:**
- **Given** a reminder fires
  **When** I tap it
  **Then** the app opens to the suggestion screen with selections applied or sensible defaults.
- **And** if offline, it still shows cached suggestions.
**Prerequisites:** 2.4, 4.2
**Technical Notes:** Notification payload with context; handle cold/warm starts; respect offline cache; wire deep links via scene delegate routing.

### Story 4.4: Warm reminder templates (FR18, FR21–FR22)
As a user,
I want reminder text that feels friendly and non-judgmental,
So that I feel invited rather than nudged.
**Acceptance Criteria:**
- **Given** reminder templates
  **When** they rotate
  **Then** no streak/pressure language appears; copy mentions time/energy gently.
**Prerequisites:** 4.2
**Technical Notes:** Template list; localized-ready; A/B via flags if desired; tone QA; keep strings in localization bundle.

### Story 4.5: Growth-ready second window toggle (FR17 growth)
As a planner,
I want the structure to add a second reminder window later,
So that growth scope is straightforward.
**Acceptance Criteria:**
- **Given** flags
  **When** second-window flag is enabled
  **Then** UI and scheduling support two windows with independent times.
**Prerequisites:** 4.2
**Technical Notes:** Gate behind flag; reuse scheduling logic; keep UX simple.

---

## Epic 5: Progress & Reflection (FR14–FR15)

Goal: Let users mark completions and review a simple history to reinforce positive behavior.

### Story 5.1: “I did this” logging (FR14)
As a user,
I want to mark an activity as done,
So that I can feel progress and keep light history.
**Acceptance Criteria:**
- **Given** a suggestion or favorite
  **When** I tap “I did this”
  **Then** the activity ID and timestamp are stored locally and acknowledged with warm feedback.
- **And** logging works offline.
**Prerequisites:** 2.6, 1.2
**Technical Notes:** HistoryEntry entity; debounce taps; gentle toast; analytics-ready (local); prep for optional export with consent via backend proxy.

### Story 5.2: Basic history view (FR15 MVP)
As a user,
I want to see a simple list of my recent completions,
So that I can reflect on what I’ve done.
**Acceptance Criteria:**
- **Given** I have logged completions
  **When** I open History
  **Then** I see recent entries with titles, timestamps, and context tags.
- **And** empty state is warm; sorting is by recency.
**Prerequisites:** 5.1
**Technical Notes:** SwiftUI list; fetch from HistoryEntry; offline support; guard performance with batching/paging.

### Story 5.3: Growth history depth (7–30 days grouping) (FR15 growth)
As a user,
I want grouped history (7–30 days) by day,
So that I can review patterns over time.
**Acceptance Criteria:**
- **Given** growth mode enabled
  **When** I open History
  **Then** entries are grouped by day across the chosen window with counts per day.
**Prerequisites:** 5.2
**Technical Notes:** Flag-gated; grouping by date; performance with paging if needed; ready for sync merge if enabled.

---

## Epic 6: Resilience & Data Control (FR16, FR19–FR20, FR21–FR22)

Goal: Ensure offline reliability, safe resets, and integrity if sync is introduced.

### Story 6.1: Data reset controls (FR16)
As a user,
I want to reset favorites/history/preferences,
So that I can start fresh at any time.
**Acceptance Criteria:**
- **Given** settings
  **When** I confirm a reset
  **Then** favorites, history, and prefs are cleared and seed data is reloaded.
- **And** action is double-confirmed and undo is offered briefly.
**Prerequisites:** 3.1, 5.1
**Technical Notes:** Clear Core Data store except seed; secure wipe of Keychain tokens; warm messaging; re-run seed ingest; keep flags reset to defaults.

### Story 6.2: Offline resilience and degradation (FR19)
As a user,
I want the app to behave gracefully when offline,
So that I can still use suggestions and lists.
**Acceptance Criteria:**
- **Given** no network
  **When** I use the app
  **Then** core flows (suggestions, favorites, hide, history) work from local data and show offline status subtly.
- **And** actions that need network are deferred with clear messaging.
**Prerequisites:** 1.6, 2.4
**Technical Notes:** Reachability checks; queue network tasks; cached assets; log offline events; ensure local store is source of truth when offline.

### Story 6.3: Sync integrity safeguards (FR20)
As a developer,
I want sync-ready guards,
So that if sync is enabled later, local state remains consistent.
**Acceptance Criteria:**
- **Given** sync flag off by default
  **When** it is enabled
  **Then** merge logic preserves local favorites/history/hide with conflict resolution rules.
- **And** tests cover out-of-order updates.
**Prerequisites:** 3.1, 5.1
**Technical Notes:** Versioned records; simple ETag check; conflict policy: local wins unless newer server; audit trail for merges; retry/backoff; keep sync flag off by default.

### Story 6.4: Performance and stability hardening
As a developer,
I want to ensure fast loads and smooth interactions,
So that the experience stays instant and calm.
**Acceptance Criteria:**
- **Given** standard devices
  **When** navigating home and loading suggestions
  **Then** launch-to-suggestions stays within target; list scrolling is smooth; no crashes in soak test.
**Prerequisites:** 2.4
**Technical Notes:** Instrument metrics (os_log, signposts); fix hot paths; memory profiling; lightweight images; soak tests on target devices.

### Story 6.5: Accessibility and copy audit (FR21–FR22)
As a user,
I want the app to be accessible and warm,
So that it welcomes all users without pressure.
**Acceptance Criteria:**
- **Given** the UI and copy
  **When** audited
  **Then** it passes contrast/tap target checks and contains no streak/leaderboard language.
- **And** VoiceOver reads controls meaningfully; dynamic type respected.
**Prerequisites:** 2.8
**Technical Notes:** WCAG 2.1 AA checks; accessibility labels; string lint for tone.

---

## FR Coverage Matrix

| FR | Epic.Story coverage |
| -- | ------------------- |
| FR1 | 2.1 |
| FR2 | 2.2 |
| FR3 | 2.3 |
| FR4 | 2.4 |
| FR5 | 2.5 |
| FR6 | 2.6 |
| FR7 | 2.7 |
| FR8 | 1.3, 3.6 |
| FR9 | 1.3, 3.4, 3.6 |
| FR10 | 3.1 |
| FR11 | 3.2 |
| FR12 | 3.3 |
| FR13 | 3.5 |
| FR14 | 5.1 |
| FR15 | 5.2, 5.3 |
| FR16 | 6.1 |
| FR17 | 4.1, 4.2, 4.5 |
| FR18 | 4.3, 4.4 |
| FR19 | 1.6, 6.2 |
| FR20 | 6.3 |
| FR21 | 1.4, 2.8, 3.1, 4.1, 4.4, 6.5 |
| FR22 | 2.8, 4.4, 6.5 |

---

## Summary

DailyMenu is decomposed into 6 epics that deliver user value incrementally: foundation and seed content, contextual suggestions, personalization, gentle reminders, reflection, and resilience. All FRs map to specific stories, with tone/safety baked into user-facing flows and reliability handled in the final epic. The structure supports offline-first usage from day one, avoids streaks/pressure, and leaves room for growth features (extra reminders, deeper history, smarter rotation, sync) behind flags.

---

_For implementation: Use the `create-story` workflow to generate individual story implementation plans from this epic breakdown._

_This document will be updated after UX Design and Architecture workflows to incorporate interaction details and technical decisions._
