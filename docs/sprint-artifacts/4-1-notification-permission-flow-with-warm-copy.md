# Story 4.1: Notification permission flow with warm copy (FR17, FR21)

Status: ready-for-dev

## Story
As a user, I want a gentle prompt to opt in to reminders, So that I can choose re-engagement without pressure.

## Acceptance Criteria
1. **Given** the app after initial use **When** I see the reminder prompt **Then** copy is warm, optional, and explains value; system permission is requested only after intent.
2. **And** declining keeps the app usable; settings allow revisiting.

## Tasks / Subtasks
- [ ] Implement AC1 — **Given** the app after initial use **When** I see the reminder prompt **Then** copy is warm, optional, and explains value; system permission is requested only after intent. (AC: #1)
- [ ] Implement AC2 — **And** declining keeps the app usable; settings allow revisiting. (AC: #2)

## Dev Notes
- Tech notes: Two-step ask; UNUserNotificationCenter; no dark patterns; record choice; copy vetted for warm tone; defer system prompt until intent.
- Prerequisites: 1.4
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
- docs/sprint-artifacts/4-1-notification-permission-flow-with-warm-copy.context.xml

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
