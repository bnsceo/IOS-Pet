import SwiftUI

@main
struct IOSPetApp: App {
    @StateObject private var model = PetViewModel()

    var body: some Scene {
        WindowGroup {
            RootView(model: model)
        }
    }
}

private struct RootView: View {
    @ObservedObject var model: PetViewModel
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        Group {
            if model.record == nil {
                OnboardingView(model: model)
            } else {
                PetHomeView(model: model)
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                model.refresh()
            }
        }
    }
}
