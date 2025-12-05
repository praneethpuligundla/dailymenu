# Story 6.1: Data reset controls (FR16)

Status: ready-for-dev

## Story
As a user, I want to reset favorites/history/preferences, So that I can start fresh at any time.

## Acceptance Criteria
1. **Given** settings **When** I confirm a reset **Then** favorites, history, and prefs are cleared and seed data is reloaded.
2. **And** action is double-confirmed and undo is offered briefly.

## Tasks / Subtasks
- [ ] Implement AC1 — **Given** settings **When** I confirm a reset **Then** favorites, history, and prefs are cleared and seed data is reloaded. (AC: #1)
- [ ] Implement AC2 — **And** action is double-confirmed and undo is offered briefly. (AC: #2)

## Dev Notes
- Tech notes: Clear Core Data store except seed; secure wipe of Keychain tokens; warm messaging; re-run seed ingest; keep flags reset to defaults.
- Prerequisites: 3.1, 5.1
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
- docs/sprint-artifacts/6-1-data-reset-controls.context.xml

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
