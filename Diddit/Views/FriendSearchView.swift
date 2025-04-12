import SwiftUI

struct FriendSearchView: View {
    @Environment(\.dismiss) var dismiss
    
    struct Friend: Identifiable {
        let id = UUID()
        let name: String
        let username: String
        let isFollowing: Bool
    }
    
    let friends = [
        Friend(name: "John Doe", username: "johndoe", isFollowing: false),
        Friend(name: "Jane Smith", username: "janesmith", isFollowing: true),
        Friend(name: "Alex Johnson", username: "alexj", isFollowing: false)
    ]
    
    var body: some View {
        NavigationView {
            List(friends) { friend in
                HStack {
                    VStack(alignment: .leading) {
                        Text(friend.name)
                            .font(.headline)
                        Text("@\(friend.username)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Toggle following status
                    }) {
                        Text(friend.isFollowing ? "Following" : "Follow")
                            .foregroundColor(friend.isFollowing ? .secondary : .accentColor)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(friend.isFollowing ? Color(.systemGray5) : Color(.systemBackground))
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(friend.isFollowing ? Color.clear : Color.accentColor, lineWidth: 1)
                            )
                    }
                }
            }
            .navigationTitle("Find Friends")
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() }
            )
        }
    }
}
