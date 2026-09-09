import SwiftUI
import SwiftData

@main
struct IOSApp: App {
    // 1. Create a single shared container
    let sharedContainer: ModelContainer

    init() {
        do {
            sharedContainer = try ModelContainer(for: Alarm.self)
            LocationManager.shared.customModelContainer = sharedContainer
            
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            HomePageView()
        }
        .modelContainer(sharedContainer) 
    }
}
