import SwiftUI
import WidgetKit

@main
struct PetWidgetsBundle: WidgetBundle {
    var body: some Widget {
        PetWidget()
        PetLiveActivity()
    }
}
