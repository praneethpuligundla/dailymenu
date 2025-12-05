# Story 3.1: Favorites save and list (FR10)

Status: ready-for-dev

## Story
As a user, I want to favorite/unfavorite activities and view them, So that I can return to what I like.

## Acceptance Criteria
1. **Given** a suggestion card **When** I tap Save **Then** the item is added to Favorites and reflected in the favorites list and card state.
2. **And** the favorites list is filterable by category and accessible offline.

## Tasks / Subtasks
- [ ] Implement AC1 — **Given** a suggestion card **When** I tap Save **Then** the item is added to Favorites and reflected in the favorites list and card state. (AC: #1)
- [ ] Implement AC2 — **And** the favorites list is filterable by category and accessible offline. (AC: #2)

## Dev Notes
- Tech notes: Persist Favorite entity in Core Data; toggle UI state; list view with filters; sync-ready model; store timestamps for future rotation/sync.
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
- docs/sprint-artifacts/3-1-favorites-save-and-list.context.xml

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
