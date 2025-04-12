import Foundation

class StreakManager: ObservableObject {
    @Published var currentStreak: Int = 0
    @Published var longestStreak: Int = 0
    @Published var points: Int = 0
    @Published var rewards: [Reward] = []
    
    struct Reward: Identifiable, Codable {
        let id: UUID
        let title: String
        let description: String
        let pointsCost: Int
        let isUnlocked: Bool
    }
    
    func checkDailyStreak() {
        let calendar = Calendar.current
        if let lastLoginDate = UserDefaults.standard.object(forKey: "lastLoginDate") as? Date {
            let daysSinceLastLogin = calendar.dateComponents([.day], from: lastLoginDate, to: Date()).day ?? 0
            
            if daysSinceLastLogin == 1 {
                currentStreak += 1
                awardPoints(10 * currentStreak) // More points for longer streaks
            } else if daysSinceLastLogin > 1 {
                currentStreak = 0
            }
        }
        
        UserDefaults.standard.set(Date(), forKey: "lastLoginDate")
        longestStreak = max(longestStreak, currentStreak)
        saveStats()
    }
    
    func awardPoints(_ amount: Int) {
        points += amount
        checkForNewRewards()
        saveStats()
    }
    
    private func checkForNewRewards() {
        // Check if any new rewards should be unlocked based on points/streaks
    }
    
    private func saveStats() {
        UserDefaults.standard.set(currentStreak, forKey: "currentStreak")
        UserDefaults.standard.set(longestStreak, forKey: "longestStreak")
        UserDefaults.standard.set(points, forKey: "points")
    }
    
    private func loadStats() {
        currentStreak = UserDefaults.standard.integer(forKey: "currentStreak")
        longestStreak = UserDefaults.standard.integer(forKey: "longestStreak")
        points = UserDefaults.standard.integer(forKey: "points")
    }
}
