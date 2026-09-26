import Foundation

public final class PetStateStore: @unchecked Sendable {
    public static let appGroupID = "group.com.bnsceo.iospet"
    private static let storageKey = "live-pet.record.v1"

    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let lock = NSLock()

    public init(defaults: UserDefaults? = nil) {
        self.defaults = defaults ?? UserDefaults(suiteName: Self.appGroupID) ?? .standard
    }

    public func hasPet() -> Bool {
        lock.withLock { defaults.data(forKey: Self.storageKey) != nil }
    }

    public func createPet(name: String, species: PetSpecies, at date: Date = .now) -> PetRecord {
        let cleanedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let pet = Pet(name: cleanedName.isEmpty ? species.displayName : cleanedName, species: species)
        let record = PetRecord(
            pet: pet,
            state: PetState(lastInteractionDate: date, lastUpdatedDate: date)
        )
        save(record)
        return record
    }

    public func load(at date: Date = .now) -> PetRecord? {
        lock.withLock {
            guard let data = defaults.data(forKey: Self.storageKey),
                  let stored = try? decoder.decode(PetRecord.self, from: data) else {
                return nil
            }

            let advanced = PetRulesEngine.advance(stored, to: date)
            persistUnlocked(advanced)
            return advanced
        }
    }

    @discardableResult
    public func perform(_ action: PetAction, at date: Date = .now) -> PetRecord? {
        lock.withLock {
            guard let data = defaults.data(forKey: Self.storageKey),
                  let stored = try? decoder.decode(PetRecord.self, from: data) else {
                return nil
            }
            let updated = PetRulesEngine.apply(action, to: stored, at: date)
            persistUnlocked(updated)
            return updated
        }
    }

    public func save(_ record: PetRecord) {
        lock.withLock { persistUnlocked(record) }
    }

    public func reset() {
        lock.withLock { defaults.removeObject(forKey: Self.storageKey) }
    }

    private func persistUnlocked(_ record: PetRecord) {
        guard let data = try? encoder.encode(record) else { return }
        defaults.set(data, forKey: Self.storageKey)
    }
}
