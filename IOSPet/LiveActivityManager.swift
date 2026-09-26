import ActivityKit
import Foundation

struct LiveActivityManager {
    var hasActiveActivity: Bool {
        !Activity<PetActivityAttributes>.activities.isEmpty
    }

    func start(for record: PetRecord) async throws {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            throw LiveActivityError.disabled
        }

        if hasActiveActivity {
            await updateAll(with: record)
            return
        }

        let attributes = PetActivityAttributes(petID: record.pet.id)
        let content = ActivityContent(
            state: PetActivityAttributes.ContentState(record: record),
            staleDate: Date().addingTimeInterval(30 * 60)
        )

        _ = try Activity.request(
            attributes: attributes,
            content: content,
            pushType: nil
        )
    }

    func updateAll(with record: PetRecord) async {
        let content = ActivityContent(
            state: PetActivityAttributes.ContentState(record: record),
            staleDate: Date().addingTimeInterval(30 * 60)
        )

        for activity in Activity<PetActivityAttributes>.activities {
            await activity.update(content)
        }
    }

    func endAll() async {
        for activity in Activity<PetActivityAttributes>.activities {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
    }
}

enum LiveActivityError: LocalizedError {
    case disabled

    var errorDescription: String? {
        "Live Activities are disabled for this app or device."
    }
}
