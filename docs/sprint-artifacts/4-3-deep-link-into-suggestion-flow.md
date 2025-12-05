# Story 4.3: Deep link into suggestion flow (FR18)

Status: ready-for-dev

## Story
As a user, I want reminder taps to open directly to fresh suggestions, So that I can act immediately.

## Acceptance Criteria
1. **Given** a reminder fires **When** I tap it **Then** the app opens to the suggestion screen with selections applied or sensible defaults.
2. **And** if offline, it still shows cached suggestions.

## Tasks / Subtasks
- [ ] Implement AC1 — **Given** a reminder fires **When** I tap it **Then** the app opens to the suggestion screen with selections applied or sensible defaults. (AC: #1)
- [ ] Implement AC2 — **And** if offline, it still shows cached suggestions. (AC: #2)

## Dev Notes
- Tech notes: Notification payload with context; handle cold/warm starts; respect offline cache; wire deep links via scene delegate routing.
- Prerequisites: 2.4, 4.2
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
- docs/sprint-artifacts/4-3-deep-link-into-suggestion-flow.context.xml

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
