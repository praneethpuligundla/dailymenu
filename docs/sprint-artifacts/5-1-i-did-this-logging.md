# Story 5.1: “I did this” logging (FR14)

Status: ready-for-dev

## Story
As a user, I want to mark an activity as done, So that I can feel progress and keep light history.

## Acceptance Criteria
1. **Given** a suggestion or favorite **When** I tap “I did this” **Then** the activity ID and timestamp are stored locally and acknowledged with warm feedback.
2. **And** logging works offline.

## Tasks / Subtasks
- [ ] Implement AC1 — **Given** a suggestion or favorite **When** I tap “I did this” **Then** the activity ID and timestamp are stored locally and acknowledged with warm feedback. (AC: #1)
- [ ] Implement AC2 — **And** logging works offline. (AC: #2)

## Dev Notes
- Tech notes: HistoryEntry entity; debounce taps; gentle toast; analytics-ready (local); prep for optional export with consent via backend proxy.
- Prerequisites: 2.6, 1.2
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
- docs/sprint-artifacts/5-1-i-did-this-logging.context.xml

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
