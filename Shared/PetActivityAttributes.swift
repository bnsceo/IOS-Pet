#if canImport(ActivityKit)
import ActivityKit
import Foundation

public struct PetActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var petName: String
        public var species: PetSpecies
        public var appearanceVariant: String
        public var mood: PetMood
        public var hunger: Int
        public var energy: Int
        public var isSleeping: Bool

        public init(record: PetRecord) {
            petName = record.pet.name
            species = record.pet.species
            appearanceVariant = record.pet.appearanceVariant
            mood = record.state.mood
            hunger = Int(record.state.hunger.rounded())
            energy = Int(record.state.energy.rounded())
            isSleeping = record.state.isSleeping
        }
    }

    public var petID: UUID

    public init(petID: UUID) {
        self.petID = petID
    }
}
#endif
