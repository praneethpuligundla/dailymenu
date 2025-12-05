# Story 3.6: Library integrity and tagging QA (FR8–FR9)

Status: ready-for-dev

## Story
As a developer, I want validation for seed tags and categories, So that suggestions remain consistent.

## Acceptance Criteria
1. **Given** the seed and any updates **When** validation runs **Then** all activities have required tags (time, energy, context, category, repeatability) and category counts meet targets.

## Tasks / Subtasks
- [ ] Implement AC1 — **Given** the seed and any updates **When** validation runs **Then** all activities have required tags (time, energy, context, category, repeatability) and category counts meet targets. (AC: #1)

## Dev Notes
- Tech notes: QA script/test; log missing tags; prevent bad data ingest; integrate into CI; validate against architecture entity schema.
- Prerequisites: 1.3
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
- docs/sprint-artifacts/3-6-library-integrity-and-tagging-qa.context.xml

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
