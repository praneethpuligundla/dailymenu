# Story 6.5: Accessibility and copy audit (FR21–FR22)

Status: ready-for-dev

## Story
As a user, I want the app to be accessible and warm, So that it welcomes all users without pressure.

## Acceptance Criteria
1. **Given** the UI and copy **When** audited **Then** it passes contrast/tap target checks and contains no streak/leaderboard language.
2. **And** VoiceOver reads controls meaningfully; dynamic type respected.

## Tasks / Subtasks
- [ ] Implement AC1 — **Given** the UI and copy **When** audited **Then** it passes contrast/tap target checks and contains no streak/leaderboard language. (AC: #1)
- [ ] Implement AC2 — **And** VoiceOver reads controls meaningfully; dynamic type respected. (AC: #2)

## Dev Notes
- Tech notes: WCAG 2.1 AA checks; accessibility labels; string lint for tone.
- Prerequisites: 2.8
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
- docs/sprint-artifacts/6-5-accessibility-and-copy-audit.context.xml

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
