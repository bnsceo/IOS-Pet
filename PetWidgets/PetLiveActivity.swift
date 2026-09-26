import ActivityKit
import AppIntents
import SwiftUI
import WidgetKit

struct PetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PetActivityAttributes.self) { context in
            PetLockScreenView(state: context.state)
                .activityBackgroundTint(Color.black.opacity(0.9))
                .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    PetIslandGlyph(state: context.state, size: 42)
                        .padding(.leading, 4)
                }

                DynamicIslandExpandedRegion(.center) {
                    VStack(spacing: 2) {
                        Text(context.state.petName)
                            .font(.headline)
                            .lineLimit(1)
                        Text(context.state.mood.displayName)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing, spacing: 4) {
                        Label("\(context.state.hunger)", systemImage: "fork.knife")
                        Label("\(context.state.energy)", systemImage: "bolt.fill")
                    }
                    .font(.caption.monospacedDigit())
                }

                DynamicIslandExpandedRegion(.bottom) {
                    PetLiveActions(state: context.state)
                        .padding(.top, 4)
                }
            } compactLeading: {
                PetIslandGlyph(state: context.state, size: 20)
            } compactTrailing: {
                Image(systemName: context.state.isSleeping ? "moon.zzz.fill" : "heart.fill")
                    .foregroundStyle(context.state.isSleeping ? .blue : .pink)
            } minimal: {
                Text(context.state.species.glyph)
                    .font(.system(size: 16))
            }
            .keylineTint(.mint)
        }
    }
}

private struct PetLockScreenView: View {
    let state: PetActivityAttributes.ContentState

    var body: some View {
        HStack(spacing: 14) {
            PetIslandGlyph(state: state, size: 54)

            VStack(alignment: .leading, spacing: 5) {
                Text(state.petName)
                    .font(.headline)
                Text(state.mood.displayName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                HStack(spacing: 12) {
                    Label("\(state.hunger)", systemImage: "fork.knife")
                    Label("\(state.energy)", systemImage: "bolt.fill")
                }
                .font(.caption.monospacedDigit())
            }

            Spacer(minLength: 8)
            PetLiveActions(state: state, compact: true)
        }
        .padding()
    }
}

private struct PetIslandGlyph: View {
    let state: PetActivityAttributes.ContentState
    let size: CGFloat

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Text(state.species.glyph)
                .font(.system(size: size))
                .offset(y: state.isSleeping ? 3 : 0)
            if !state.isSleeping && size > 24 {
                Text("🐾")
                    .font(.system(size: size * 0.32))
                    .offset(x: size * 0.15, y: size * 0.12)
            }
        }
        .accessibilityLabel("\(state.petName), \(state.mood.displayName)")
    }
}

private struct PetLiveActions: View {
    let state: PetActivityAttributes.ContentState
    var compact = false

    var body: some View {
        HStack(spacing: compact ? 6 : 10) {
            Button(intent: FeedPetIntent()) {
                Image(systemName: "fork.knife")
                    .frame(width: compact ? 30 : 38, height: compact ? 30 : 34)
            }
            .buttonStyle(.bordered)
            .tint(.orange)

            Button(intent: PetPetIntent()) {
                Image(systemName: "hand.tap.fill")
                    .frame(width: compact ? 30 : 38, height: compact ? 30 : 34)
            }
            .buttonStyle(.bordered)
            .tint(.pink)

            if state.isSleeping {
                Button(intent: WakePetIntent()) {
                    Image(systemName: "sun.max.fill")
                        .frame(width: compact ? 30 : 38, height: compact ? 30 : 34)
                }
                .buttonStyle(.bordered)
                .tint(.yellow)
            }
        }
    }
}
