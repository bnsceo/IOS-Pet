import Foundation
import Testing
@testable import PetCore

@Suite("Pet rules")
struct PetCoreTests {
    @Test("Elapsed time deterministically decays hunger and energy")
    func elapsedTimeDecay() {
        let start = Date(timeIntervalSince1970: 1_000_000)
        let record = PetRecord(
            pet: Pet(name: "Mochi", species: .cat),
            state: PetState(hunger: 80, energy: 80, lastInteractionDate: start, lastUpdatedDate: start)
        )

        let advanced = PetRulesEngine.advance(record, to: start.addingTimeInterval(2 * 3600))
        #expect(advanced.state.hunger == 76)
        #expect(advanced.state.energy == 77.5)
        #expect(advanced.state.mood == .idle)
    }

    @Test("Low hunger resolves hungry state")
    func hungryState() {
        let start = Date(timeIntervalSince1970: 1_000_000)
        let record = PetRecord(
            pet: Pet(name: "Mochi", species: .cat),
            state: PetState(hunger: 26, energy: 80, lastInteractionDate: start, lastUpdatedDate: start)
        )

        let advanced = PetRulesEngine.advance(record, to: start.addingTimeInterval(3600))
        #expect(advanced.state.hunger == 24)
        #expect(advanced.state.mood == .hungry)
    }

    @Test("Feeding raises hunger and makes the pet happy")
    func feed() {
        let start = Date(timeIntervalSince1970: 1_000_000)
        let record = PetRecord(
            pet: Pet(name: "Mochi", species: .cat),
            state: PetState(hunger: 30, energy: 80, lastInteractionDate: start, lastUpdatedDate: start)
        )

        let fed = PetRulesEngine.apply(.feed, to: record, at: start)
        #expect(fed.state.hunger == 55)
        #expect(fed.state.mood == .happy)
        #expect(fed.pet.xp == 2)
    }

    @Test("Very low energy transitions to sleeping")
    func autoSleep() {
        let start = Date(timeIntervalSince1970: 1_000_000)
        let record = PetRecord(
            pet: Pet(name: "Mochi", species: .cat),
            state: PetState(hunger: 80, energy: 9, lastInteractionDate: start, lastUpdatedDate: start)
        )

        let advanced = PetRulesEngine.advance(record, to: start.addingTimeInterval(3600))
        #expect(advanced.state.isSleeping)
        #expect(advanced.state.mood == .sleeping)
    }

    @Test("Wake exits sleeping state and restores minimum usable energy")
    func wake() {
        let start = Date(timeIntervalSince1970: 1_000_000)
        let record = PetRecord(
            pet: Pet(name: "Mochi", species: .cat),
            state: PetState(mood: .sleeping, hunger: 80, energy: 10, isSleeping: true, lastInteractionDate: start, lastUpdatedDate: start)
        )

        let awake = PetRulesEngine.apply(.wake, to: record, at: start)
        #expect(!awake.state.isSleeping)
        #expect(awake.state.energy == 20)
        #expect(awake.state.mood == .sleepy)
    }

    @Test("Store persists one authoritative pet record")
    func persistence() throws {
        let suite = "PetCoreTests.\(UUID().uuidString)"
        let defaults = try #require(UserDefaults(suiteName: suite))
        defer { defaults.removePersistentDomain(forName: suite) }

        let store = PetStateStore(defaults: defaults)
        let created = store.createPet(name: "Nova", species: .fox, at: Date(timeIntervalSince1970: 1_000_000))
        let loaded = try #require(store.load(at: Date(timeIntervalSince1970: 1_000_000)))

        #expect(created.pet.id == loaded.pet.id)
        #expect(loaded.pet.name == "Nova")
        #expect(loaded.pet.species == .fox)
    }
}
