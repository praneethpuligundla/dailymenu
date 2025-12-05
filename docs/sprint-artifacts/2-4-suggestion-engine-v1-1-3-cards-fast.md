# Story 2.4: Suggestion engine v1 (1–3 cards, fast) (FR4)

Status: ready-for-dev

## Story
As a user, I want 1–3 matching suggestion cards to load quickly, So that I can act immediately.

## Acceptance Criteria
1. **Given** I selected time/energy/context **When** I tap “Show suggestions” **Then** 1–3 cards render within target perceived speed with titles, descriptions, time tag.
2. **And** at least one suggestion always appears if the library has matches; loading state is warm and non-judgmental.

## Tasks / Subtasks
- [ ] Implement AC1 — **Given** I selected time/energy/context **When** I tap “Show suggestions” **Then** 1–3 cards render within target perceived speed with titles, descriptions, time tag. (AC: #1)
- [ ] Implement AC2 — **And** at least one suggestion always appears if the library has matches; loading state is warm and non-judgmental. (AC: #2)

## Dev Notes
- Tech notes: Local query over seeded store; simple ranking; prefetch cards; instrument load time; avoid blocking on network; optional Core ML/local generator behind flag with fallback to cached feed; cloud LLM path only via backend proxy and user consent (flagged).
- Prerequisites: 2.3, 1.3
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
- docs/sprint-artifacts/2-4-suggestion-engine-v1-1-3-cards-fast.context.xml

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
