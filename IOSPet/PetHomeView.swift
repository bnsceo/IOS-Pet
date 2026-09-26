import SwiftUI

struct PetHomeView: View {
    @ObservedObject var model: PetViewModel

    var body: some View {
        if let record = model.record {
            ZStack {
                LinearGradient(
                    colors: [Color.black, moodColor(record).opacity(0.55)],
                    startPoint: .top,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 22) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(record.pet.name)
                                    .font(.largeTitle.bold())
                                Text(record.state.mood.displayName)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("LV \(record.pet.level)")
                                    .font(.headline.monospacedDigit())
                                Text("\(record.pet.xp) XP")
                                    .font(.caption.monospacedDigit())
                                    .foregroundStyle(.secondary)
                            }
                        }

                        ZStack(alignment: .bottom) {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .frame(width: 230, height: 230)

                            Text(record.pet.species.glyph)
                                .font(.system(size: 140))
                                .offset(y: record.state.isSleeping ? 14 : 0)

                            if record.state.isSleeping {
                                Text("z Z")
                                    .font(.title2.bold())
                                    .offset(x: 82, y: -155)
                            }
                        }
                        .frame(height: 250)

                        VStack(spacing: 14) {
                            StatRow(label: "Hunger", symbol: "fork.knife", value: record.state.hunger)
                            StatRow(label: "Energy", symbol: "bolt.fill", value: record.state.energy)
                        }
                        .padding(18)
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous))

                        HStack(spacing: 12) {
                            ActionButton(title: "Feed", systemImage: "fork.knife") { model.feed() }
                            ActionButton(title: "Pet", systemImage: "hand.tap.fill") { model.pet() }
                            if record.state.isSleeping {
                                ActionButton(title: "Wake", systemImage: "sun.max.fill") { model.wake() }
                            }
                        }

                        Button {
                            model.isLiveActivityActive ? model.endLivePet() : model.startLivePet()
                        } label: {
                            Label(
                                model.isLiveActivityActive ? "End Live Pet" : "Start Live Pet",
                                systemImage: model.isLiveActivityActive ? "stop.circle.fill" : "sparkles"
                            )
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(model.isLiveActivityActive ? .red : .mint)

                        if let message = model.liveActivityMessage {
                            Text(message)
                                .font(.footnote)
                                .foregroundStyle(.orange)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(20)
                }
            }
            .foregroundStyle(.white)
        }
    }

    private func moodColor(_ record: PetRecord) -> Color {
        switch record.state.mood {
        case .idle: .indigo
        case .happy: .mint
        case .hungry: .orange
        case .sleepy, .sleeping: .blue
        }
    }
}

private struct StatRow: View {
    let label: String
    let symbol: String
    let value: Double

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: symbol)
                .frame(width: 24)
            Text(label)
                .font(.subheadline.weight(.semibold))
                .frame(width: 58, alignment: .leading)
            ProgressView(value: value, total: 100)
                .tint(value < 30 ? .orange : .mint)
            Text("\(Int(value.rounded()))")
                .font(.caption.monospacedDigit())
                .frame(width: 28, alignment: .trailing)
        }
    }
}

private struct ActionButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.subheadline.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
        }
        .buttonStyle(.bordered)
        .tint(.white)
    }
}
