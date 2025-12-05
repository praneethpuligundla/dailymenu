# Story 1.5: Feature flags and guardrails

Status: review

## Story
As a developer, I want feature flags and safety guardrails, So that experimental online features (LLM, sync) can be toggled safely.

## Acceptance Criteria
1. **Given** app settings/remote config defaults **When** flags are toggled **Then** AI/cloud paths stay off by default and require explicit opt-in.
2. **And** code paths are stubbed without crashing when disabled.

## Tasks / Subtasks
- [x] Implement AC1
- [x] Implement AC2

## Dev Agent Record

### Agent Model Used
- claude-sonnet-4-5-20250929

### Completion Notes List
- All cloud/AI flags default to false
- Safe defaults prevent unintended network calls
- Documentation added to each flag
- Bootstrap pattern ready for remote config

### File List
- Core/FeatureFlags/FeatureFlags.swift (modified)
