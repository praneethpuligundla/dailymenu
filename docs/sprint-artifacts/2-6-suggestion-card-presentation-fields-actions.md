# Story 2.6: Suggestion card presentation (fields + actions) (FR6)

Status: ready-for-dev

## Story
As a user, I want each card to show key info and actions, So that I understand and can act quickly.

## Acceptance Criteria
1. **Given** cards are visible **When** I view a card **Then** I see title, 1–2 line description, expected time, and actions: Do this, New suggestion, Save, Hide.
2. **And** buttons are large, warm copy; no streaks or guilt.

## Tasks / Subtasks
- [ ] Implement AC1 — **Given** cards are visible **When** I view a card **Then** I see title, 1–2 line description, expected time, and actions: Do this, New suggestion, Save, Hide. (AC: #1)
- [ ] Implement AC2 — **And** buttons are large, warm copy; no streaks or guilt. (AC: #2)

## Dev Notes
- Tech notes: SwiftUI cards; action handlers wired; safe haptics; accessibility labels; respects theme; keep card layout aligned to architecture UI stack (SwiftUI + async/await).
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
- docs/sprint-artifacts/2-6-suggestion-card-presentation-fields-actions.context.xml

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
