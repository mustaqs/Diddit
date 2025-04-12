import Foundation
import Combine
import UserNotifications

class TaskManager: ObservableObject {
    @Published var tasks: [Task] = []
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadTasks()
        setupNotifications()
    }
    
    var completedToday: Int {
        tasks.filter { task in
            guard task.isCompleted else { return false }
            return Calendar.current.isDateInToday(task.dueDate ?? Date())
        }.count
    }
    
    var totalCompleted: Int {
        tasks.filter { $0.isCompleted }.count
    }
    
    var activeTasks: Int {
        tasks.filter { !$0.isCompleted }.count
    }
    
    var completionRate: Int {
        guard !tasks.isEmpty else { return 0 }
        return Int((Double(totalCompleted) / Double(tasks.count)) * 100)
    }
    
    func addTask(_ task: Task) {
        tasks.append(task)
        saveTasks()
        scheduleNotification(for: task)
    }
    
    func toggleTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
            
            if tasks[index].isCompleted {
                tasks[index].streak += 1
            }
            
            saveTasks()
        }
    }
    
    func deleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
        saveTasks()
    }
    
    func filteredTasks(by filter: TaskListView.TaskFilter) -> [Task] {
        switch filter {
        case .all:
            return tasks.sorted { !$0.isCompleted && $1.isCompleted }
        case .today:
            return tasks.filter { task in
                guard let dueDate = task.dueDate else { return false }
                return Calendar.current.isDateInToday(dueDate)
            }
        case .upcoming:
            return tasks.filter { task in
                guard let dueDate = task.dueDate else { return false }
                return dueDate > Date()
            }
        }
    }
    
    private func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: "tasks")
        }
    }
    
    private func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: "tasks"),
           let decoded = try? JSONDecoder().decode([Task].self, from: data) {
            tasks = decoded
        }
    }
    
    private func setupNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            // Handle authorization result
        }
    }
    
    private func scheduleNotification(for task: Task) {
        guard let dueDate = task.dueDate else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Task Due"
        content.body = task.title
        content.sound = .default
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: task.id.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
