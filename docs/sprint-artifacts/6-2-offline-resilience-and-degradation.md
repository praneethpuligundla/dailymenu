# Story 6.2: Offline resilience and degradation (FR19)

Status: ready-for-dev

## Story
As a user, I want the app to behave gracefully when offline, So that I can still use suggestions and lists.

## Acceptance Criteria
1. **Given** no network **When** I use the app **Then** core flows (suggestions, favorites, hide, history) work from local data and show offline status subtly.
2. **And** actions that need network are deferred with clear messaging.

## Tasks / Subtasks
- [ ] Implement AC1 — **Given** no network **When** I use the app **Then** core flows (suggestions, favorites, hide, history) work from local data and show offline status subtly. (AC: #1)
- [ ] Implement AC2 — **And** actions that need network are deferred with clear messaging. (AC: #2)

## Dev Notes
- Tech notes: Reachability checks; queue network tasks; cached assets; log offline events; ensure local store is source of truth when offline.
- Prerequisites: 1.6, 2.4
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
- docs/sprint-artifacts/6-2-offline-resilience-and-degradation.context.xml

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
