import SwiftUI

struct StatsView: View {
    @EnvironmentObject var streakManager: StreakManager
    @EnvironmentObject var taskManager: TaskManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Streak Card
                    VStack(spacing: 10) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("🔥 Current Streak")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("\(streakManager.currentStreak) days")
                                    .font(.title)
                                    .fontWeight(.bold)
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("Longest Streak")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("\(streakManager.longestStreak) days")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(radius: 2)
                    }
                    .padding(.horizontal)
                    
                    // Points Card
                    VStack(alignment: .leading, spacing: 10) {
                        Text("⭐️ Points")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("\(streakManager.points)")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        ProgressView(value: Double(streakManager.points).truncatingRemainder(dividingBy: 100), total: 100)
                            .accentColor(.orange)
                        Text("Next reward in \(100 - Int(Double(streakManager.points).truncatingRemainder(dividingBy: 100))) points")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                    .padding(.horizontal)
                    
                    // Task Completion Stats
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 15) {
                        StatCard(title: "Completed Today", value: "\(taskManager.completedToday)")
                        StatCard(title: "Total Completed", value: "\(taskManager.totalCompleted)")
                        StatCard(title: "Completion Rate", value: "\(taskManager.completionRate)%")
                        StatCard(title: "Active Tasks", value: "\(taskManager.activeTasks)")
                    }
                    .padding(.horizontal)
                    
                    // Rewards Section
                    VStack(alignment: .leading) {
                        Text("🎁 Rewards")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(streakManager.rewards) { reward in
                                    RewardCard(reward: reward)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Statistics")
            .background(Color(.systemGroupedBackground))
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(value)
                .font(.title2)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct RewardCard: View {
    let reward: StreakManager.Reward
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(reward.title)
                .font(.headline)
            Text(reward.description)
                .font(.caption)
                .foregroundColor(.secondary)
            Text("\(reward.pointsCost) points")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.orange)
        }
        .frame(width: 150)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
        .opacity(reward.isUnlocked ? 1 : 0.6)
    }
}
