# Story 6.4: Performance and stability hardening

Status: ready-for-dev

## Story
As a developer, I want to ensure fast loads and smooth interactions, So that the experience stays instant and calm.

## Acceptance Criteria
1. **Given** standard devices **When** navigating home and loading suggestions **Then** launch-to-suggestions stays within target; list scrolling is smooth; no crashes in soak test.

## Tasks / Subtasks
- [ ] Implement AC1 — **Given** standard devices **When** navigating home and loading suggestions **Then** launch-to-suggestions stays within target; list scrolling is smooth; no crashes in soak test. (AC: #1)

## Dev Notes
- Tech notes: Instrument metrics (os_log, signposts); fix hot paths; memory profiling; lightweight images; soak tests on target devices.
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
- docs/sprint-artifacts/6-4-performance-and-stability-hardening.context.xml

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
