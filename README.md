# IOS-Pet

Native iOS virtual pet experiment centered on the Dynamic Island.

> **Your pet lives around your phone instead of only inside an app.**

## Prototype 0.1 — Alive

The first milestone is one complete vertical slice:

- create/select one pet
- persist pet state locally
- start a Live Activity
- render the pet in supported Dynamic Island presentations
- show the expanded Live Activity
- feed the pet from a supported Live Activity control
- synchronize the updated state with the main app and widget
- preserve pet continuity across app restarts and Live Activity restarts

## Intended Apple stack

- Swift
- SwiftUI
- ActivityKit
- WidgetKit
- App Intents
- SwiftData where appropriate
- App Groups where shared app/widget state requires them

V1 is local-first. No backend, authentication service, AI API, analytics SDK, or subscription SDK is required for Prototype 0.1.

## Source of truth

See [AGENT_HANDOFF.md](./AGENT_HANDOFF.md) for the controlling product and implementation specification.

## Current status

Repository initialized. The Xcode app implementation has **not** been created, built, run, or verified yet.
