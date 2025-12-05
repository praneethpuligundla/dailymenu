# Story 3.4: Category navigation and filters (FR8–FR9)

Status: ready-for-dev

## Story
As a user, I want to browse by menu categories, So that I can explore activities that fit my mood.

## Acceptance Criteria
1. **Given** the library or favorites **When** I filter by Starters/Mains/Desserts/Connection/Low-Battery **Then** lists/cards show only matching items with tag chips intact.

## Tasks / Subtasks
- [ ] Implement AC1 — **Given** the library or favorites **When** I filter by Starters/Mains/Desserts/Connection/Low-Battery **Then** lists/cards show only matching items with tag chips intact. (AC: #1)

## Dev Notes
- Tech notes: Filter UI; reuse chips; ensure data tagged correctly from seed; store category counts for QA.
- Prerequisites: 3.1
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
- docs/sprint-artifacts/3-4-category-navigation-and-filters.context.xml

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
