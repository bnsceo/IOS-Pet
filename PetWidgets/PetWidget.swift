import SwiftUI
import WidgetKit

struct PetWidgetEntry: TimelineEntry {
    let date: Date
    let record: PetRecord
}

struct PetWidgetProvider: TimelineProvider {
    private let store = PetStateStore()

    func placeholder(in context: Context) -> PetWidgetEntry {
        PetWidgetEntry(date: .now, record: Self.placeholderRecord)
    }

    func getSnapshot(in context: Context, completion: @escaping (PetWidgetEntry) -> Void) {
        completion(PetWidgetEntry(date: .now, record: store.load() ?? Self.placeholderRecord))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<PetWidgetEntry>) -> Void) {
        let now = Date()
        let record = store.load(at: now) ?? Self.placeholderRecord
        let entry = PetWidgetEntry(date: now, record: record)
        completion(Timeline(entries: [entry], policy: .after(now.addingTimeInterval(15 * 60))))
    }

    static let placeholderRecord = PetRecord(
        pet: Pet(name: "Mochi", species: .cat),
        state: PetState(hunger: 78, energy: 64)
    )
}

struct PetWidget: Widget {
    let kind = "PetWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PetWidgetProvider()) { entry in
            PetWidgetView(entry: entry)
                .containerBackground(for: .widget) {
                    LinearGradient(
                        colors: [Color.indigo.opacity(0.75), Color.black],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
        }
        .configurationDisplayName("Live Pet")
        .description("Keep your pet close on the Home Screen.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

private struct PetWidgetView: View {
    let entry: PetWidgetEntry
    @Environment(\.widgetFamily) private var family

    var body: some View {
        if family == .systemSmall {
            VStack(spacing: 6) {
                Text(entry.record.pet.species.glyph)
                    .font(.system(size: 58))
                Text(entry.record.pet.name)
                    .font(.headline)
                    .lineLimit(1)
                Text(entry.record.state.mood.displayName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                HStack(spacing: 10) {
                    Label("\(Int(entry.record.state.hunger))", systemImage: "fork.knife")
                    Label("\(Int(entry.record.state.energy))", systemImage: "bolt.fill")
                }
                .font(.caption2.monospacedDigit())
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            HStack(spacing: 16) {
                Text(entry.record.pet.species.glyph)
                    .font(.system(size: 72))
                VStack(alignment: .leading, spacing: 8) {
                    Text(entry.record.pet.name)
                        .font(.title3.bold())
                    Text(entry.record.state.mood.displayName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    WidgetStat(label: "Hunger", value: entry.record.state.hunger)
                    WidgetStat(label: "Energy", value: entry.record.state.energy)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
    }
}

private struct WidgetStat: View {
    let label: String
    let value: Double

    var body: some View {
        HStack(spacing: 8) {
            Text(label)
                .font(.caption2.weight(.semibold))
                .frame(width: 42, alignment: .leading)
            ProgressView(value: value, total: 100)
            Text("\(Int(value.rounded()))")
                .font(.caption2.monospacedDigit())
                .frame(width: 24, alignment: .trailing)
        }
    }
}
