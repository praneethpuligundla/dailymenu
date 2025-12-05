# Story 2.8: Tone and safety guardrails in suggestions (FR21–FR22)

Status: ready-for-dev

## Story
As a user, I want suggestions and UI copy to stay warm and non-judgmental, So that I feel encouraged, not pressured.

## Acceptance Criteria
1. **Given** any suggestion state **When** I read titles, descriptions, and actions **Then** there is no streak/leaderboard language, and messages are supportive.
2. **And** empty/error states avoid shame; success states celebrate lightly (“Nice, that counts.”).

## Tasks / Subtasks
- [ ] Implement AC1 — **Given** any suggestion state **When** I read titles, descriptions, and actions **Then** there is no streak/leaderboard language, and messages are supportive. (AC: #1)
- [ ] Implement AC2 — **And** empty/error states avoid shame; success states celebrate lightly (“Nice, that counts.”). (AC: #2)

## Dev Notes
- Tech notes: Copy review; lint strings; include accessibility for tone; QA against tone checklist.
- Prerequisites: 2.6
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
- docs/sprint-artifacts/2-8-tone-and-safety-guardrails-in-suggestions.context.xml

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
