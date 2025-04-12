import SwiftUI
import ContactsUI

struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var taskManager: TaskManager
    
    @State private var title = ""
    @State private var priority = Task.Priority.medium
    @State private var category = Task.Category.personal
    @State private var dueDate = Date()
    @State private var hasReminder = false
    @State private var showingContactPicker = false
    @State private var selectedContact: CNContact?
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Task title", text: $title)
                }
                
                Section {
                    Picker("Priority", selection: $priority) {
                        Text("Low").tag(Task.Priority.low)
                        Text("Medium").tag(Task.Priority.medium)
                        Text("High").tag(Task.Priority.high)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Picker("Category", selection: $category) {
                        Text("Personal").tag(Task.Category.personal)
                        Text("Work").tag(Task.Category.work)
                        Text("Shopping").tag(Task.Category.shopping)
                        Text("Health").tag(Task.Category.health)
                        Text("Education").tag(Task.Category.education)
                    }
                }
                
                Section {
                    Toggle("Set Due Date", isOn: $hasReminder)
                    if hasReminder {
                        DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                    }
                }
                
                Section {
                    Button(action: { showingContactPicker.toggle() }) {
                        HStack {
                            Text("Share Task")
                            Spacer()
                            Image(systemName: "person.badge.plus")
                        }
                    }
                    
                    if let contact = selectedContact {
                        HStack {
                            Text(contact.givenName + " " + contact.familyName)
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                    }
                }
            }
            .navigationTitle("New Task")
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Add") {
                    let task = Task(
                        title: title,
                        isCompleted: false,
                        dueDate: hasReminder ? dueDate : nil,
                        priority: priority,
                        category: category,
                        streak: 0,
                        notes: nil
                    )
                    taskManager.addTask(task)
                    dismiss()
                }
                .disabled(title.isEmpty)
            )
        }
        .sheet(isPresented: $showingContactPicker) {
            ContactPickerView(selectedContact: $selectedContact)
        }
    }
}
