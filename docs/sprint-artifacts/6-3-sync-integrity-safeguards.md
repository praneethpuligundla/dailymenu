# Story 6.3: Sync integrity safeguards (FR20)

Status: ready-for-dev

## Story
As a developer, I want sync-ready guards, So that if sync is enabled later, local state remains consistent.

## Acceptance Criteria
1. **Given** sync flag off by default **When** it is enabled **Then** merge logic preserves local favorites/history/hide with conflict resolution rules.
2. **And** tests cover out-of-order updates.

## Tasks / Subtasks
- [ ] Implement AC1 — **Given** sync flag off by default **When** it is enabled **Then** merge logic preserves local favorites/history/hide with conflict resolution rules. (AC: #1)
- [ ] Implement AC2 — **And** tests cover out-of-order updates. (AC: #2)

## Dev Notes
- Tech notes: Versioned records; simple ETag check; conflict policy: local wins unless newer server; audit trail for merges; retry/backoff; keep sync flag off by default.
- Prerequisites: 3.1, 5.1
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
- docs/sprint-artifacts/6-3-sync-integrity-safeguards.context.xml

### Agent Model Used

### Debug Log References

### Completion Notes List

### File List
