# Story 4.5: Growth-ready second window toggle (FR17 growth)

Status: ready-for-dev

## Story
As a planner, I want the structure to add a second reminder window later, So that growth scope is straightforward.

## Acceptance Criteria
1. **Given** flags **When** second-window flag is enabled **Then** UI and scheduling support two windows with independent times.

## Tasks / Subtasks
- [ ] Implement AC1 — **Given** flags **When** second-window flag is enabled **Then** UI and scheduling support two windows with independent times. (AC: #1)

## Dev Notes
- Tech notes: Gate behind flag; reuse scheduling logic; keep UX simple.
- Prerequisites: 4.2
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
- docs/sprint-artifacts/4-5-growth-ready-second-window-toggle.context.xml

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
