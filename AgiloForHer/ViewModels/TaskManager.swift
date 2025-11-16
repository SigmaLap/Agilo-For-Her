import SwiftUI

extension EnvironmentValues {
 @Entry var taskManager: TaskManager = TaskManager()
}

@Observable
final class TaskManager {
 var tasks: [Task] = []
 var dailyEnergyCeiling: Int = 100 // Default energy ceiling per day
 var dailyEnergySet: [String: Bool] = [:] // Track if energy was set today

 private var todayKey: String {
  let formatter = DateFormatter()
  formatter.dateFormat = "yyyy-MM-dd"
  return formatter.string(from: Date())
 }

 func isEnergySetForToday() -> Bool {
  return dailyEnergySet[todayKey] ?? false
 }

 func setDailyEnergy(_ amount: Int) {
  dailyEnergyCeiling = amount
  dailyEnergySet[todayKey] = true
 }

 func addTask(_ title: String) {
  let newTask = Task(title: title)
  tasks.append(newTask)
 }

 func addTask(_ task: Task) {
  tasks.append(task)
 }

 func toggleTaskCompletion(_ task: Task) {
  if let index = tasks.firstIndex(where: { $0.id == task.id }) {
   tasks[index].isCompleted.toggle()
  }
 }

 func deleteTask(_ task: Task) {
  tasks.removeAll { $0.id == task.id }
 }
}
