# Story 3.5: Session and cross-session rotation (FR13)

Status: ready-for-dev

## Story
As a user, I want reduced repetition across days unless I favorited or recently completed an item, So that variety stays high.

## Acceptance Criteria
1. **Given** prior sessions **When** I request suggestions on a new day **Then** recently shown items are deprioritized unless favorited.
2. **And** favorited items can still appear with gentle weighting; hidden items never appear.

## Tasks / Subtasks
- [ ] Implement AC1 — **Given** prior sessions **When** I request suggestions on a new day **Then** recently shown items are deprioritized unless favorited. (AC: #1)
- [ ] Implement AC2 — **And** favorited items can still appear with gentle weighting; hidden items never appear. (AC: #2)

## Dev Notes
- Tech notes: Simple decay scoring using last-seen timestamps; store session metadata in Core Data; deterministic fallback; reset logic per session; optional feed weighting if cloud feed enabled later.
- Prerequisites: 2.5, 3.2
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
- docs/sprint-artifacts/3-5-session-and-cross-session-rotation.context.xml

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
