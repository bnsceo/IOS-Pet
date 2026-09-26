import ActivityKit
import AppIntents
import Foundation
import WidgetKit

struct FeedPetIntent: AppIntent {
    static let title: LocalizedStringResource = "Feed Pet"
    static let description = IntentDescription("Feed your live pet.")

    func perform() async throws -> some IntentResult {
        await PetIntentSync.perform(.feed)
        return .result()
    }
}

struct PetPetIntent: AppIntent {
    static let title: LocalizedStringResource = "Pet"
    static let description = IntentDescription("Give your live pet some attention.")

    func perform() async throws -> some IntentResult {
        await PetIntentSync.perform(.pet)
        return .result()
    }
}

struct WakePetIntent: AppIntent {
    static let title: LocalizedStringResource = "Wake Pet"
    static let description = IntentDescription("Wake your sleeping live pet.")

    func perform() async throws -> some IntentResult {
        await PetIntentSync.perform(.wake)
        return .result()
    }
}

private enum PetIntentSync {
    static func perform(_ action: PetAction) async {
        let store = PetStateStore()
        guard let record = store.perform(action) else { return }

        WidgetCenter.shared.reloadAllTimelines()

        let content = ActivityContent(
            state: PetActivityAttributes.ContentState(record: record),
            staleDate: Date().addingTimeInterval(30 * 60)
        )
        for activity in Activity<PetActivityAttributes>.activities {
            await activity.update(content)
        }
    }
}
