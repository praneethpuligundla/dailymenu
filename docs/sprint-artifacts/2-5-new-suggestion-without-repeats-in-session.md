# Story 2.5: New suggestion without repeats in-session (FR5)

Status: ready-for-dev

## Story
As a user, I want to refresh suggestions without repeats in the same session, So that I don’t see the same card over and over.

## Acceptance Criteria
1. **Given** suggestions are shown **When** I tap “New suggestion” **Then** the cards rotate to unseen items until the pool is exhausted, then reset gracefully.
2. **And** a brief toast explains when the pool resets; state persists until app quit.

## Tasks / Subtasks
- [ ] Implement AC1 — **Given** suggestions are shown **When** I tap “New suggestion” **Then** the cards rotate to unseen items until the pool is exhausted, then reset gracefully. (AC: #1)
- [ ] Implement AC2 — **And** a brief toast explains when the pool resets; state persists until app quit. (AC: #2)

## Dev Notes
- Tech notes: Track session IDs; in-memory seen set; reshuffle on pool exhaustion; reuse local data.
- Prerequisites: 2.4
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
- docs/sprint-artifacts/2-5-new-suggestion-without-repeats-in-session.context.xml

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
