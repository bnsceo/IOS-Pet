import Foundation

public enum PetSpecies: String, Codable, CaseIterable, Sendable {
    case cat
    case dog
    case fox

    public var displayName: String {
        switch self {
        case .cat: "Cat"
        case .dog: "Dog"
        case .fox: "Fox"
        }
    }

    public var glyph: String {
        switch self {
        case .cat: "🐱"
        case .dog: "🐶"
        case .fox: "🦊"
        }
    }
}

public struct Pet: Codable, Hashable, Identifiable, Sendable {
    public let id: UUID
    public var name: String
    public var species: PetSpecies
    public var appearanceVariant: String
    public var level: Int
    public var xp: Int

    public init(
        id: UUID = UUID(),
        name: String,
        species: PetSpecies,
        appearanceVariant: String = "default",
        level: Int = 1,
        xp: Int = 0
    ) {
        self.id = id
        self.name = name
        self.species = species
        self.appearanceVariant = appearanceVariant
        self.level = level
        self.xp = xp
    }
}
