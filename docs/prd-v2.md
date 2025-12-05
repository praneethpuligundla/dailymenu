# DailyMenu - Product Requirements Document v2

**Author:** BMad
**Date:** 2025-12-01
**Version:** 2.0
**Extends:** PRD v1.0 (docs/prd.md)

---

## Executive Summary

DailyMenu v2 transforms the micro-ritual menu from a local activity suggestion app into a **personal wellness journey platform**. Building on the guilt-free, one-tap foundation, v2 adds:

- **Sign in with Apple** + Face ID/Passkey for seamless authentication
- **iCloud sync** to carry tiny joys across devices
- **Before/after mood tracking** with quick feedback loops
- **Gentle gamification** (Moments, Seasons, Stamps) that celebrates without pressure
- **Calendar view** to reflect on the journey over time
- **Profile page** with personal insights and stats

**Philosophy**: "Engagement without pressure" — celebrate presence, never guilt absence.

### What Makes v2 Special

Everything from v1 remains: warm tone, offline-first, no streak anxiety. v2 adds depth for users who want to see their journey unfold — optionally, never forced. Authentication unlocks sync; gamification rewards consistency without punishment; mood tracking reveals patterns without becoming a chore.

---

## Project Classification

**Technical Type:** iOS app (consumer wellness journey platform)
**Domain:** General lifestyle/wellness
**Complexity:** Medium (auth, sync, gamification systems)

Consumer iOS experience with optional authentication, iCloud sync, gentle gamification, and mood insights. No regulated data or payments; minimal PII stored securely with Keychain and CloudKit encryption.

---

## Success Criteria

The product is succeeding when users feel their micro-ritual practice is **visible, valued, and growing** — without pressure. Concretely:

- Users who opt into authentication sync seamlessly across devices.
- Mood tracking reveals positive patterns users find meaningful (not burdensome).
- Gamification feels like warm recognition, not a treadmill.
- Calendar view becomes a source of gentle pride ("Look what I've done").
- Users who skip days feel welcomed back, not shamed.

### Business Metrics

| Category | Metric |
|----------|--------|
| **Engagement** | Auth opt-in rate; sync activation rate; D7/D30 retention for synced users |
| **Mood** | % activities with mood logged; mood improvement rate over time |
| **Gamification** | Season progression rate; stamp collection rate; unlock engagement |
| **Reflection** | Calendar view opens per week; average history depth viewed |
| **Satisfaction** | App store rating; qualitative feedback on "Does this feel rewarding without pressure?" |

---

## Product Scope

### MVP v2 — Journey Platform

- **Authentication**: Optional Sign in with Apple; Face ID/Passkey protection
- **Profile Page**: Display name, member since, activity stats, settings
- **iCloud Sync**: Cross-device sync for history, favorites, gamification (opt-in)
- **Mood Tracking**: Before/after mood check (3-point scale, skippable)
- **Quick Feedback**: Post-activity feedback (Loved it / Nice / Not for me)
- **Calendar View**: Month grid with activity dots; day detail view
- **Gamification Core**: Moments (points), Seasons (levels), Warmth gauge (soft streak)
- **Stamps**: Achievement badges with vintage aesthetic

### Growth v2 (Post-MVP)

- **Mood Insights**: Visualizations of mood patterns over time
- **Unlockable Content**: Activity packs and themes at Season milestones
- **Enhanced Calendar**: Filters by category, mood improvement, feedback
- **Social Sharing**: Share a single activity completion with a friend (no public feed)
- **Adaptive Suggestions**: Weight suggestions based on mood/feedback history

### Vision (Future)

- **Watch Companion**: Quick mood check-ins from Apple Watch
- **Widget Gallery**: Home screen widgets showing streak warmth, next suggestion
- **Family Sharing**: Shared activity challenges with household members
- **Therapist Export**: Optional PDF export of mood journey for wellness discussions

---

## Innovation & Novel Patterns

- **"Warmth Gauge" streak**: Grows with activity, cools slowly (not broken instantly)
- **"Moments" and "Seasons"**: Warm language replacing XP/Levels
- **"Stamps" collection**: Hand-stamped aesthetic, not digital badges
- **Optional everything**: Auth, sync, mood, gamification all work independently
- **Before/after mood delta**: Subtle insight into activity impact without analysis paralysis

---

## Functional Requirements — v2 Additions

### Authentication (FR23-FR26)

- **FR23**: Users can sign in with Apple to enable cross-device sync.
- **FR24**: User credentials are stored in Keychain with Face ID/Passkey protection.
- **FR25**: Users can view and edit their profile (display name, member since, stats).
- **FR26**: App handles credential revocation gracefully; prompts re-authentication.

### iCloud Sync (FR27-FR29)

- **FR27**: Authenticated users can enable iCloud sync for history, favorites, and gamification.
- **FR28**: Sync conflicts resolve per entity policy (server-wins, last-writer-wins, max-merge).
- **FR29**: Users control what syncs; local preferences never leave the device.

### Mood Tracking (FR30-FR34)

- **FR30**: Users see a before-mood prompt (Low / Okay / Good) when starting an activity.
- **FR31**: Users see an after-mood prompt (Lower / Same / Better) when completing an activity.
- **FR32**: Both mood prompts are skippable with prominent "Skip" button.
- **FR33**: Users can provide quick feedback (Loved it / Nice / Not for me) after completing.
- **FR34**: Feedback and mood data influence future suggestion ranking.

### Calendar View (FR35-FR37)

- **FR35**: Users can view a month calendar grid showing dots/stamps for activity days.
- **FR36**: Tapping a day shows the list of activities completed that day with details.
- **FR37**: Calendar uses color coding (terracotta: completed, forest: mood improved, mustard: multiple).

### Gamification (FR38-FR45)

- **FR38**: Completing activities earns "Moments" (points) with bonus for mood improvement, first-of-day, new category, low-energy day.
- **FR39**: Accumulated Moments advance users through "Seasons" (levels) with warm names (First Light → Eternal Garden).
- **FR40**: Users earn "Stamps" (badges) for journey milestones, exploration, mood patterns, and time-based achievements.
- **FR41**: Stamps display in a gallery with vintage hand-stamped aesthetic.
- **FR42**: The "Warmth Gauge" tracks gentle streaks: grows with activity, cools slowly over inactivity, never breaks dramatically.
- **FR43**: Warmth levels progress: Spark → Glow → Cozy → Warm → Radiant.
- **FR44**: Season milestones unlock activity packs (10 themed activities each).
- **FR45**: Season milestones unlock color themes (Morning Café, Garden Party, Sunset Bistro).

---

## Non-Functional Requirements — v2 Additions

### Performance

- Profile and calendar load within 1 second; gamification state updates feel instant.
- iCloud sync operates in background without blocking UI.

### Security

- Apple user ID and tokens stored in Keychain with Face ID protection.
- CloudKit encryption for synced data; local-only store for private preferences.
- No raw mood/feedback data exposed to analytics; only aggregated insights.

### Privacy

- Mood sync is user-controlled (can be disabled independently).
- Local preferences (hidden activities, excluded categories) never sync.
- Users can delete all cloud data from Settings.

### Accessibility

- Mood prompts work with VoiceOver; icons have descriptive labels.
- Warmth gauge and stamps support dynamic type scaling.
- Calendar grid accessible via focus navigation.

### Offline Resilience

- All gamification works offline; syncs when connection available.
- Calendar displays cached data; queued activities sync on reconnect.
- Mood prompts work offline; mood entries queued for sync.

---

## User Experience Principles — v2 Additions

- **Celebration, not competition**: Gamification rewards personal journey, never compares to others.
- **Grace over guilt**: Warmth cools slowly; one skip day per week has no effect.
- **Optional depth**: Power users unlock layers; casual users see simple suggestions.
- **Artisanal aesthetic**: Stamps look hand-made; seasons evoke nature; moments feel collected, not earned.
- **Skip is always okay**: Every prompt has a clear, non-judgmental skip option.

### Key Interactions — v2

- **Sign in**: Warm onboarding → "Continue with Apple" → Profile created → Sync prompt
- **Mood flow**: Start activity → Before mood (skip?) → Do activity → After mood (skip?) → Feedback (skip?) → Moments awarded
- **Calendar**: History tab → Calendar/List toggle → Month view → Tap day → Day detail sheet
- **Gamification**: Profile → Season progress bar → Stamp gallery → Unlock celebration

---

## FR Coverage Summary

| Requirement | Category |
|-------------|----------|
| FR1-FR22 | Core v1 (see prd.md) |
| FR23-FR26 | Authentication |
| FR27-FR29 | iCloud Sync |
| FR30-FR34 | Mood Tracking |
| FR35-FR37 | Calendar View |
| FR38-FR45 | Gamification |

---

_This PRD v2 extends the original DailyMenu vision with optional depth for users seeking a visible journey — while preserving the guilt-free, warm, offline-first foundation that makes micro-rituals feel like tiny joys, not another chore._

_Created through collaborative discovery between BMad and AI facilitator._
