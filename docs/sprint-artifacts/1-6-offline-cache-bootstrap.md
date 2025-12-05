# Story 1.6: Offline cache bootstrap

Status: review

## Story
As a user, I want the app to work after initial load without network, So that I can get suggestions anywhere.

## Acceptance Criteria
1. **Given** first run completes **When** device is offline **Then** seed data, preferences, favorites, hide list, and suggestions still function.
2. **And** a status indicator shows offline mode without blocking usage.

## Tasks / Subtasks
- [x] Implement AC1 - Core Data persists offline
- [x] Implement AC2 - Reachability monitoring

## Dev Agent Record

### Agent Model Used
- claude-sonnet-4-5-20250929

### Completion Notes
- Reachability.swift: Network status monitoring via NWPathMonitor
- Core Data (Story 1.2) already offline-first
- Seed data (Story 1.3) pre-loaded on first launch
- All core flows work offline: suggestions, favorites, hide, history

### File List
- Core/Network/Reachability.swift (new)
