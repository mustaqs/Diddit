import SwiftUI

struct SocialView: View {
    @State private var selectedTab = 0
    @State private var showingFriendSearch = false
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("", selection: $selectedTab) {
                    Text("Friends").tag(0)
                    Text("Leaderboard").tag(1)
                    Text("Challenges").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                TabView(selection: $selectedTab) {
                    FriendsListView()
                        .tag(0)
                    
                    LeaderboardView()
                        .tag(1)
                    
                    ChallengesView()
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .navigationTitle("Social")
            .navigationBarItems(trailing: Button(action: { showingFriendSearch.toggle() }) {
                Image(systemName: "person.badge.plus")
            })
            .sheet(isPresented: $showingFriendSearch) {
                FriendSearchView()
            }
        }
    }
}

struct FriendsListView: View {
    @State private var friends: [Friend] = [] // Will be populated from CloudKit
    
    struct Friend: Identifiable {
        let id: String
        let name: String
        let streak: Int
        let points: Int
        let status: String
    }
    
    var body: some View {
        List {
            ForEach(friends) { friend in
                HStack {
                    VStack(alignment: .leading) {
                        Text(friend.name)
                            .font(.headline)
                        Text(friend.status)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("🔥 \(friend.streak)")
                            .font(.subheadline)
                        Text("⭐️ \(friend.points)")
                            .font(.subheadline)
                    }
                }
            }
        }
    }
}

struct LeaderboardView: View {
    @State private var timeFrame = 0 // 0: Weekly, 1: Monthly, 2: All Time
    @State private var leaderboardEntries: [LeaderboardEntry] = []
    
    struct LeaderboardEntry: Identifiable {
        let id: String
        let rank: Int
        let name: String
        let points: Int
        let isUser: Bool
    }
    
    var body: some View {
        VStack {
            Picker("Time Frame", selection: $timeFrame) {
                Text("Weekly").tag(0)
                Text("Monthly").tag(1)
                Text("All Time").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            List {
                ForEach(leaderboardEntries) { entry in
                    HStack {
                        Text("\(entry.rank)")
                            .font(.headline)
                            .frame(width: 30)
                        
                        Text(entry.name)
                            .fontWeight(entry.isUser ? .bold : .regular)
                        
                        Spacer()
                        
                        Text("\(entry.points)")
                            .font(.headline)
                            .foregroundColor(.orange)
                    }
                    .padding(.vertical, 4)
                    .background(entry.isUser ? Color.orange.opacity(0.1) : Color.clear)
                }
            }
        }
    }
}

struct ChallengesView: View {
    @State private var challenges: [Challenge] = []
    @State private var showingNewChallenge = false
    
    struct Challenge: Identifiable {
        let id: String
        let title: String
        let description: String
        let participants: [String]
        let endDate: Date
        let progress: Double
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                ForEach(challenges) { challenge in
                    ChallengeCard(challenge: challenge)
                }
            }
            .padding()
        }
        .overlay(
            Button(action: { showingNewChallenge.toggle() }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title)
                    .foregroundColor(.accentColor)
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(Circle())
                    .shadow(radius: 2)
            }
            .padding()
            ,alignment: .bottomTrailing
        )
    }
}

struct ChallengeCard: View {
    let challenge: ChallengesView.Challenge
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(challenge.title)
                .font(.headline)
            
            Text(challenge.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            ProgressView(value: challenge.progress)
                .accentColor(.orange)
            
            HStack {
                Text("\(Int(challenge.progress * 100))%")
                    .font(.caption)
                    .foregroundColor(.orange)
                
                Spacer()
                
                Text("\(Calendar.current.numberOfDaysBetween(Date(), and: challenge.endDate)) days left")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
