# DailyMenu - Product Requirements Document

**Author:** BMad
**Date:** 2025-11-29
**Version:** 1.0

---

## Executive Summary

DailyMenu’s “Fun, Not a Chore” feature is a mobile-first micro-ritual menu that replaces doomscrolling with ready-to-do, low-effort activities. In 1–2 taps, users pick their time/energy/context and receive 1–3 warm, no-pressure suggestions they can start immediately. The experience is intentionally light, offline-friendly after initial load, and avoids streak anxiety—optimizing for attainable joy rather than productivity metrics.

### What Makes This Special

Guilt-free, one-tap ideas that respect real-life constraints (time, energy, context), keep everything low-pressure, work offline after initial load, and feel like a kind friend offering small joys—not a self-improvement checklist.

---

## Project Classification

**Technical Type:** iOS app (consumer wellness micro-rituals)
**Domain:** General lifestyle/wellness
**Complexity:** Low

Consumer iOS experience with light personalization, prewritten activity library, gentle notifications, and offline-first delivery after initial content download. No regulated data or payments; minimal PII (preferences, reminders, optional history).

---

## Success Criteria

The product is succeeding when users reliably replace autopilot scrolling with intentional micro-rituals and feel that “fun is attainable, not a chore.” Concretely:
- Users complete at least one micro-ritual most days without feeling pressured.
- Suggestions feel instant and context-fit (time/energy/context) with high perceived relevance.
- Favorites become a lightweight “go-to” list that users revisit weekly.
- Gentle reminders are welcomed (opted-in, low opt-out rate) and drive sessions without guilt.
- Tone consistently reads as warm, validating, and non-judgmental in feedback.

### Business Metrics

- Engagement: D1/D7 retention, weekly sessions per active user, % sessions with “I did this.”
- Depth: Activities completed per week per active user; favorites per user; hide rate to prune weak content.
- Satisfaction: App store rating and qualitative feedback on “Does this feel like a chore?” and “Does this help you enjoy your day more?”
- Habit health: Reminder opt-in/opt-out rates and completion following reminders (without streak anxiety).

---

## Product Scope

### MVP - Minimum Viable Product

- Time/energy/context-based suggestion flow (1–3 cards) with “Do this,” “New suggestion,” “Save,” and “Hide.”
- Prewritten library of 100+ tagged activities across Starters, Mains, Desserts, Connection Sides, Low-Battery.
- Activity details with short how-to steps, tags, and “I did this” logging.
- Favorites list; hide/ban list respected in suggestions.
- Simple preferences toggles (outside / driving/store / partner-kids relevance) affecting suggestions.
- One gentle reminder window per day (opt-in).
- Offline-first after initial content download; local logging of completions and favorites.
- Data reset for favorites/history/preferences.

### Growth Features (Post-MVP)

- Weekly recap (“You had X intentional moments”) and trend nudge.
- History view (7–30 days) grouped by day.
- Two configurable reminder windows with smarter timing.
- Smarter suggestion rotation to avoid repetition across days.
- Light personalization weighting based on past completions/favorites.

### Vision (Future)

- Adaptive suggestions that learn user patterns (time of day, energy, social context).
- Micro-ritual packs (e.g., “Sunday Soft Reset,” “Desk Breaks,” “Couples Evenings”).
- Share an activity completion with a friend via link (no public feed).
- Calendar/wearable signals to bias toward low-battery options on heavy days.
- Minimalist web companion to browse and favorite activities.

---

## Innovation & Novel Patterns

- “Menu” framing (Starters/Mains/Desserts/Connection/Low-Battery) makes choices feel fun and finite.
- Low-battery mode and guilt-free tone as differentiators vs habit apps.
- Offline-first plus no streaks to remove pressure while keeping immediacy.

---

## Mobile App Specific Requirements

### Platform Support
- Native iOS experience; Android and web are out of scope for now.
- Works offline after initial content download; all core flows function without network.
- App size kept lean; content updates can be batched when online.

### Device Capabilities
- Push notifications for gentle reminders (user opt-in, configurable windows).
- Local storage for activity library, preferences, favorites, history.
- Optional haptics for subtle feedback; no camera/mic/location required.

### Additional Mobile Considerations
- Offline mode: suggestions, favorites, hide list, and “I did this” logging available offline; sync when online.
- Push strategy: one opt-in reminder window in MVP; two in growth; copy is warm, non-guilt.
- Store compliance: clear privacy copy, no streak pressure visuals, transparent data reset; minimal permissions to ease review.

---

## User Experience Principles

- Warm, validating, non-judgmental tone; microcopy celebrates small wins (“Nice, that counts.”).
- Calm, uncluttered UI; playful but not gamified; no streak flames or red badges.
- One- to two-tap paths to a suggestion; frictionless skip/refresh.
- Low-battery mode foregrounded for tired users; default suggestions respect chosen context.
- Accessibility-conscious: legible typography, high-contrast defaults, clear touch targets.

### Key Interactions
- Launch → pick time → pick energy → optional solo/with someone → see 1–3 suggestions.
- “New suggestion” cycles without repeats in-session; respects hide/favorite lists.
- Card expand shows brief steps + tags; “I did this” logs instantly.
- Favorites list for quick access; History list (growth) for light reflection.
- Settings for preferences, reminders, data reset.

---

## Functional Requirements

**Content Discovery & Suggestion Flow**
- FR1: Users can select a time window (5–10, 15–30, 30+ minutes) on launch.
- FR2: Users can select an energy level (Low, Okay, Up for something).
- FR3: Users can choose context (Solo / With someone) and the system biases suggestions accordingly.
- FR4: System surfaces 1–3 suggestion cards matching time/energy/context with minimal latency.
- FR5: Users can request a new suggestion; system avoids repeats within the current session.
- FR6: Suggestion cards show title, 1–2 line description, expected time, and actions (“Do this,” “New suggestion,” “Save,” “Hide”).
- FR7: Cards expand to show up to three micro-steps and tag chips (time, energy, context, category).

**Activity Library & Personalization**
- FR8: System ships with at least 100 prewritten activities tagged by time, energy, context, category, and repeatability.
- FR9: Categories include Starters (5–10), Mains (15–30), Desserts (30–60), Connection, and Low-Battery.
- FR10: Users can favorite/unfavorite activities; favorites list is accessible and filterable by category.
- FR11: Users can hide activities; hidden items do not appear in future suggestions unless unhidden.
- FR12: System respects user preferences (outside allowed, driving/store allowed, partner/kids relevance) when suggesting.
- FR13: System reduces repetition across sessions unless an activity is favorited or recently completed.

**Execution & Logging**
- FR14: Users can mark “I did this,” logging activity ID and timestamp locally.
- FR15: Users can view a simple history of completions (growth: last 7–30 days grouped by day).
- FR16: Users can reset activity data (favorites/history/preferences) from settings.

**Notifications & Reminders**
- FR17: Users can opt in/out of reminders and configure time windows (one window in MVP; two in growth).
- FR18: Reminder text is gentle and actionable (e.g., “Want a 5-min Starter?”) and deep-links into the suggestion flow.

**Offline & Data Handling**
- FR19: Core flows (suggestions, favorites, hide list, “I did this” logging) work offline after initial content download.
- FR20: Sync, if implemented, preserves local state integrity when reconnecting.

**Tone & Safety**
- FR21: UI and copy avoid productivity or guilt language; celebrate small wins (“Tiny joys add up”).
- FR22: No streak mechanics, leaderboards, or social pressure in v1.

---

## Non-Functional Requirements

### Performance

Home screen and first suggestion load in under 2 seconds on a mid-range device after initial content download; suggestion refresh feels instantaneous (<1s perceived).

### Security

Local data stored securely using platform defaults; minimal PII (preferences, favorites, history). If cloud sync is added later, use encrypted transport and platform auth.

### Scalability

Content and state are lightweight; app must remain responsive with growing activity library and history.

### Accessibility

Clear typography, sufficient contrast, large tap targets; copy avoids idioms that imply shame; supports OS text scaling gracefully.

### Integration

None for MVP (standalone); future integrations may include calendar/wearables.

---

_This PRD captures the essence of DailyMenu — making intentional joy effortless with warm, one-tap micro-rituals that fit any time, energy, or social context._

_Created through collaborative discovery between BMad and AI facilitator._
