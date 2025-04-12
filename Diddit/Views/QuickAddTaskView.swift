import SwiftUI

struct QuickAddTaskView: View {
    @EnvironmentObject var taskManager: TaskManager
    @State private var taskTitle = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "plus.circle.fill")
                .foregroundColor(.blue)
                .font(.title3)
            
            TextField("What do you need to do?", text: $taskTitle)
                .textFieldStyle(PlainTextFieldStyle())
                .focused($isFocused)
                .submitLabel(.done)
                .onSubmit {
                    if !taskTitle.isEmpty {
                        addTask()
                    }
                }
            
            if !taskTitle.isEmpty {
                Button(action: addTask) {
                    Image(systemName: "arrow.up.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title3)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color(.systemGray4).opacity(0.1), radius: 2, x: 0, y: 1)
        .padding(.horizontal)
        .onAppear {
            isFocused = true
        }
    }
    
    private func addTask() {
        let task = Task(title: taskTitle.trimmingCharacters(in: .whitespacesAndNewlines))
        HapticManager.impact(style: .medium)
        taskManager.addTask(task)
        taskTitle = ""
    }
}
