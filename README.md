# IOS-Pet

Native iOS virtual pet experiment centered on the Dynamic Island.

> **Your pet lives around your phone instead of only inside an app.**

## Prototype 0.1 — Alive

The current implementation includes:

- 3 starter pets: cat, dog, fox
- pet naming and local persistence
- one shared authoritative pet state
- deterministic hunger/energy time progression
- Feed, Pet, and Wake actions
- SwiftUI pet home screen
- WidgetKit Home Screen widget
- ActivityKit Live Activity
- Dynamic Island compact, minimal, and expanded presentations
- App Intent controls from the Live Activity
- App Group storage for app/widget sharing
- Live Activity start, update, and end lifecycle
- Swift tests for the shared pet rules and persistence
- GitHub Actions for core tests and an iOS Simulator build

## Apple stack

- Swift
- SwiftUI
- ActivityKit
- WidgetKit
- App Intents
- App Groups
- local UserDefaults JSON persistence

V1 remains local-first. No backend, authentication service, AI API, analytics SDK, or subscription SDK is included.

## Source of truth

See [AGENT_HANDOFF.md](./AGENT_HANDOFF.md) for the controlling product and implementation specification.

## Verification status

Verified in the implementation environment:

- shared Swift package builds
- 6 shared pet-engine tests pass
- Xcode project file and plist/entitlement files parse successfully
- committed source files were re-fetched from `main` after the implementation commit

Still requires macOS/Xcode verification:

- full Xcode iOS target build
- iPhone Simulator launch
- Live Activity lifecycle
- Dynamic Island expanded/compact layout
- interactive Live Activity controls
- Home Screen widget state synchronization
- restart continuity in the actual iOS app
- physical-device behavior where Simulator support differs

The repository CI workflow is configured to run `swift test` and an iOS Simulator `xcodebuild` on pushes to `main`.
