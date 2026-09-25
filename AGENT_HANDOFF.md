# AGENT HANDOFF — Live Pet iOS App

## Mission

Build a native iOS app that makes a virtual pet feel like it lives around the user’s phone, with the Dynamic Island as its primary persistent surface.

Core product idea:

> **Your pet lives around your phone instead of only inside an app.**

The first build must prove that experience before expanding into a larger virtual-pet game.

---

## Product Definition

The app lets a user:

1. Choose a starter pet.
2. Name the pet.
3. See the pet inside the main app.
4. Activate a Live Activity.
5. See the same pet represented in the Dynamic Island.
6. Long-press the Dynamic Island to open the expanded Live Activity.
7. Interact with the pet through supported Live Activity controls.
8. See the same pet state reflected in widgets and the main app.
9. Return later and find the pet state preserved.

The pet should feel present even while the main app is closed.

---

## V1 Scope

### Starter pets

Provide 3 starter pets.

Initial implementation may use simple temporary art or vector/SF Symbol placeholders if final assets do not exist yet, but the architecture must support replacing them with real pet assets without rewriting the pet system.

Each pet must have:

- id
- name
- species
- appearanceVariant
- mood
- hunger
- energy
- level
- xp
- lastInteractionDate

---

## Initial Pet States

V1 behavior states:

- idle
- blink
- happy
- hungry
- sleepy
- sleeping

State changes should be deterministic and driven by pet data rather than random UI-only animation.

Suggested rules:

- Hunger gradually decreases over time.
- Energy gradually decreases over time.
- Low hunger produces hungry.
- Low energy produces sleepy.
- Very low energy can produce sleeping.
- Feeding raises hunger and may set happy.
- Petting temporarily increases happiness / changes mood.

Do not implement death in V1.

If neglected, the pet becomes unhappy, hungry, or sleepy but does not permanently die.

---

## Required Interactions

V1 actions:

- Feed
- Pet
- Wake

### Feed

- increases hunger value
- updates mood when appropriate
- updates all surfaces

### Pet

- produces a happy response
- updates mood
- updates all surfaces

### Wake

- exits sleeping state when allowed
- updates energy/mood according to the game rules
- updates all surfaces

---

## Dynamic Island Experience

The Dynamic Island is the defining feature.

Do not treat it as a generic text status pill.

The pet should visually appear to interact with the Island where technically possible.

Design direction examples:

- pet peeking over the Island
- paws hanging below the Island
- sleeping pet resting against the Island
- hungry pet looking toward a food icon
- excited pet appearing to pop out from one side

The compact presentation should be immediately recognizable as a pet.

The expanded presentation should include:

- pet artwork
- pet name
- mood
- hunger
- energy
- Feed action
- Pet action
- Wake action when applicable

Use ActivityKit / WidgetKit / App Intents as appropriate.

Respect current public iOS APIs and Apple platform restrictions.

Do not attempt to create an unrestricted system-wide overlay.

---

## Widget Experience

Provide at least one widget using the same pet state.

The widget should show:

- pet
- pet name
- mood
- hunger
- energy

The widget and Live Activity must use the same source of truth as the main app.

Do not maintain separate duplicated pet-state implementations.

---

## Main App

The initial app should contain:

### Onboarding

- choose pet
- name pet
- finish setup

### Pet Home

Show:

- pet
- name
- current mood
- hunger
- energy
- level
- XP
- Feed
- Pet
- Wake when appropriate
- button/control to start the Live Activity

The main app may include a simple starter room, but room decoration is not a V1 priority.

---

## Technical Direction

Use native Apple technologies.

Preferred stack:

- Swift
- SwiftUI
- ActivityKit
- WidgetKit
- App Intents
- SwiftData where appropriate
- App Groups for shared app/widget state where required

Avoid adding infrastructure that is unnecessary for V1.

Do not add:

- Supabase
- Firebase
- Convex
- custom backend
- authentication service
- AI API
- analytics SDK
- subscription SDK

unless an actual V1 requirement appears that cannot be solved locally.

V1 should be local-first.

---

## State Architecture

There must be one authoritative pet model.

Recommended conceptual structure:

```swift
Pet
PetState
PetStateStore
PetRulesEngine
LiveActivityManager
```

Responsibilities:

### Pet

Persistent identity and progression.

### PetState

Current dynamic values:

- mood
- hunger
- energy
- sleeping state
- timestamps

### PetStateStore

Single source of truth for persistence and shared state.

### PetRulesEngine

Calculates state changes from elapsed time and user actions.

### LiveActivityManager

Starts, updates, and ends the pet Live Activity.

Do not embed game logic independently inside widgets or Live Activity views.

---

## Time-Based Behavior

The pet must react to elapsed real-world time.

Do not rely on an always-running background timer.

When the app/widget/activity gets an opportunity to refresh:

1. Load previous pet state.
2. Read the previous update timestamp.
3. Calculate elapsed time.
4. Apply hunger/energy decay.
5. Resolve resulting mood/state.
6. Save updated state.
7. Render the result.

This keeps the model deterministic and compatible with iOS background limitations.

---

## Live Activity Lifecycle

The implementation must acknowledge that Live Activities are system-managed and cannot behave like a permanent unrestricted overlay.

The product should gracefully handle Live Activity expiration/end.

Expected behavior:

- If no Live Activity is active, the main app shows a clear Start Live Pet action.
- Ending a Live Activity must not reset or delete the pet.
- Starting a new Live Activity must resume from the current persisted pet state.

The pet itself is persistent.

The Live Activity is only one presentation surface.

---

## Visual Direction

Target feeling:

- charming
- expressive
- polished
- minimal
- recognizable at very small sizes

Avoid:

- generic dashboard UI
- excessive text
- enterprise-style cards
- overly complicated stat screens
- fake 3D
- clutter around the Dynamic Island

The pet must remain the visual focus.

---

## Future Product Direction — NOT V1

Do not build these yet, but preserve architectural room for them:

- more pets
- pet evolution
- accessories
- rooms
- toys
- minigames
- habitats
- wallpaper packs
- matching Home Screen environments
- streaks
- achievements
- premium pets
- cosmetic purchases
- cloud sync
- account sync
- social features
- pet sharing
- Apple Watch extensions

These are future opportunities, not current requirements.

---

## Monetization Direction — Future

The base pet experience should remain usable for free.

Potential future paid content:

- premium pet species
- cosmetic packs
- accessories
- room themes
- habitats
- wallpaper/widget packs
- premium customization

Do not build monetization in the first technical prototype.

---

## Non-Goals

Do not turn this into:

- a full Tamagotchi clone
- a social network
- an AI chatbot pet
- a multiplayer game
- a cloud-first app
- a large RPG
- a marketplace
- a complicated economy

The first milestone is much smaller.

---

## First Milestone

### Prototype 0.1 — Alive

Build one complete vertical slice:

1. Launch app.
2. Create/select one pet.
3. Persist pet state.
4. Start Live Activity.
5. Show pet in Dynamic Island.
6. Long-press to show expanded activity.
7. Display:
   - pet
   - name
   - hunger
   - energy
8. Tap Feed.
9. Pet state changes.
10. Main app reflects the same updated state.
11. Widget reflects the same updated state.

This is the first proof that matters.

---

## Acceptance Criteria

Prototype 0.1 is complete only when all of the following are verified:

- App launches successfully on a supported iPhone target.
- Pet can be created or selected.
- Pet name persists after app restart.
- Pet state persists after app restart.
- Live Activity can be started from the app.
- Pet appears correctly in supported Dynamic Island presentations.
- Expanded Live Activity renders correctly.
- Feed interaction changes the pet state.
- The changed state appears in the main app.
- The same state is used by the widget.
- Ending/restarting the Live Activity does not reset the pet.
- No unnecessary backend dependency exists.
- No duplicate independent pet-state stores exist.
- No critical layout clipping occurs in tested Dynamic Island states.
- Build succeeds without unresolved warnings caused by project configuration.
- Actual requested behavior is tested, not merely compiled.

---

## Verification Requirements

Before reporting completion:

1. Build the actual Xcode project.
2. Run it on an iPhone simulator/device configuration that supports the relevant presentation.
3. Verify the normal app flow.
4. Verify state persistence.
5. Verify Live Activity start/update/end behavior.
6. Verify expanded Dynamic Island layout.
7. Verify widget state consistency.
8. Reopen the app and verify pet continuity.
9. Record any platform behavior that cannot be fully validated in Simulator and requires a physical device.

Do not claim a feature works merely because the code compiles.

---

## Implementation Rules

- Inspect existing project files before changing them.
- Preserve working code not related to this feature.
- Do not invent requirements beyond this handoff.
- Treat future ideas as proposed, not approved.
- Prefer the smallest architecture that supports the product correctly.
- Do not add third-party dependencies without a demonstrated need.
- Keep the pet model independent from presentation surfaces.
- Use current Apple public APIs.
- If an iOS limitation conflicts with the concept, preserve the product intent and implement the closest supported behavior.
- Document any unavoidable compromise.
- Do not fake Dynamic Island behavior using screenshots or in-app mockups and call it implemented.

---

## Product Principle

Every major implementation decision should support this feeling:

> **The pet is part of the phone, not merely a character inside an app.**

If a feature does not strengthen that feeling or support the first working vertical slice, defer it.

---

## Agent Execution Order

1. Inspect repository/project.
2. Confirm deployment target and supported devices.
3. Establish shared pet model and persistence.
4. Build basic main-app pet screen.
5. Add Widget Extension.
6. Add Live Activity.
7. Implement Dynamic Island layouts.
8. Implement shared actions.
9. Wire time-based pet state rules.
10. Verify cross-surface synchronization.
11. Test restart and Live Activity lifecycle.
12. Fix defects found during verification.
13. Report:
    - implemented
    - tested
    - device/simulator tested
    - limitations
    - remaining work

---

## Do Not Expand Scope

If the first vertical slice is not working, do not move on to cosmetics, shops, evolution, AI, cloud sync, or additional game systems.

First make the pet feel alive on the phone.
