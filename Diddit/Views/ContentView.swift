import SwiftUI

struct ContentView: View {
    @EnvironmentObject var taskManager: TaskManager
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var showingAddTask = false
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                TaskListView()
                    .navigationTitle("Diddit")
                    .navigationBarTitleDisplayMode(.large)
                    .navigationBarItems(
                        leading: Button(action: {
                            HapticManager.impact(style: .light)
                            isDarkMode.toggle()
                        }) {
                            Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                                .font(.title3)
                                .foregroundColor(isDarkMode ? .yellow : .primary)
                                .padding(8)
                                .background(Color(.systemGray6))
                                .clipShape(Circle())
                        },
                        trailing: Button(action: {
                            HapticManager.impact(style: .medium)
                            showingAddTask.toggle()
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                                .shadow(color: .blue.opacity(0.3), radius: 3, x: 0, y: 2)
                        }
                    )
            }
            .tabItem {
                Image(systemName: "checkmark.circle.fill")
                Text("Tasks")
            }
            .tag(0)
            
            NavigationView {
                StatsView()
                    .navigationBarTitleDisplayMode(.large)
            }
            .tabItem {
                Image(systemName: "chart.bar.fill")
                Text("Stats")
            }
            .tag(1)
            
            NavigationView {
                SocialView()
                    .navigationBarTitleDisplayMode(.large)
            }
            .tabItem {
                Image(systemName: "person.2.fill")
                Text("Social")
            }
            .tag(2)
        }
        .sheet(isPresented: $showingAddTask) {
            AddTaskView()
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .tint(.blue)
    }
}

struct TaskListView: View {
    @EnvironmentObject var taskManager: TaskManager
    @State private var selectedFilter: TaskFilter = .all
    @Environment(\.colorScheme) var colorScheme
    
    enum TaskFilter {
        case all, today, upcoming
    }
    
    var backgroundColor: Color {
        colorScheme == .dark ? Color(hex: "1C1C1E") : Color(.systemGroupedBackground)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Picker("Filter", selection: $selectedFilter) {
                Text("All").tag(TaskFilter.all)
                Text("Today").tag(TaskFilter.today)
                Text("Upcoming").tag(TaskFilter.upcoming)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            if taskManager.tasks.isEmpty {
                EmptyStateView()
            } else {
                List {
                    ForEach(taskManager.filteredTasks(by: selectedFilter)) { task in
                        TaskRow(task: task)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    HapticManager.notification(type: .error)
                                    taskManager.deleteTask(task)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button {
                                    HapticManager.notification(type: .success)
                                    taskManager.toggleTask(task)
                                } label: {
                                    Label(task.isCompleted ? "Undo" : "Complete",
                                          systemImage: task.isCompleted ? "arrow.uturn.backward" : "checkmark")
                                }
                                .tint(task.isCompleted ? .orange : .green)
                            }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            
            QuickAddTaskView()
                .padding(.vertical, 8)
                .background(Color(.systemBackground))
        }
        .background(backgroundColor)
    }
}

struct EmptyStateView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 70))
                .foregroundColor(.blue)
                .padding()
                .background(
                    Circle()
                        .fill(Color.blue.opacity(0.15))
                        .frame(width: 120, height: 120)
                )
                .shadow(color: .blue.opacity(0.2), radius: 8, x: 0, y: 4)
            
            VStack(spacing: 12) {
                Text("No Tasks Yet")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Tap the + button to add your first task")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct TaskRow: View {
    let task: Task
    @EnvironmentObject var taskManager: TaskManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 15) {
            Button(action: {
                HapticManager.impact(style: .light)
                taskManager.toggleTask(task)
            }) {
                ZStack {
                    Circle()
                        .strokeBorder(TaskStyle.priorityColor(task.priority), lineWidth: 2)
                        .frame(width: 26, height: 26)
                    
                    if task.isCompleted {
                        Circle()
                            .fill(TaskStyle.priorityColor(task.priority))
                            .frame(width: 26, height: 26)
                        Image(systemName: "checkmark")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(task.title)
                    .strikethrough(task.isCompleted)
                    .foregroundColor(task.isCompleted ? .secondary : .primary)
                    .font(.system(.body, design: .rounded))
                
                HStack(spacing: 8) {
                    if let dueDate = task.dueDate {
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .font(.caption)
                            Text(dueDate, style: .date)
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: TaskStyle.categoryIcon(task.category))
                            .font(.caption)
                        Text(task.category.rawValue.capitalized)
                    }
                    .font(.caption)
                    .foregroundColor(TaskStyle.categoryColor(task.category))
                }
            }
            
            Spacer()
            
            if task.streak > 0 {
                HStack(spacing: 4) {
                    Text("\(task.streak)")
                        .font(.system(.caption, design: .rounded))
                        .fontWeight(.semibold)
                    Image(systemName: "flame.fill")
                        .font(.caption)
                }
                .foregroundColor(.orange)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.orange.opacity(0.15))
                )
            }
        }
        .padding(.vertical, 6)
        .contentShape(Rectangle())
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color(.systemGray4).opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

extension Task.Priority {
    var color: Color {
        switch self {
        case .low: return .blue
        case .medium: return .orange
        case .high: return .red
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
