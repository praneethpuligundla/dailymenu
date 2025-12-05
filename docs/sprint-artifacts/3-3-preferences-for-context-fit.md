# Story 3.3: Preferences for context fit (FR12)

Status: ready-for-dev

## Story
As a user, I want to set preferences (outside, driving/store, partner-kids relevance), So that suggestions match my constraints.

## Acceptance Criteria
1. **Given** settings/preferences **When** I toggle options **Then** suggestion ranking and filtering respect them immediately.
2. **And** prefs persist across sessions and offline.

## Tasks / Subtasks
- [ ] Implement AC1 — **Given** settings/preferences **When** I toggle options **Then** suggestion ranking and filtering respect them immediately. (AC: #1)
- [ ] Implement AC2 — **And** prefs persist across sessions and offline. (AC: #2)

## Dev Notes
- Tech notes: Prefs model; include in query predicates; defaults safe; accessible controls; persist in Core Data; expose via Settings; ready for sync when flag enabled.
- Prerequisites: 2.3, 1.2
- Architecture: docs/bmm-architecture-2025-11-29.md
- PRD: docs/prd.md
- Epics: docs/epics.md

### Project Structure Notes
- Follow feature-first layout under App/Core/Features per architecture doc.
- Place data models in Core/Data and views under Features/*.

### References
- [Source: docs/epics.md]
- [Source: docs/bmm-architecture-2025-11-29.md]
- [Source: docs/prd.md]

## Dev Agent Record

### Context Reference
- docs/sprint-artifacts/3-3-preferences-for-context-fit.context.xml

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
