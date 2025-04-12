import Foundation

struct Task: Identifiable, Codable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var dueDate: Date?
    var priority: Priority
    var category: Category
    var streak: Int
    var notes: String?
    
    enum Priority: String, Codable, CaseIterable {
        case low, medium, high
    }
    
    enum Category: String, Codable, CaseIterable {
        case personal, work, shopping, health, education
    }
    
    init(id: UUID = UUID(), title: String, isCompleted: Bool = false, dueDate: Date? = nil, priority: Priority = .medium, category: Category = .personal, streak: Int = 0, notes: String? = nil) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.dueDate = dueDate
        self.priority = priority
        self.category = category
        self.streak = streak
        self.notes = notes
    }
}
