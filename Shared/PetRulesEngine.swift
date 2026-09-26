import Foundation

public enum PetRulesEngine {
    public static let hungerDecayPerHour = 2.0
    public static let awakeEnergyDecayPerHour = 1.25
    public static let sleepingEnergyRecoveryPerHour = 8.0

    public static func advance(_ record: PetRecord, to date: Date) -> PetRecord {
        guard date > record.state.lastUpdatedDate else { return record }

        var updated = record
        let elapsedHours = date.timeIntervalSince(updated.state.lastUpdatedDate) / 3600

        updated.state.hunger = clamp(
            updated.state.hunger - hungerDecayPerHour * elapsedHours
        )

        if updated.state.isSleeping {
            updated.state.energy = clamp(
                updated.state.energy + sleepingEnergyRecoveryPerHour * elapsedHours
            )
        } else {
            updated.state.energy = clamp(
                updated.state.energy - awakeEnergyDecayPerHour * elapsedHours
            )
            if updated.state.energy <= 8 {
                updated.state.isSleeping = true
            }
        }

        updated.state.lastUpdatedDate = date
        resolveMood(&updated, at: date)
        return updated
    }

    public static func apply(_ action: PetAction, to record: PetRecord, at date: Date) -> PetRecord {
        var updated = advance(record, to: date)

        switch action {
        case .feed:
            updated.state.hunger = clamp(updated.state.hunger + 25)
            updated.state.happyUntil = date.addingTimeInterval(15 * 60)
            updated.pet.xp += 2
        case .pet:
            updated.state.happyUntil = date.addingTimeInterval(10 * 60)
            updated.pet.xp += 1
        case .wake:
            if updated.state.isSleeping {
                updated.state.isSleeping = false
                updated.state.energy = max(updated.state.energy, 20)
                updated.state.happyUntil = date.addingTimeInterval(5 * 60)
            }
        }

        updated.state.lastInteractionDate = date
        updated.state.lastUpdatedDate = date
        resolveLevel(&updated)
        resolveMood(&updated, at: date)
        return updated
    }

    public static func resolveMood(_ record: inout PetRecord, at date: Date) {
        if record.state.isSleeping {
            record.state.mood = .sleeping
        } else if record.state.hunger <= 25 {
            record.state.mood = .hungry
        } else if record.state.energy <= 30 {
            record.state.mood = .sleepy
        } else if let happyUntil = record.state.happyUntil, happyUntil > date {
            record.state.mood = .happy
        } else {
            record.state.happyUntil = nil
            record.state.mood = .idle
        }
    }

    private static func resolveLevel(_ record: inout PetRecord) {
        let level = max(1, record.pet.xp / 100 + 1)
        record.pet.level = level
    }

    private static func clamp(_ value: Double) -> Double {
        min(100, max(0, value))
    }
}
