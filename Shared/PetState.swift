import Foundation

public enum PetMood: String, Codable, CaseIterable, Sendable {
    case idle
    case happy
    case hungry
    case sleepy
    case sleeping

    public var displayName: String { rawValue.capitalized }
}

public enum PetAction: Sendable {
    case feed
    case pet
    case wake
}

public struct PetState: Codable, Hashable, Sendable {
    public var mood: PetMood
    public var hunger: Double
    public var energy: Double
    public var isSleeping: Bool
    public var lastInteractionDate: Date
    public var lastUpdatedDate: Date
    public var happyUntil: Date?

    public init(
        mood: PetMood = .idle,
        hunger: Double = 80,
        energy: Double = 80,
        isSleeping: Bool = false,
        lastInteractionDate: Date = .now,
        lastUpdatedDate: Date = .now,
        happyUntil: Date? = nil
    ) {
        self.mood = mood
        self.hunger = hunger
        self.energy = energy
        self.isSleeping = isSleeping
        self.lastInteractionDate = lastInteractionDate
        self.lastUpdatedDate = lastUpdatedDate
        self.happyUntil = happyUntil
    }
}

public struct PetRecord: Codable, Hashable, Sendable {
    public var pet: Pet
    public var state: PetState

    public init(pet: Pet, state: PetState) {
        self.pet = pet
        self.state = state
    }
}
