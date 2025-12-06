# DailyMenu - Epic Breakdown v2

**Author:** BMad
**Date:** 2025-12-01
**Extends:** Epic Breakdown v1 (Epics 1-6)
**Project Level:** BMad Method
**Target Scale:** Large

---

## Overview

This document provides the epic and story breakdown for DailyMenu v2 enhancements, adding Epics 7-12 to the existing foundation. These epics transform DailyMenu into a personal wellness journey platform with authentication, sync, mood tracking, calendar view, and gamification.

**Living Document Notice:** This is the initial version for v2 features. It will be updated after implementation begins.

### Epic Summary (by number)

| Epic | Name | Stories | Dependencies |
|------|------|---------|--------------|
| 7 | Authentication & Profile | 5 | None |
| 8 | iCloud Sync | 5 | Epic 7 |
| 9 | Mood Tracking & Feedback | 5 | None (v1 complete) |
| 10 | Calendar View | 5 | None (v1 complete) |
| 11 | Gamification Core | 5 | Epic 9 (mood bonus) |
| 12 | Stamps, Warmth & Unlockables | 5 | Epic 11 |
| 13 | Pro Mode - Activity Management | 5 | None (v1 complete) |
| 14 | Community Library | 10 | Epics 7, 11, 13 |

---

## Implementation Phases (Optimized for Parallelization)

### Phase 1: Foundation Layer
**Duration**: Sprint 1-2
**Goal**: Enable local enhancements without backend dependencies

```
┌─────────────────────────────────────────────────────────────────┐
│                         PHASE 1                                  │
│                    (Can run in parallel)                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   Developer A              Developer B              Developer C  │
│   ───────────              ───────────              ───────────  │
│                                                                  │
│   Epic 13: Pro Mode        Epic 9: Mood            Epic 10:      │
│   (Activity Mgmt)          Tracking                Calendar View │
│                                                                  │
│   • 13.5 Pro Mode toggle   • 9.1 Before-mood      • 10.1 Month  │
│   • 13.1 Activity editor   • 9.2 After-mood         grid        │
│   • 13.2 Activity creator  • 9.3 Quick feedback   • 10.2 Day    │
│   • 13.3 My Activities     • 9.4 MoodEntry          detail      │
│   • 13.4 Delete w/ undo      entity              • 10.3 Tab     │
│                                                     integration  │
│                                                   • 10.4 Queries │
│                                                   • 10.5 Colors  │
│                                                                  │
│   No dependencies          No dependencies         No deps       │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**Stories in Phase 1**: 15 stories (13.1-13.5, 9.1-9.5, 10.1-10.5)
**Parallelization**: 3 independent tracks

---

### Phase 2: Authentication & Gamification
**Duration**: Sprint 3-4
**Goal**: Add user identity and reward systems

```
┌─────────────────────────────────────────────────────────────────┐
│                         PHASE 2                                  │
│              (Parallel tracks with sync point)                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   Developer A                              Developer B           │
│   ───────────                              ───────────           │
│                                                                  │
│   Epic 7: Authentication                   Epic 11: Gamification │
│                                            Core                  │
│   • 7.1 Sign in with Apple                                       │
│   • 7.2 Keychain + Face ID                 • 11.1 Moments system │
│   • 7.3 Profile page UI                    • 11.2 Seasons levels │
│   • 7.4 Anonymous migration                • 11.3 UserGamification│
│   • 7.5 Credential revocation              • 11.4 GamificationSvc│
│                                            • 11.5 Season-up UI   │
│                                                                  │
│   ────────────────────────────────────────────────────────────  │
│                                                                  │
│         Epic 11 depends on Epic 9 (mood bonus calculation)       │
│         Start 11.1-11.3 immediately, 11.4 after 9.x complete    │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**Stories in Phase 2**: 10 stories (7.1-7.5, 11.1-11.5)
**Parallelization**: 2 independent tracks

---

### Phase 3: Sync & Rewards
**Duration**: Sprint 5-6
**Goal**: Enable cross-device sync and achievement system

```
┌─────────────────────────────────────────────────────────────────┐
│                         PHASE 3                                  │
│              (Parallel tracks, both depend on Phase 2)           │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   Developer A                              Developer B           │
│   ───────────                              ───────────           │
│                                                                  │
│   Epic 8: iCloud Sync                      Epic 12: Stamps &     │
│   (depends on Epic 7)                      Unlockables           │
│                                            (depends on Epic 11)  │
│                                                                  │
│   • 8.1 CloudKit container                 • 12.1 Badge system   │
│   • 8.2 Dual store arch                    • 12.2 Stamp gallery  │
│   • 8.3 Conflict resolution                • 12.3 Warmth gauge   │
│   • 8.4 Migration prompt                   • 12.4 Activity packs │
│   • 8.5 Sync status UI                     • 12.5 Themes         │
│                                                                  │
│   ────────────────────────────────────────────────────────────  │
│                                                                  │
│   Epic 9.5 (Mood Insights) can also be done here if deferred    │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**Stories in Phase 3**: 10 stories (8.1-8.5, 12.1-12.5)
**Parallelization**: 2 independent tracks

---

### Phase 4: Community Platform
**Duration**: Sprint 7-9
**Goal**: Launch community features with Supabase backend

```
┌─────────────────────────────────────────────────────────────────┐
│                         PHASE 4                                  │
│           (Sequential within, parallel between sub-tracks)       │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   Epic 14: Community Library                                     │
│   (depends on Epics 7, 11, 13)                                   │
│                                                                  │
│   Sprint 7:                                                      │
│   ─────────                                                      │
│   Developer A               Developer B                          │
│   • 14.1 Supabase setup     (Backend setup in parallel)         │
│   • 14.2 Browse view        • Supabase project config            │
│                             • Database schema deployment         │
│                             • Edge functions                     │
│                                                                  │
│   Sprint 8:                                                      │
│   ─────────                                                      │
│   Developer A               Developer B                          │
│   • 14.3 Voting             • 14.5 Download to library          │
│   • 14.4 Ratings            • 14.6 Submit to community          │
│                                                                  │
│   Sprint 9:                                                      │
│   ─────────                                                      │
│   Developer A               Developer B                          │
│   • 14.7 Search             • 14.9 Reports                       │
│   • 14.8 Activity packs     • 14.10 Collections                  │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**Stories in Phase 4**: 10 stories (14.1-14.10)
**Parallelization**: 2 tracks within each sprint

---

## Dependency Graph

```
                    ┌─────────────────────────────────────────────┐
                    │              PHASE 1 (Parallel)              │
                    │                                              │
                    │   Epic 13        Epic 9         Epic 10     │
                    │   Pro Mode       Mood           Calendar    │
                    │      │             │               │         │
                    └──────┼─────────────┼───────────────┼─────────┘
                           │             │               │
                           │             ▼               │
                    ┌──────┼─────────────────────────────┼─────────┐
                    │      │      PHASE 2 (Parallel)     │         │
                    │      │                             │         │
                    │   Epic 7 ◄────┐    Epic 11 ◄───────┘         │
                    │   Auth        │    Gamification              │
                    │      │        │         │                    │
                    └──────┼────────┼─────────┼────────────────────┘
                           │        │         │
                           ▼        │         ▼
                    ┌──────────────────────────────────────────────┐
                    │           PHASE 3 (Parallel)                 │
                    │                                              │
                    │        Epic 8              Epic 12           │
                    │        Sync                Stamps            │
                    │           │                   │              │
                    └───────────┼───────────────────┼──────────────┘
                                │                   │
                                ▼                   ▼
                    ┌──────────────────────────────────────────────┐
                    │           PHASE 4 (Community)                │
                    │                                              │
                    │                Epic 14                       │
                    │            Community Library                 │
                    │                                              │
                    └──────────────────────────────────────────────┘
```

---

## Story-Level Parallelization Within Epics

### Epic 7: Authentication
| Story | Can Parallelize With | Notes |
|-------|---------------------|-------|
| 7.1 Sign in with Apple | 7.2 Keychain | Same developer, sequential |
| 7.3 Profile page UI | 7.1, 7.2 | Different layer (UI vs infra) |
| 7.4 Migration | After 7.1 | Needs auth first |
| 7.5 Revocation | After 7.1 | Needs auth first |

### Epic 9: Mood Tracking
| Story | Can Parallelize With | Notes |
|-------|---------------------|-------|
| 9.1 Before-mood | 9.4 MoodEntry entity | UI and data layer parallel |
| 9.2 After-mood | 9.4 MoodEntry entity | UI and data layer parallel |
| 9.3 Quick feedback | 9.1, 9.2 | Independent UI component |
| 9.5 Mood insights | After 9.1-9.4 | Needs data |

### Epic 14: Community Library
| Story | Can Parallelize With | Notes |
|-------|---------------------|-------|
| 14.1 Supabase setup | Backend deployment | Infra parallel |
| 14.2 Browse | 14.5 Download | Read vs write |
| 14.3 Voting | 14.4 Ratings | Both are feedback |
| 14.7 Search | 14.9 Reports | Different features |
| 14.8 Packs | 14.10 Collections | Both are grouping |

---

## Critical Path

The minimum path through all epics:

```
Epic 13.5 (Pro Mode toggle) → Epic 9.1 (Mood) → Epic 11.1 (Moments)
    ↓                              ↓                    ↓
Epic 7.1 (Auth) ──────────────────────────────────────────→ Epic 14.1 (Supabase)
    ↓                                                           ↓
Epic 8.1 (CloudKit) ────────────────────────────────────→ Epic 14.10 (Collections)
```

**Critical path duration**: ~7-8 sprints
**With parallelization**: ~4-5 sprints (40% reduction)

---

## FR Coverage Map (v2)

**FR-to-Epic Mapping**
- FR23 (Sign in with Apple) → Epic 7
- FR24 (Keychain with Face ID) → Epic 7
- FR25 (Profile page) → Epic 7
- FR26 (Credential revocation) → Epic 7
- FR27 (iCloud sync) → Epic 8
- FR28 (Conflict resolution) → Epic 8
- FR29 (Privacy controls) → Epic 8
- FR30 (Before-mood prompt) → Epic 9
- FR31 (After-mood prompt) → Epic 9
- FR32 (Skippable prompts) → Epic 9
- FR33 (Quick feedback) → Epic 9
- FR34 (Feedback-influenced ranking) → Epic 9
- FR35 (Calendar grid) → Epic 10
- FR36 (Day detail view) → Epic 10
- FR37 (Color coding) → Epic 10
- FR38 (Moments points) → Epic 11
- FR39 (Seasons levels) → Epic 11
- FR40 (Stamps badges) → Epic 12
- FR41 (Stamp gallery) → Epic 12
- FR42 (Warmth gauge) → Epic 12
- FR43 (Warmth levels) → Epic 12
- FR44 (Unlockable packs) → Epic 12
- FR45 (Unlockable themes) → Epic 12

---

## Epic 7: Authentication & Profile (FR23-FR26)

Goal: Enable optional Sign in with Apple with Face ID protection, profile page, and graceful credential management.

### Story 7.1: Sign in with Apple integration (FR23)
As a user,
I want to sign in with my Apple ID,
So that my activities can sync across devices.

**Acceptance Criteria:**
- **Given** the sign-in screen
  **When** I tap "Continue with Apple"
  **Then** the Apple authentication sheet appears.
- **And** upon successful auth, a UserProfile entity is created with appleUserIdentifier.
- **And** if auth fails or is cancelled, I remain signed out with clear messaging.
- **And** the flow works without network if cached credentials exist.

**Prerequisites:** Epics 1-6 complete
**Technical Notes:** Use AuthenticationServices framework; ASAuthorizationController; handle both new and returning users; store Apple user ID in Core Data and Keychain.

### Story 7.2: Keychain storage with Face ID protection (FR24)
As a user,
I want my credentials protected by Face ID,
So that my account is secure.

**Acceptance Criteria:**
- **Given** successful Apple sign-in
  **When** credentials are stored
  **Then** they are saved to Keychain with kSecAccessControlBiometryCurrentSet.
- **And** subsequent launches check Keychain silently if Face ID enrolled.
- **And** if biometric fails, prompt for device passcode fallback.
- **And** credentials are cleared on sign-out.

**Prerequisites:** 7.1
**Technical Notes:** Create KeychainManager.swift; use Security framework; handle LAContext for biometric check; test with simulator Face ID triggers.

### Story 7.3: Profile page UI (FR25)
As a user,
I want to view my profile page,
So that I can see my journey stats and manage my account.

**Acceptance Criteria:**
- **Given** I am signed in
  **When** I navigate to Profile
  **Then** I see my display name, "Member since" date, total activities, favorites count, current season.
- **And** I can navigate to Settings, Stamp Gallery, and Sign Out.
- **And** the design matches vintage menu aesthetic with paper texture.
- **And** anonymous users see "Create Account" prompt instead.

**Prerequisites:** 7.1
**Technical Notes:** ProfileView.swift using vintage theme; ProfileViewModel.swift for data binding; fetch stats from Core Data; handle both authenticated and anonymous states.

### Story 7.4: Anonymous to authenticated migration
As an existing user,
I want to sign in without losing my local data,
So that my history is preserved.

**Acceptance Criteria:**
- **Given** I have local activities/favorites
  **When** I sign in for the first time
  **Then** I see a prompt: "Link your journey to your account?"
- **And** if accepted, local data is associated with the new profile.
- **And** if declined, I start fresh (with option to link later).
- **And** no data is duplicated during migration.

**Prerequisites:** 7.1, 7.3
**Technical Notes:** Detect existing local data before auth; migration logic in AuthManager; update HistoryEntry/Favorite entities with profileId; test idempotency.

### Story 7.5: Credential revocation handling (FR26)
As a user,
I want the app to handle credential issues gracefully,
So that I'm not locked out unexpectedly.

**Acceptance Criteria:**
- **Given** my Apple credential is revoked
  **When** the app checks credential state
  **Then** I see a warm prompt to re-authenticate (not an error screen).
- **And** local data remains accessible in read-only mode until re-auth.
- **And** I can continue using the app without signing in if I choose.

**Prerequisites:** 7.1
**Technical Notes:** Use ASAuthorizationAppleIDProvider.getCredentialState; handle .revoked and .notFound; queue sync operations until resolved; warm messaging per tone guidelines.

---

## Epic 8: iCloud Sync (FR27-FR29)

Goal: Enable cross-device sync with CloudKit while respecting privacy controls and handling conflicts gracefully.

### Story 8.1: NSPersistentCloudKitContainer upgrade (FR27)
As a developer,
I want to upgrade to CloudKit-backed Core Data,
So that authenticated users can sync data.

**Acceptance Criteria:**
- **Given** the app launches
  **When** sync is enabled
  **Then** NSPersistentCloudKitContainer manages cloud-synced entities.
- **And** sync happens in background without blocking UI.
- **And** network errors are handled silently with retry logic.
- **And** sync status is available for Settings display.

**Prerequisites:** 7.1
**Technical Notes:** Upgrade Store.swift; configure cloudKitContainerOptions; handle NSPersistentCloudKitContainerEventType notifications; use viewContext for reads, background context for sync.

### Story 8.2: Dual store architecture (FR27, FR29)
As a user,
I want my preferences to stay private,
So that only my activities sync—not my hidden items or category filters.

**Acceptance Criteria:**
- **Given** sync is enabled
  **When** data saves
  **Then** History/Favorites/Gamification save to cloud store.
- **And** UserPrefs/ExcludedCategories save to local-only store.
- **And** entities are assigned to correct store at creation time.
- **And** local-only data never appears in CloudKit dashboard.

**Prerequisites:** 8.1
**Technical Notes:** Configure two persistent stores; use NSPersistentStoreDescription.cloudKitContainerOptions = nil for local store; assign entities via configuration; test with CloudKit dashboard inspection.

### Story 8.3: Sync conflict resolution policies (FR28)
As a user,
I want my data to merge correctly across devices,
So that I don't lose activities or badges.

**Acceptance Criteria:**
- **Given** conflicting changes on two devices
  **When** sync merges
  **Then** HistoryEntry uses server-wins (no duplicate entries).
- **And** Favorite uses last-writer-wins (most recent action prevails).
- **And** UserGamification uses max-value-merge (highest Moments/Season kept).
- **And** Badge uses additive-merge (no duplicate badges, all earned kept).

**Prerequisites:** 8.1
**Technical Notes:** Implement SyncConflictResolver.swift; use NSMergePolicy customization; test with simulated conflicts; log merge decisions for debugging.

### Story 8.4: Migration prompt for existing users
As an existing user,
I want to be invited to sync after updating,
So that I can choose to carry my journey to other devices.

**Acceptance Criteria:**
- **Given** I update and sign in
  **When** I have pre-existing local data
  **Then** I see: "Sync your tiny joys across devices?"
- **And** accepting uploads local data to CloudKit.
- **And** declining keeps data local (sync can be enabled later in Settings).
- **And** the prompt only appears once.

**Prerequisites:** 8.1, 8.2
**Technical Notes:** Detect first sync-enabled launch; migration UI with warm copy; upload via background task; store migration state in UserDefaults; test fresh install vs. upgrade paths.

### Story 8.5: Sync status indicators
As a user,
I want to know if my data is synced,
So that I trust my activities are safe across devices.

**Acceptance Criteria:**
- **Given** Settings > Sync section
  **When** I view sync status
  **Then** I see: "Synced to iCloud" or "Syncing..." or "Offline - will sync when connected".
- **And** last sync timestamp is displayed.
- **And** I can manually trigger sync if desired.
- **And** errors show warm messaging with retry option.

**Prerequisites:** 8.1
**Technical Notes:** Subscribe to NSPersistentCloudKitContainer event notifications; display in SettingsView; store last sync date; handle networkUnavailable gracefully.

---

## Epic 9: Mood Tracking & Feedback (FR30-FR34)

Goal: Add optional before/after mood prompts and quick feedback to enrich the activity journey.

### Story 9.1: Before-mood check-in component (FR30)
As a user,
I want to note how I feel before an activity,
So that I can later see if activities improve my mood.

**Acceptance Criteria:**
- **Given** I tap "I'll have this" on an activity
  **When** the activity flow begins
  **Then** I see a before-mood prompt with Low/Okay/Good options.
- **And** icons are nature-based (plant growth metaphor).
- **And** Skip button is visible and equally weighted.
- **And** selection is stored locally (ready for after-comparison).

**Prerequisites:** Epic 2 (suggestion flow), Epic 5 (history logging)
**Technical Notes:** MoodCheckInView.swift; use @State for flow; icons: 🌱/🌿/🌻 or custom SF Symbols; store in session state until activity completes; accessible labels.

### Story 9.2: After-mood and feedback flow (FR31, FR32)
As a user,
I want to note how I feel after an activity,
So that I can track what lifts my mood.

**Acceptance Criteria:**
- **Given** I mark an activity complete
  **When** the after-mood prompt appears
  **Then** I see Lower/Same/Better options with directional icons.
- **And** Skip is always available.
- **And** if mood improved, a subtle celebration appears.
- **And** mood data saves to MoodEntry entity linked to HistoryEntry.

**Prerequisites:** 9.1
**Technical Notes:** After-mood uses ↓/→/↑ icons; calculate mood delta for bonus moments; MoodEntry relationship to HistoryEntry; warm "Nice, you feel better!" toast.

### Story 9.3: Quick feedback UI (FR33)
As a user,
I want to rate the activity after completion,
So that my preferences improve future suggestions.

**Acceptance Criteria:**
- **Given** after-mood (or skip)
  **When** quick feedback prompt appears
  **Then** I see "How was that?" with Loved it / It was nice / Not for me.
- **And** I can optionally add a note (max 200 chars).
- **And** Skip is available.
- **And** feedback saves to HistoryEntry.feedbackRating/.feedbackNote.

**Prerequisites:** 9.2
**Technical Notes:** QuickFeedbackView.swift; "Not for me" uses wave icon (goodbye, not thumbs-down); optional TextField expands on tap; save immediately to Core Data.

### Story 9.4: MoodEntry Core Data entity
As a developer,
I want a MoodEntry entity,
So that mood data persists and syncs.

**Acceptance Criteria:**
- **Given** mood data is captured
  **When** saved
  **Then** MoodEntry stores: id, historyEntryId, moodBefore, moodAfter, createdAt.
- **And** relationship to HistoryEntry is established.
- **And** entity syncs via CloudKit (with user's mood privacy consent).
- **And** migration handles existing HistoryEntry records without mood.

**Prerequisites:** Epic 1 (data model)
**Technical Notes:** Add MoodEntry to xcdatamodeld; inverse relationship; optional moodBefore/After (for skipped); lightweight migration; test sync behavior.

### Story 9.5: Mood insights visualization (Growth)
As a user,
I want to see patterns in my mood data,
So that I can understand what activities help me most.

**Acceptance Criteria:**
- **Given** I have mood data over time
  **When** I view Mood Insights
  **Then** I see: % of activities that improved mood, most mood-lifting categories, weekly trend.
- **And** empty state invites me to track moods.
- **And** design is warm and non-clinical.

**Prerequisites:** 9.4, sufficient data (10+ entries suggested)
**Technical Notes:** MoodInsightsView.swift; aggregate queries; simple bar/spark visualizations; gated behind feature flag initially; warm copy emphasizes self-compassion.

---

## Epic 10: Calendar View (FR35-FR37)

Goal: Add a calendar view to history for day-by-day activity reflection.

### Story 10.1: Month calendar grid component (FR35)
As a user,
I want to see a month calendar with my activity days marked,
So that I can visualize my journey over time.

**Acceptance Criteria:**
- **Given** the History tab
  **When** I switch to Calendar view
  **Then** I see a month grid with current month displayed.
- **And** days with activities show dots (terracotta).
- **And** days with mood improvement show special indicator (forest/glow).
- **And** days with multiple activities show larger/different dot.
- **And** I can swipe to navigate months.

**Prerequisites:** Epic 5 (history view)
**Technical Notes:** CalendarView.swift; use LazyVGrid with 7 columns; fetch HistoryEntry grouped by day; respect calendar locale; "Today" button returns to current month.

### Story 10.2: Day detail view with activities (FR36)
As a user,
I want to tap a day and see what I did,
So that I can reflect on specific moments.

**Acceptance Criteria:**
- **Given** I tap a day on the calendar
  **When** the day detail appears
  **Then** I see a list of activities with: title, time, mood delta, feedback.
- **And** empty days show nothing (no "No activities" message).
- **And** I can dismiss and return to calendar.
- **And** design matches vintage aesthetic.

**Prerequisites:** 10.1
**Technical Notes:** DayDetailView.swift as sheet; fetch HistoryEntry for selected date; show MoodEntry delta if exists; show feedbackRating icon; ScrollView for multiple activities.

### Story 10.3: History view tab integration
As a user,
I want to toggle between list and calendar views,
So that I can choose my preferred history format.

**Acceptance Criteria:**
- **Given** the History tab
  **When** I view it
  **Then** I see a segmented control: "List" | "Calendar".
- **And** selection persists across sessions.
- **And** both views share the same data source.
- **And** transition between views is smooth.

**Prerequisites:** 10.1, Epic 5
**Technical Notes:** Modify HistoryView.swift; use Picker with segmented style; store preference in UserDefaults; share HistoryViewModel or use @Query.

### Story 10.4: Date range queries
As a developer,
I want efficient date-range queries,
So that calendar loads quickly.

**Acceptance Criteria:**
- **Given** a month view request
  **When** data loads
  **Then** only that month's entries are fetched.
- **And** query uses indexed completedAt field.
- **And** data is grouped by day efficiently.
- **And** month navigation doesn't re-fetch visible data.

**Prerequisites:** 10.1
**Technical Notes:** Create extension on Calendar for startOfMonth/endOfMonth; use NSPredicate with date range; Dictionary<Date, [HistoryEntryEntity]> result; cache fetched months.

### Story 10.5: Color coding for mood and volume (FR37)
As a user,
I want calendar dots to show more than just activity,
So that I can see patterns at a glance.

**Acceptance Criteria:**
- **Given** the calendar grid
  **When** I view dots
  **Then** terracotta indicates completion, forest indicates mood improvement, mustard indicates multiple.
- **And** legend is available (tap or long-press help).
- **And** colors meet contrast requirements.
- **And** VoiceOver announces: "November 15. 2 activities completed. Mood improved."

**Prerequisites:** 10.1, 9.4
**Technical Notes:** Compute dot state from HistoryEntry + MoodEntry; use DotIndicatorView with enum; forest uses half-fill or glow effect; accessible labels required.

---

## Epic 11: Gamification Core (FR38-FR43)

Goal: Implement Moments (points) and Seasons (levels) with celebration UI.

### Story 11.1: Moments point system (FR38)
As a user,
I want to earn "Moments" for completing activities,
So that my journey feels rewarding.

**Acceptance Criteria:**
- **Given** I complete an activity
  **When** it logs
  **Then** I earn base 10 Moments.
- **And** bonus +5 if mood improved, +3 if first of day, +5 if new category, +5 if low-energy day.
- **And** total appears in celebration UI.
- **And** running total updates in UserGamification entity.

**Prerequisites:** Epic 5, Epic 9
**Technical Notes:** GamificationService.swift with calculateMoments(for:); check MoodEntry delta; check HistoryEntry count for day; track categories tried; update UserGamification atomically.

### Story 11.2: Seasons level progression (FR39)
As a user,
I want to progress through "Seasons" as I collect Moments,
So that I feel a sense of long-term growth.

**Acceptance Criteria:**
- **Given** my Moments total crosses a threshold
  **When** checked
  **Then** my currentSeason advances (1-10).
- **And** Season names are: First Light, Morning Dew, Sunlit Path, Afternoon Tea, Golden Hour, Twilight Calm, Starlit, Full Moon, Aurora, Eternal Garden.
- **And** thresholds: 0, 50, 150, 300, 500, 800, 1200, 1800, 2500, 3500.
- **And** Season-up triggers celebration flow.

**Prerequisites:** 11.1
**Technical Notes:** Season enum with threshold lookup; GamificationService.checkSeasonProgression(); emit notification for UI; store currentSeason in UserGamification.

### Story 11.3: UserGamification Core Data entity
As a developer,
I want a UserGamification entity,
So that points, levels, and warmth persist and sync.

**Acceptance Criteria:**
- **Given** gamification state changes
  **When** saved
  **Then** UserGamification stores: id, totalMoments, currentSeason, warmthLevel, maxWarmthLevel, lastActivityDate.
- **And** entity syncs with max-value-merge conflict policy.
- **And** one record per user profile.
- **And** migration creates record for existing users at Season 1.

**Prerequisites:** Epic 7 (profile), Epic 8 (sync)
**Technical Notes:** Add UserGamification to xcdatamodeld; relationship to UserProfile; singleton per profile; sync conflict: keep highest totalMoments/currentSeason; migration script for existing users.

### Story 11.4: GamificationService logic
As a developer,
I want a centralized GamificationService,
So that all gamification logic is consistent.

**Acceptance Criteria:**
- **Given** activity completion
  **When** GamificationService processes it
  **Then** Moments calculated, Season checked, Warmth updated, Stamps evaluated.
- **And** service is testable in isolation.
- **And** service handles edge cases (offline, missing mood data).
- **And** service emits events for UI celebration.

**Prerequisites:** 11.1, 11.2, 11.3
**Technical Notes:** GamificationService.swift as singleton or injected; async processing; use Combine/NotificationCenter for events; unit tests for all bonus conditions.

### Story 11.5: Season-up celebration UI
As a user,
I want a warm celebration when I reach a new Season,
So that milestones feel meaningful.

**Acceptance Criteria:**
- **Given** I reach a new Season
  **When** the transition triggers
  **Then** I see a full-screen celebration with Season name, icon, and warm message.
- **And** if content unlocked, it's announced.
- **And** celebration is dismissable.
- **And** animation respects Reduce Motion setting.

**Prerequisites:** 11.2
**Technical Notes:** SeasonCelebrationView.swift; modal presentation; Season-specific colors/icons; "Unlocked: Morning Café theme" callout; spring animation or crossfade based on accessibility.

---

## Epic 12: Stamps, Warmth & Unlockables (FR40-FR45)

Goal: Implement badge collection, non-punishing streak gauge, and unlockable content.

### Story 12.1: Badge/Stamp system with definitions (FR40)
As a user,
I want to earn Stamps for various achievements,
So that I can collect meaningful milestones.

**Acceptance Criteria:**
- **Given** I meet a badge condition
  **When** GamificationService checks
  **Then** a Badge entity is created with badgeKey and earnedAt.
- **And** badge definitions include:
  - Journey: First Serving (1), Regular (10), Frequent Guest (25), House Favorite (50)
  - Explorer: Sampler Platter (all categories), per-category stamps
  - Mood: Lifted (5 improvements), Steady Hand (10 neutral-positive)
  - Time: Morning Person, Night Owl, Weekend Treat
  - Seasonal: Week Well Spent (4+ days/week), Monthly Check-in (10+ days/month)
- **And** no duplicate badges created.

**Prerequisites:** 11.4
**Technical Notes:** BadgeService.swift; badges_seed.json with definitions; Badge entity in Core Data; check conditions on activity completion; debounce to prevent spam.

### Story 12.2: StampGalleryView (FR41)
As a user,
I want to view my Stamp collection,
So that I can see my achievements.

**Acceptance Criteria:**
- **Given** Profile > Stamps
  **When** I view the gallery
  **Then** I see stamps grouped by category (Journey, Explorer, Mood, Time, Seasonal).
- **And** earned stamps show inked appearance with date earned on tap.
- **And** locked stamps show faded outline with requirement on tap.
- **And** earned stamps have slight rotation (3-7°) for hand-stamped effect.

**Prerequisites:** 12.1
**Technical Notes:** StampGalleryView.swift; LazyVGrid layout; StampView component with earned/locked states; rotation via .rotationEffect(Angle.degrees()); accessibility labels.

### Story 12.3: Warmth gauge (FR42, FR43)
As a user,
I want to see my "Warmth" level,
So that I can track my consistency without pressure.

**Acceptance Criteria:**
- **Given** Profile
  **When** I view Warmth gauge
  **Then** I see current level: Spark → Glow → Cozy → Warm → Radiant.
- **And** warmth grows +1-3 per activity.
- **And** warmth cools -1 per 3 inactive days.
- **And** grace period: 1 skip day per week doesn't affect warmth.
- **And** messaging is encouraging, never shaming.

**Prerequisites:** 11.3
**Technical Notes:** WarmthGaugeView.swift; calculate warmth in GamificationService; store warmthLevel and lastActivityDate; decay logic runs on app launch; "Your warmth is gently cooling..." not "Streak broken!"

### Story 12.4: Unlockable activity packs (FR44)
As a user,
I want to unlock new activity packs at Season milestones,
So that my journey reveals new experiences.

**Acceptance Criteria:**
- **Given** I reach Season 2/3/4
  **When** the milestone triggers
  **Then** a new activity pack is unlocked.
- **And** packs are: "Creative Sparks" (S2, 10 art/music), "Nature's Menu" (S3, 10 outdoor), "Mindful Moments" (S4, 10 meditation).
- **And** UnlockedContent entity records the unlock.
- **And** unlocked activities appear in the suggestion pool.

**Prerequisites:** 11.5, Epic 1 (seeded library)
**Technical Notes:** activity_packs_seed.json with pack definitions; UnlockedContent entity; modify Activity query to include unlocked packs; celebration callout on Season-up.

### Story 12.5: Unlockable themes (FR45)
As a user,
I want to unlock color themes at Season milestones,
So that my app reflects my journey.

**Acceptance Criteria:**
- **Given** I reach Season 2/3/4
  **When** the milestone triggers
  **Then** a theme is unlocked: "Morning Café" (S2, soft blues), "Garden Party" (S3, sage/blush), "Sunset Bistro" (S4, orange/burgundy).
- **And** UnlockedContent entity records the unlock.
- **And** I can select the theme in Settings.
- **And** theme applies to the entire app.

**Prerequisites:** 11.5, Epic 1 (theming)
**Technical Notes:** Theme definitions in Core/Theme; UnlockedContent with contentType="theme"; SettingsView theme picker shows locked/unlocked; apply via @Environment or ThemeManager; respect system appearance.

---

## Epic 13: Pro Mode - Activity Management (FR46-FR50)

Goal: Enable users to create, edit, and manage custom activities with full control over their personal activity library.

### Story 13.1: Activity editor view (FR46)
As a user,
I want to edit imported or custom activities,
So that I can personalize them to my preferences.

**Acceptance Criteria:**
- **Given** an activity in My Activities
  **When** I tap Edit
  **Then** I see a form with: title, description, time, energy, context, category, tags.
- **And** changes save locally (and to Supabase if community-shared).
- **And** original activity is preserved; my edits are personal overrides.
- **And** "Reset to original" option available for imported activities.

**Prerequisites:** Epic 7 (auth)
**Technical Notes:** ActivityEditorView.swift; form validation; UserActivityEdits Core Data entity for local overrides; sync to Supabase user_activity_edits table if online.

### Story 13.2: Activity creator view (FR47)
As a user,
I want to create my own activities from scratch,
So that I can add personal rituals to my menu.

**Acceptance Criteria:**
- **Given** Pro Mode enabled
  **When** I tap "Create Activity"
  **Then** I see a blank form with all activity fields.
- **And** validation ensures title (3+ chars), description (10+ chars), time (1-120 min).
- **And** created activities have source="user-created" and appear in suggestions.
- **And** created activities can optionally be shared to community.

**Prerequisites:** 13.1
**Technical Notes:** ActivityCreatorView.swift; reuse form from 13.1; save to Core Data with source="user-created"; optional "Share to Community" toggle submits to Supabase.

### Story 13.3: My Activities list view (FR48)
As a user,
I want to see all my custom and imported activities,
So that I can manage my personal library.

**Acceptance Criteria:**
- **Given** Profile > My Activities
  **When** I view the list
  **Then** I see activities grouped by: Created by Me, Imported from AI, Downloaded from Community.
- **And** each activity shows: title, category badge, time, source indicator.
- **And** swipe-to-delete available for custom activities.
- **And** tap opens activity detail with edit option.

**Prerequisites:** 13.1, 13.2
**Technical Notes:** MyActivitiesView.swift; sectioned list with source filter; fetch from Core Data with source predicate; show edit/delete actions.

### Story 13.4: Delete activity with undo (FR49)
As a user,
I want to delete custom activities with undo option,
So that I can remove activities without fear of losing them permanently.

**Acceptance Criteria:**
- **Given** a custom activity
  **When** I delete it
  **Then** it disappears with "Activity deleted" toast and "Undo" button.
- **And** undo restores the activity within 5 seconds.
- **And** seeded activities cannot be deleted (only hidden).
- **And** community activities can be "removed from library" (not deleted from server).

**Prerequisites:** 13.3
**Technical Notes:** Soft delete with timer; DeferredActionToast component; distinguish delete vs hide vs remove; Core Data delete for user-created only.

### Story 13.5: Pro Mode settings toggle (FR50)
As a user,
I want to enable/disable Pro Mode,
So that I can choose between simple and advanced activity management.

**Acceptance Criteria:**
- **Given** Settings
  **When** I toggle Pro Mode
  **Then** My Activities tab appears/disappears from navigation.
- **And** Create Activity button appears/disappears.
- **And** Edit option appears/disappears on activity cards.
- **And** Pro Mode state persists across sessions.

**Prerequisites:** None
**Technical Notes:** FeatureFlags.enableProMode; UserDefaults storage; conditional UI rendering; smooth transition animation.

---

## Epic 14: Community Library (FR51-FR60)

Goal: Enable browsing, voting, rating, and contributing to a shared community activity library powered by Supabase.

### Story 14.1: Supabase client setup (FR51)
As a developer,
I want Supabase client integrated,
So that the app can communicate with the community backend.

**Acceptance Criteria:**
- **Given** app launch
  **When** network is available
  **Then** Supabase client initializes with environment-specific URL and key.
- **And** client handles auth state from Sign in with Apple.
- **And** offline mode gracefully degrades with cached data.
- **And** configuration supports dev/staging/prod environments.

**Prerequisites:** Epic 7 (auth)
**Technical Notes:** Add supabase-swift package; Config.swift for environment URLs; SupabaseManager singleton; bridge Apple auth to Supabase auth.

### Story 14.2: Community browse view (FR52)
As a user,
I want to browse community activities,
So that I can discover new ideas from other users.

**Acceptance Criteria:**
- **Given** Community tab
  **When** I open it
  **Then** I see a grid of activity cards with: title, category, rating, vote count.
- **And** I can filter by: category, energy level, time range.
- **And** I can sort by: trending, newest, highest rated.
- **And** pull-to-refresh fetches latest activities.
- **And** pagination loads more as I scroll.

**Prerequisites:** 14.1
**Technical Notes:** CommunityBrowseView.swift; LazyVGrid with CommunityActivityCard; Supabase query with filters; infinite scroll with cursor pagination; LocalActivityCache for offline.

### Story 14.3: Activity detail with voting (FR53)
As a user,
I want to view activity details and vote,
So that I can support activities I like.

**Acceptance Criteria:**
- **Given** a community activity
  **When** I tap it
  **Then** I see full details: title, description, author, category, tags, stats.
- **And** I can upvote or downvote (one vote per activity).
- **And** vote count updates in real-time.
- **And** my vote state persists and shows on return.
- **And** voting works offline (queued for sync).

**Prerequisites:** 14.2
**Technical Notes:** CommunityActivityDetailView.swift; VoteButton component with optimistic UI; Supabase real-time subscription for vote updates; OfflineActionQueue for offline voting.

### Story 14.4: Star rating and reviews (FR54)
As a user,
I want to rate activities with stars and optional review,
So that I can share my experience with others.

**Acceptance Criteria:**
- **Given** an activity I've tried
  **When** I tap Rate
  **Then** I see 1-5 star picker with optional review text field.
- **And** my rating updates the activity's average rating.
- **And** I can change my rating later.
- **And** reviews appear in activity detail (newest first).
- **And** average rating shows on browse cards.

**Prerequisites:** 14.3
**Technical Notes:** StarRatingView.swift; 5-star interactive picker; Supabase ratings table with upsert; aggregate update via trigger; review text max 500 chars.

### Story 14.5: Download to library (FR55)
As a user,
I want to download community activities to my local library,
So that I can use them offline and include them in suggestions.

**Acceptance Criteria:**
- **Given** a community activity
  **When** I tap "Add to My Menu"
  **Then** the activity saves to Core Data.
- **And** download count increments on server.
- **And** activity appears in My Activities with "Community" source.
- **And** downloaded activities appear in suggestion pool.
- **And** badge shows "Downloaded" state on community cards.

**Prerequisites:** 14.2, 13.3
**Technical Notes:** Download creates local ActivityEntity copy with source="community-download"; track in user_downloads table; deduplicate by activity UUID.

### Story 14.6: Submit activity to community (FR56)
As a user,
I want to share my custom activities with the community,
So that others can benefit from my ideas.

**Acceptance Criteria:**
- **Given** a custom activity
  **When** I tap "Share to Community"
  **Then** activity submits for moderation.
- **And** I see submission confirmation with "Pending Review" status.
- **And** I can view my submissions and their status.
- **And** approved activities appear in community browse.
- **And** rejected activities show reason and allow resubmission.

**Prerequisites:** 13.2, 14.1
**Technical Notes:** Submit to Supabase activities with moderation_status="pending"; MySubmissionsView.swift; Edge Function for auto-moderation; notification on approval/rejection.

### Story 14.7: Search community activities (FR57)
As a user,
I want to search the community library,
So that I can find specific types of activities.

**Acceptance Criteria:**
- **Given** Community tab
  **When** I type in search field
  **Then** results filter by title, description, and tags.
- **And** search is debounced (300ms delay).
- **And** full-text search returns relevance-ranked results.
- **And** empty results show helpful message with category suggestions.
- **And** recent searches are saved for quick access.

**Prerequisites:** 14.2
**Technical Notes:** Use Supabase search_activities RPC function; debounced TextField; RecentSearches in UserDefaults; empty state with popular categories.

### Story 14.8: Activity packs browse (FR58)
As a user,
I want to browse curated activity packs,
So that I can discover themed collections.

**Acceptance Criteria:**
- **Given** Community > Packs
  **When** I view the section
  **Then** I see official packs with: cover image, name, activity count, unlock status.
- **And** free packs show "Download Pack" button.
- **And** locked packs show "Unlock at Season X" with progress.
- **And** tapping opens pack detail with activity list.
- **And** unlocked packs can be downloaded entirely.

**Prerequisites:** 14.2, Epic 11 (gamification)
**Technical Notes:** ActivityPacksView.swift; fetch from activity_packs table; check user_pack_unlocks; bulk download creates multiple ActivityEntity records.

### Story 14.9: Report inappropriate content (FR59)
As a user,
I want to report inappropriate activities,
So that the community stays safe and welcoming.

**Acceptance Criteria:**
- **Given** a community activity
  **When** I tap Report
  **Then** I see reason options: inappropriate, spam, harmful, duplicate, other.
- **And** I can add optional details.
- **And** report submits and shows confirmation.
- **And** activities with 5+ reports auto-flag for review.
- **And** I can only report each activity once.

**Prerequisites:** 14.3
**Technical Notes:** ReportActivitySheet.swift; insert to reports table; trigger updates report_count and flags at threshold; warm "Thanks for keeping our community safe" confirmation.

### Story 14.10: User collections (FR60)
As a user,
I want to create collections of activities,
So that I can organize themed playlists for different occasions.

**Acceptance Criteria:**
- **Given** Profile > Collections
  **When** I create a collection
  **Then** I can name it and optionally make it public.
- **And** I can add activities from browse or my library.
- **And** collections show activity count and can be reordered.
- **And** public collections appear in community browse.
- **And** I can share collection link with friends.

**Prerequisites:** 14.5, 13.3
**Technical Notes:** CollectionsView.swift; collections and collection_items tables; drag-to-reorder with sort_order; share via deep link or activity share sheet.

---

## FR Coverage Matrix (v2)

| FR | Epic.Story coverage |
|----|---------------------|
| FR23 | 7.1 |
| FR24 | 7.2 |
| FR25 | 7.3 |
| FR26 | 7.5 |
| FR27 | 8.1, 8.2 |
| FR28 | 8.3 |
| FR29 | 8.2 |
| FR30 | 9.1 |
| FR31 | 9.2 |
| FR32 | 9.1, 9.2, 9.3 |
| FR33 | 9.3 |
| FR34 | 9.3, 9.5 |
| FR35 | 10.1 |
| FR36 | 10.2 |
| FR37 | 10.5 |
| FR38 | 11.1 |
| FR39 | 11.2 |
| FR40 | 12.1 |
| FR41 | 12.2 |
| FR42 | 12.3 |
| FR43 | 12.3 |
| FR44 | 12.4 |
| FR45 | 12.5 |
| FR46 | 13.1 |
| FR47 | 13.2 |
| FR48 | 13.3 |
| FR49 | 13.4 |
| FR50 | 13.5 |
| FR51 | 14.1 |
| FR52 | 14.2 |
| FR53 | 14.3 |
| FR54 | 14.4 |
| FR55 | 14.5 |
| FR56 | 14.6 |
| FR57 | 14.7 |
| FR58 | 14.8 |
| FR59 | 14.9 |
| FR60 | 14.10 |

---

## Summary

DailyMenu v2 adds 8 epics (7-14) with 45 stories that transform the app into a personal wellness journey platform with community features.

### Optimized Implementation Order

| Phase | Sprints | Epics | Parallelization |
|-------|---------|-------|-----------------|
| **Phase 1** | 1-2 | Epic 13, 9, 10 | 3 parallel tracks |
| **Phase 2** | 3-4 | Epic 7, 11 | 2 parallel tracks |
| **Phase 3** | 5-6 | Epic 8, 12 | 2 parallel tracks |
| **Phase 4** | 7-9 | Epic 14 | 2 parallel tracks |

**Key Insight**: By starting with Pro Mode (13), Mood (9), and Calendar (10) in Phase 1, we deliver user-facing features immediately while Authentication (7) and Gamification (11) proceed in Phase 2. This reduces time-to-value for local features.

### Implementation Rationale

1. **Phase 1 (Local Features)**: Epic 13 (Pro Mode), Epic 9 (Mood), Epic 10 (Calendar)
   - No dependencies, maximum parallelization
   - Users get tangible features without needing an account

2. **Phase 2 (Identity & Rewards)**: Epic 7 (Auth), Epic 11 (Gamification)
   - Auth enables sync; Gamification uses Mood data from Phase 1
   - Profile page ties together Phase 1 features

3. **Phase 3 (Sync & Achievements)**: Epic 8 (iCloud), Epic 12 (Stamps)
   - Sync requires auth; Stamps require gamification
   - Cross-device experience becomes complete

4. **Phase 4 (Community)**: Epic 14 (Community Library)
   - Requires auth, gamification, and pro mode
   - Full platform capabilities

**Time Savings**: ~40% reduction through parallelization (4-5 sprints vs 7-8 sequential)

All features maintain the "engagement without pressure" philosophy with prominent skip options, warm messaging, and no streak punishment.

**Technical Architecture:**
- **Personal Data**: CloudKit (offline-first, free, Apple-native)
- **Community Data**: Supabase (PostgreSQL, cross-platform ready)

---

_For implementation: Use the `create-story` workflow to generate individual story implementation plans from this epic breakdown._

_This document extends epics.md (v1) which covers Epics 1-6._

_See also: `docs/supabase-schema.md` for Community Library database schema._
