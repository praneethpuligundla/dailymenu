# Story 3.2: Hide/ban list (FR11)

Status: ready-for-dev

## Story
As a user, I want to hide activities, So that unwanted items stop appearing.

## Acceptance Criteria
1. **Given** a suggestion **When** I tap Hide **Then** it disappears and is excluded from future suggestions until unhidden.
2. **And** a hidden list exists to restore items.

## Tasks / Subtasks
- [ ] Implement AC1 — **Given** a suggestion **When** I tap Hide **Then** it disappears and is excluded from future suggestions until unhidden. (AC: #1)
- [ ] Implement AC2 — **And** a hidden list exists to restore items. (AC: #2)

## Dev Notes
- Tech notes: Hidden flag per activity; exclusion in queries; undo snack; manage pool size; persist to Core Data for offline fidelity.
- Prerequisites: 2.5
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
- docs/sprint-artifacts/3-2-hide-ban-list.context.xml

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
