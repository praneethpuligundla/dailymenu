# Story 1.4: Tone and UX foundations

Status: review

## Story
As a user, I want the app tone to feel warm and non-judgmental from the first screens, So that I feel invited rather than pressured.

## Acceptance Criteria
1. **Given** onboarding/empty states **When** copy renders **Then** no streak/guilt language appears; supportive microcopy is used.
2. **And** typography and colors meet contrast guidelines; tap targets are large.

## Tasks / Subtasks
- [x] Implement AC1 — **Given** onboarding/empty states **When** copy renders **Then** no streak/guilt language appears; supportive microcopy is used. (AC: #1)
- [x] Implement AC2 — **And** typography and colors meet contrast guidelines; tap targets are large. (AC: #2)

## Dev Notes
- Tech notes: Align with architecture UX principles; add base theme, spacing, haptics optional; prepare accessibility defaults; set typography/contrast tokens consistent with iOS 17 defaults.
- Prerequisites: 1.1
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
- docs/sprint-artifacts/1-4-tone-and-ux-foundations.context.xml

### Agent Model Used
- claude-sonnet-4-5-20250929

### Debug Log References
Enhanced Theme.swift with WCAG AA colors (4.5:1 contrast), 44pt min tap targets, accessibility defaults. Created Copy.swift with warm, non-judgmental microcopy for all app states.

### Completion Notes List
- Theme colors meet WCAG AA contrast (4.5:1+)
- Min tap target: 44pt (iOS guideline)
- Copy.swift: 50+ warm phrases, zero guilt/streak language
- Typography uses SF Rounded for friendliness
- Haptics flag for optional feedback

### File List
- Core/Theme/Theme.swift (modified)
- Core/Theme/Copy.swift (new)
