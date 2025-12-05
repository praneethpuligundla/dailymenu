# Story 2.7: Card expand with micro-steps and tags (FR7)

Status: ready-for-dev

## Story
As a user, I want to expand a card to see micro-steps and tags, So that I know what to do and why it fits me.

## Acceptance Criteria
1. **Given** a card **When** I expand it **Then** I see up to three micro-steps and chips for time, energy, context, category.
2. **And** collapse/expand is smooth; state persists per card during session.

## Tasks / Subtasks
- [ ] Implement AC1 — **Given** a card **When** I expand it **Then** I see up to three micro-steps and chips for time, energy, context, category. (AC: #1)
- [ ] Implement AC2 — **And** collapse/expand is smooth; state persists per card during session. (AC: #2)

## Dev Notes
- Tech notes: Disclosure pattern; animation at 60fps; dynamic type support; chips reuse theme tokens.
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
- docs/sprint-artifacts/2-7-card-expand-with-micro-steps-and-tags.context.xml

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
