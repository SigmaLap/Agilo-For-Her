import Foundation
import SwiftUI
import SwiftData

@Model
final class Task: Identifiable {
 var id = UUID()
 var title: String
 var createdDate: Date
 var isCompleted: Bool = false
 var hasSubtasks: Bool = false
 var taskColor: String = "purple"
 var taskSymbol: String = "checkmark"
 var energyCost: Int = 25
 var subTasks: [SubTask] = []

 init(
  title: String,
  createdDate: Date = Date(),
  isCompleted: Bool = false,
  hasSubtasks: Bool = false,
  taskColor: String = "purple",
  taskSymbol: String = "checkmark",
  energyCost: Int = 25,
  subTasks: [SubTask] = []
 ) {
  self.title = title
  self.createdDate = createdDate
  self.isCompleted = isCompleted
  self.hasSubtasks = hasSubtasks
  self.taskColor = taskColor
  self.taskSymbol = taskSymbol
  self.energyCost = energyCost
  self.subTasks = subTasks
 }

 var completedSubTasksCount: Int {
  subTasks.filter { $0.isCompleted }.count
 }

 /// Total energy cost of all subtasks
 var totalSubTaskEnergy: Int {
  subTasks.reduce(0) { $0 + $1.energyCost }
 }

 /// Remaining energy available for additional subtasks
 var remainingSubTaskBudget: Int {
  max(0, energyCost - totalSubTaskEnergy)
 }

 /// Whether more subtasks can be added to this task
 var canAddSubTasks: Bool {
  remainingSubTaskBudget > 0
 }

 /// Whether this task has valid (non-empty) subtasks
 var hasValidSubTasks: Bool {
  !subTasks.filter { !$0.title.trimmingCharacters(in: .whitespaces).isEmpty }.isEmpty
 }
}


@Model
final class SubTask: Identifiable {
 var id = UUID()
 var title: String
 var isCompleted: Bool = false
 var energyCost: Int = 5

 init(title: String, isCompleted: Bool = false, energyCost: Int = 5) {
  self.id = UUID()
  self.title = title
  self.isCompleted = isCompleted
  self.energyCost = energyCost
 }
}

@Model
final class DailyEnergy: Identifiable {
 var id = UUID()
 var date: Date
 var energyCeiling: Int

 init(date: Date = Date(), energyCeiling: Int = 100) {
  self.id = UUID()
  self.date = date
  self.energyCeiling = energyCeiling
 }
}
