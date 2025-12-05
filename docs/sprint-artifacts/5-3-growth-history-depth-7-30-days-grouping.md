# Story 5.3: Growth history depth (7–30 days grouping) (FR15 growth)

Status: ready-for-dev

## Story
As a user, I want grouped history (7–30 days) by day, So that I can review patterns over time.

## Acceptance Criteria
1. **Given** growth mode enabled **When** I open History **Then** entries are grouped by day across the chosen window with counts per day.

## Tasks / Subtasks
- [ ] Implement AC1 — **Given** growth mode enabled **When** I open History **Then** entries are grouped by day across the chosen window with counts per day. (AC: #1)

## Dev Notes
- Tech notes: Flag-gated; grouping by date; performance with paging if needed; ready for sync merge if enabled.
- Prerequisites: 5.2
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
- docs/sprint-artifacts/5-3-growth-history-depth-7-30-days-grouping.context.xml

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
