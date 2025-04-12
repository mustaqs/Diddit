import SwiftUI

struct TaskStyle {
    static func priorityColor(_ priority: Task.Priority) -> Color {
        switch priority {
        case .low: return .blue
        case .medium: return .orange
        case .high: return .red
        }
    }
    
    static func priorityIcon(_ priority: Task.Priority) -> String {
        switch priority {
        case .low: return "arrow.down.circle.fill"
        case .medium: return "equal.circle.fill"
        case .high: return "exclamationmark.circle.fill"
        }
    }
    
    static func categoryColor(_ category: Task.Category) -> Color {
        switch category {
        case .personal: return .blue
        case .work: return .green
        case .shopping: return .purple
        case .health: return .red
        case .education: return .orange
        }
    }
    
    static func categoryIcon(_ category: Task.Category) -> String {
        switch category {
        case .personal: return "person.fill"
        case .work: return "briefcase.fill"
        case .shopping: return "cart.fill"
        case .health: return "heart.fill"
        case .education: return "book.fill"
        }
    }
}
