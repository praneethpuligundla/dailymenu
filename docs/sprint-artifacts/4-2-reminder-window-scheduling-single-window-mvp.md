# Story 4.2: Reminder window scheduling (single window MVP) (FR17)

Status: ready-for-dev

## Story
As a user, I want to set one reminder window, So that I get a gentle nudge at a good time.

## Acceptance Criteria
1. **Given** I opted in **When** I pick a window **Then** a local notification schedules in that window with jitter to avoid sameness.
2. **And** turning it off cancels scheduled notifications.

## Tasks / Subtasks
- [ ] Implement AC1 — **Given** I opted in **When** I pick a window **Then** a local notification schedules in that window with jitter to avoid sameness. (AC: #1)
- [ ] Implement AC2 — **And** turning it off cancels scheduled notifications. (AC: #2)

## Dev Notes
- Tech notes: BackgroundTasks for scheduling; handle time zones; persistence in prefs; jitter send times; allow cancel/update; remote push path off by default.
- Prerequisites: 4.1
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
- docs/sprint-artifacts/4-2-reminder-window-scheduling-single-window-mvp.context.xml

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
