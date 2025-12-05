# Story 1.1: App project setup and scaffolding

Status: review

## Story
As a developer, I want a SwiftUI iOS app project with core folders, build settings, and dependencies, So that all subsequent feature work sits on a clean, consistent foundation.

## Acceptance Criteria
1. **Given** a clean repo **When** I open the project **Then** I see SwiftUI lifecycle, target iOS 17, and feature-first folder structure as per architecture doc.
2. **And** shared utilities, theming constants, and feature flag stubs are present.
3. **And** build succeeds in Debug/Release without warnings.

## Tasks / Subtasks
- [x] Implement AC1 — **Given** a clean repo **When** I open the project **Then** I see SwiftUI lifecycle, target iOS 17, and feature-first folder structure as per architecture doc. (AC: #1)
- [x] Implement AC2 — **And** shared utilities, theming constants, and feature flag stubs are present. (AC: #2)
- [x] Implement AC3 — **And** build succeeds in Debug/Release without warnings. (AC: #3)

## Dev Notes
- Tech notes: Create SwiftUI App entry; enable Push/Background modes and App Groups (future widgets/shares); set min iOS 17; align folder layout per architecture doc (App, Core/Data, Core/AI, Core/Network, Features/*); add feature flag struct; include warm tone copy constants; set os_log categories; keep dependencies via SPM.
- Prerequisites: None
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
- docs/sprint-artifacts/1-1-app-project-setup-and-scaffolding.context.xml

### Agent Model Used
Codex (GPT-5)

### Debug Log References
- Scaffolded SwiftUI App entry (`App/DailyMenuApp.swift`) with AppDelegate hook and iOS 17 deployment target via `DailyMenu.xcodeproj`.
- Established feature-first folders and starter screens (`Features/Home/HomeView.swift`) plus core layers (`Core/*`) aligned to architecture doc.
- Added shared theme tokens, feature flag stubs, and logging categories for os_log.
- xcodebuild Debug/Release on iOS Simulator succeeded with code signing disabled (`CODE_SIGNING_ALLOWED=NO`).

### Completion Notes List
- Created initial DailyMenu SwiftUI project with feature-first structure, SwiftUI lifecycle, and architecture-aligned core folders.
- Included theme constants, feature flags, logging, and starter Home view to anchor future features.
- Verified Debug and Release simulator builds succeed (xcodebuild, signing disabled).

### File List
- App/DailyMenuApp.swift
- App/AppDelegate.swift
- App/Info.plist
- Core/FeatureFlags/FeatureFlags.swift
- Core/Theme/Theme.swift
- Core/Logging/Log.swift
- Core/Data/Models/Activity.swift
- Core/Network/APIClient.swift
- Core/AI/LocalGenerator.swift
- Core/Notifications/ReminderScheduler.swift
- Features/Home/HomeView.swift
- DailyMenu.xcodeproj/project.pbxproj

### Change Log
- Scaffolded SwiftUI iOS app with feature-first structure, theme/flags/logging; Debug/Release simulator builds succeed. (2025-11-29)
