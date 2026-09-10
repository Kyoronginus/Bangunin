import SwiftUI
import SwiftData

@main
struct IOSApp: App {
    var body: some Scene {
        WindowGroup {
            HomePageView()
        }
        .modelContainer(for: Alarm.self)
    }
}
