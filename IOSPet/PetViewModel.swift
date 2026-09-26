import ActivityKit
import Foundation
import SwiftUI
import WidgetKit

@MainActor
final class PetViewModel: ObservableObject {
    @Published private(set) var record: PetRecord?
    @Published private(set) var isLiveActivityActive = false
    @Published var liveActivityMessage: String?

    private let store: PetStateStore
    private let liveActivityManager: LiveActivityManager

    init(
        store: PetStateStore = PetStateStore(),
        liveActivityManager: LiveActivityManager = LiveActivityManager()
    ) {
        self.store = store
        self.liveActivityManager = liveActivityManager
        record = store.load()
        isLiveActivityActive = liveActivityManager.hasActiveActivity
    }

    func createPet(name: String, species: PetSpecies) {
        record = store.createPet(name: name, species: species)
        WidgetCenter.shared.reloadAllTimelines()
        liveActivityMessage = nil
    }

    func refresh() {
        record = store.load()
        isLiveActivityActive = liveActivityManager.hasActiveActivity
    }

    func feed() { perform(.feed) }
    func pet() { perform(.pet) }
    func wake() { perform(.wake) }

    func startLivePet() {
        guard let record else { return }
        Task {
            do {
                try await liveActivityManager.start(for: record)
                isLiveActivityActive = true
                liveActivityMessage = nil
            } catch {
                liveActivityMessage = error.localizedDescription
                isLiveActivityActive = liveActivityManager.hasActiveActivity
            }
        }
    }

    func endLivePet() {
        Task {
            await liveActivityManager.endAll()
            isLiveActivityActive = false
            liveActivityMessage = nil
        }
    }

    private func perform(_ action: PetAction) {
        guard let updated = store.perform(action) else { return }
        record = updated
        WidgetCenter.shared.reloadAllTimelines()
        Task { await liveActivityManager.updateAll(with: updated) }
    }
}
