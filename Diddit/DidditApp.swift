import SwiftUI

@main
struct DidditApp: App {
    @StateObject private var taskManager = TaskManager()
    @StateObject private var streakManager = StreakManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(taskManager)
                .environmentObject(streakManager)
        }
    }
}
