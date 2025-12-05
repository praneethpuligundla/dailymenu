# Story 2.2: Energy selection (FR2)

Status: ready-for-dev

## Story
As a user, I want to choose my energy level (Low, Okay, Up for something), So that suggestions fit my current energy.

## Acceptance Criteria
1. **Given** the home screen **When** I pick an energy level **Then** it is active and combined with time for filtering.
2. **And** copy is warm (no shame language); accessible labels present.

## Tasks / Subtasks
- [ ] Implement AC1 — **Given** the home screen **When** I pick an energy level **Then** it is active and combined with time for filtering. (AC: #1)
- [ ] Implement AC2 — **And** copy is warm (no shame language); accessible labels present. (AC: #2)

## Dev Notes
- Tech notes: Chips with semantic colors; state stored with time selection; default to low friction choice.
- Prerequisites: 2.1
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
- docs/sprint-artifacts/2-2-energy-selection.context.xml

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
