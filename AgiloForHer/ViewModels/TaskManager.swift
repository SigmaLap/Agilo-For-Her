import SwiftUI
import SwiftData

@Observable
final class TaskManager {
 var modelContext: ModelContext?
 var tasks: [Task] = []
 
 var dailyEnergyCeiling: Int = 100

 private var todayDateOnly: Date {
  Calendar.current.startOfDay(for: Date())
 }

 // MARK: - Daily Energy Methods

 /// Set daily energy ceiling and save to SwiftData
 func setDailyEnergy(_ amount: Int) {
  dailyEnergyCeiling = amount

  guard let context = modelContext else { return }

  // Check if energy was already set for today
  let todayDate = todayDateOnly

  do {
   // Try to find existing daily energy for today
   let descriptor = FetchDescriptor<DailyEnergy>(
    predicate: #Predicate { $0.date == todayDate }
   )
   let existingEnergy = try context.fetch(descriptor)

   if let existing = existingEnergy.first {
    // Update existing record
    existing.energyCeiling = amount
   } else {
    // Create new record
    let newEnergy = DailyEnergy(date: todayDate, energyCeiling: amount)
    context.insert(newEnergy)
   }

   try context.save()
  } catch {
   print("Error saving daily energy: \(error)")
  }
 }

 
 
 /// Load today's energy ceiling from SwiftData
 func loadTodayEnergy() {
  guard let context = modelContext else { return }

  do {
   let todayDate = todayDateOnly
   let descriptor = FetchDescriptor<DailyEnergy>(
    predicate: #Predicate { $0.date == todayDate }
   )
   let results = try context.fetch(descriptor)

   if let energy = results.first {
    dailyEnergyCeiling = energy.energyCeiling
   }
  } catch {
   print("Error loading daily energy: \(error)")
  }
 }


 /// Add a complete task to SwiftData
 func addTask(_ task: Task) {
  guard let context = modelContext else { return }

  context.insert(task)
  do {
   try context.save()
   tasks.append(task)
  } catch {
   print("Error adding task: \(error)")
  }
 }

 
 
 /// Toggle task completion status
 func toggleTaskCompletion(_ task: Task) {
  guard let context = modelContext else { return }

  task.isCompleted.toggle()

  do {
   try context.save()
  } catch {
   print("Error toggling task completion: \(error)")
  }
 }

 /// Delete a task from SwiftData
 func deleteTask(_ task: Task) {
  guard let context = modelContext else { return }

  context.delete(task)
  do {
   try context.save()
   tasks.removeAll { $0.id == task.id }
  } catch {
   print("Error deleting task: \(error)")
  }
 }

 // MARK: - SubTask Methods

 /// Add a subtask to a task
 func addSubTask(to task: Task, title: String, energyCost: Int = 5) {
  guard let context = modelContext else { return }

  let newSubTask = SubTask(title: title, energyCost: energyCost)
  task.subTasks.append(newSubTask)
  task.hasSubtasks = !task.subTasks.isEmpty

  do {
   try context.save()
  } catch {
   print("Error adding subtask: \(error)")
  }
 }

 /// Delete a subtask from a task
 func deleteSubTask(from task: Task, subTask: SubTask) {
  guard let context = modelContext else { return }

  task.subTasks.removeAll { $0.id == subTask.id }
  task.hasSubtasks = !task.subTasks.isEmpty

  do {
   try context.save()
  } catch {
   print("Error deleting subtask: \(error)")
  }
 }

 /// Toggle subtask completion status
 func toggleSubTaskCompletion(_ subTask: SubTask) {
  guard let context = modelContext else { return }

  subTask.isCompleted.toggle()

  do {
   try context.save()
  } catch {
   print("Error toggling subtask completion: \(error)")
  }
 }

 /// Get total energy cost of completed subtasks
 func getCompletedSubTasksEnergyCost(_ task: Task) -> Int {
  task.subTasks
   .filter { $0.isCompleted }
   .reduce(0) { $0 + $1.energyCost }
 }

 // MARK: - Presentation Methods

 /// Get Color value for a task based on its color string
 func getTaskColor(for task: Task) -> Color {
  getColorValue(task.taskColor)
 }

 /// Get Color value from a color string
 func getColorValue(_ colorName: String) -> Color {
  switch colorName {
  case "purple": return .myPurple
  case "orange": return .orange
  case "blue": return .blue
  case "green": return .myGreen
  case "red": return .myRed
  case "pink": return .pink
  case "cyan": return .cyan
  case "yellow": return .yellow
  default: return .myPurple
  }
 }

 // MARK: - SubTask Validation Methods

 /// Calculate total energy cost of all subtasks
 func getTotalSubTasksEnergyCost(_ subTasks: [SubTask]) -> Int {
  subTasks.reduce(0) { $0 + $1.energyCost }
 }

 /// Get remaining energy budget for subtasks
 func getRemainingEnergyForSubTasks(taskEnergy: Int, currentSubTasks: [SubTask]) -> Int {
  let totalSubTaskEnergy = getTotalSubTasksEnergyCost(currentSubTasks)
  return max(0, taskEnergy - totalSubTaskEnergy)
 }

 /// Check if adding a subtask with given energy would exceed parent task energy
 func canAddSubTask(withEnergy energy: Int, toTaskWithEnergy taskEnergy: Int, currentSubTasks: [SubTask]) -> Bool {
  let remaining = getRemainingEnergyForSubTasks(taskEnergy: taskEnergy, currentSubTasks: currentSubTasks)
  return energy <= remaining
 }

 /// Validate all subtasks fit within parent task energy
 func validateSubTasks(_ subTasks: [SubTask], fitsIn parentEnergy: Int) -> Bool {
  let totalEnergy = getTotalSubTasksEnergyCost(subTasks)
  return totalEnergy <= parentEnergy
 }

 // MARK: - Task Creation Helpers

 /// Create a new subtask with default energy based on remaining budget
 func createNewSubTask(forTaskEnergy taskEnergy: Int, currentSubTasks: [SubTask]) -> SubTask? {
  let remaining = getRemainingEnergyForSubTasks(taskEnergy: taskEnergy, currentSubTasks: currentSubTasks)
  guard remaining > 0 else { return nil }

  return SubTask(
   title: "",
   isCompleted: false,
   energyCost: min(5, remaining)
  )
 }

 /// Check if a subtask energy update would exceed budget
 func canUpdateSubTaskEnergy(
  currentEnergy: Int,
  newEnergy: Int,
  taskEnergy: Int,
  otherSubTasks: [SubTask]
 ) -> Bool {
  let difference = newEnergy - currentEnergy
  let otherEnergy = getTotalSubTasksEnergyCost(otherSubTasks)
  return (otherEnergy + newEnergy) <= taskEnergy
 }

 /// Create and save a new task with validation
 /// Returns true if successful, false if validation fails
 func createAndAddTask(
  title: String,
  color: String,
  symbol: String,
  energyCost: Int,
  subTasks: [SubTask]
 ) -> Bool {
  guard let context = modelContext else { return false }

  // Validate title is not empty
  let trimmedTitle = title.trimmingCharacters(in: .whitespaces)
  guard !trimmedTitle.isEmpty else {
   print("Error: Task title cannot be empty")
   return false
  }

  // Filter out empty subtasks
  let validSubTasks = subTasks.filter { !$0.title.trimmingCharacters(in: .whitespaces).isEmpty }

  // Validate subtasks fit within energy budget
  guard validateSubTasks(validSubTasks, fitsIn: energyCost) else {
   let totalEnergy = getTotalSubTasksEnergyCost(validSubTasks)
   print("Error: Subtasks energy (\(totalEnergy)) exceeds task energy (\(energyCost))")
   return false
  }

  // Create and save task
  let newTask = Task(
   title: trimmedTitle,
   createdDate: Date(),
   isCompleted: false,
   hasSubtasks: !validSubTasks.isEmpty,
   taskColor: color,
   taskSymbol: symbol,
   energyCost: energyCost,
   subTasks: validSubTasks
  )

  addTask(newTask)
  return true
 }
}


extension EnvironmentValues {
 @Entry var taskManager: TaskManager = TaskManager()
}
