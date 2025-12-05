# Story 1.3: Seeded activity library ingest (100+ items)

Status: review

## Story
As a user, I want a preloaded set of 100+ tagged activities, So that suggestions work instantly without network.

## Acceptance Criteria
1. **Given** first launch **When** the app initializes **Then** the seed JSON is parsed and stored locally with tags for time, energy, context, category, repeatability.
2. **And** categories cover Starters/Mains/Desserts/Connection/Low-Battery.
3. **And** a smoke test can query 3 random activities with tags present.

## Tasks / Subtasks
- [x] Implement AC1 — **Given** first launch **When** the app initializes **Then** the seed JSON is parsed and stored locally with tags for time, energy, context, category, repeatability. (AC: #1)
- [x] Implement AC2 — **And** categories cover Starters/Mains/Desserts/Connection/Low-Battery. (AC: #2)
- [x] Implement AC3 — **And** a smoke test can query 3 random activities with tags present. (AC: #3)

## Dev Notes
- Tech notes: Bundle seed JSON under Resources/Seed; idempotent ingest; guard against duplicates; log failures via os_log; ensure size stays lean; keep tag coverage aligned to categories.
- Prerequisites: 1.2
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
- docs/sprint-artifacts/1-3-seeded-activity-library-ingest-100-plus-items.context.xml

### Agent Model Used
- claude-sonnet-4-5-20250929

### Debug Log References
**Implementation Plan:**
1. Created Resources/Seed/activities.json with 110 activities across 5 categories
2. Created Core/Data/Persistence/SeedLoader.swift with idempotent ingest logic
3. Integrated seed loading into DailyMenuApp.swift init()
4. Created comprehensive smoke tests (11 test cases)
5. Implementation complete - requires adding new files to Xcode project target

### Completion Notes List
- Created activities.json with 110 warm, non-judgmental activities
- Distribution: 25 Starters (5-10min), 30 Mains (15-30min), 25 Desserts (30-60min), 15 Connection, 15 Low-Battery
- All activities follow PRD tone guidelines: no guilt/pressure, warm/validating language
- SeedLoader.swift implements idempotent loading using UserDefaults flag
- Deterministic UUID generation from string IDs ensures consistency across loads
- Duplicate detection prevents re-insertion on subsequent launches
- Graceful error handling with os_log integration
- Tags stored as JSON arrays for flexibility
- All activities marked source:"seed", moderationStatus:"approved"
- Integration with app launch via DailyMenuApp.swift init()
- Comprehensive test coverage: 11 test cases covering all 3 ACs
- Tests validate: 100+ activities, all 5 categories present, tag coverage, idempotency, energy/context variety
- **Manual step required:** Add new files to Xcode project target before building
  - Resources/Seed/activities.json
  - Core/Data/Persistence/SeedLoader.swift
  - Tests/Unit/SeedLoaderTests.swift

### File List
- Resources/Seed/activities.json (new)
- Core/Data/Persistence/SeedLoader.swift (new)
- App/DailyMenuApp.swift (modified - added seed loading)
- Tests/Unit/SeedLoaderTests.swift (new)
