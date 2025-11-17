import SwiftUI

struct BacklogView: View {
 @State private var searchText = ""
 @Environment(\.taskManager) var taskManager

 var body: some View {
  VStack{
   VStack{
    HStack {
     HStack {
      Text("Backlog")
       .font(.largeTitle)
       .fontWeight(.medium)
       .fontDesign(.serif)
       .foregroundColor(.blackPrimary)
       .padding(.horizontal)
     }
     
     Spacer()
    }
   }
   .padding(.bottom, 10)
   
   
   ScrollView {
    VStack(spacing: 0) {     
     // Backlog Items
     VStack(spacing: 16) {
      if taskManager.tasks.isEmpty {
       VStack(spacing: 12) {
        Image(systemName: "checkmark.circle")
         .font(.system(size: 48))
         .foregroundColor(.accent.opacity(0.5))
        Text("No tasks yet")
         .font(.headline)
         .foregroundColor(.blackPrimary)
        Text("Add your first task using the To-do tab")
         .font(.subheadline)
         .foregroundColor(.textSecondary)
       }
       .frame(maxWidth: .infinity)
       .fontDesign(.serif)
       .padding(.top, 120)
      } else {
       ForEach(taskManager.tasks) { task in
        BacklogTaskItem(task: task, taskManager: taskManager)
       }
      }
     }
     
     .padding(.horizontal)
     .padding(.bottom, 30)
    }
   }
   .searchable(text: $searchText, prompt: "Search tasks, projects, notes...")
  }
  .background(Color("background"))

 }
}

// MARK: - Backlog Item
struct BacklogItem: View {
 let title: String
 let description: String
 let priority: String
 let dueDate: String
 let color: Color
 
 @State private var isCompleted: Bool = false
 @State private var showConfetti: Bool = false
 
 var body: some View {
  ZStack {
   VStack(alignment: .leading, spacing: 12) {
    HStack {
     // Completion Button
     Button(action: {
      withAnimation(.easeInOut(duration: 0.3)) {
       isCompleted.toggle()
       if isCompleted {
        showConfetti = true
        // Hide confetti after animation completes (1.2s lifetime + 0.2s buffer)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
         showConfetti = false
        }
       }
      }
     }) {
      Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
       .font(.title3)
       .foregroundColor(isCompleted ? .myGreen : .textSecondary)
     }
     .buttonStyle(.plain)
     
     Text(title)
      .font(.headline)
      .foregroundColor(.blackPrimary)
      .strikethrough(isCompleted)
      .opacity(isCompleted ? 0.5 : 1.0)
     
     Spacer()
     
     PriorityBadge(priority: priority, color: color)
    }
    
    Text(description)
     .font(.subheadline)
     .foregroundColor(.textSecondary)
     .lineLimit(2)
     .strikethrough(isCompleted)
     .opacity(isCompleted ? 0.5 : 1.0)
    
    HStack {
     HStack(spacing: 6) {
      Image(systemName: "calendar")
       .font(.caption)
       .foregroundColor(.textSecondary)
      
      Text(dueDate)
       .font(.caption)
       .foregroundColor(.textSecondary)
     }
     
     Spacer()
     
     Button(action: {}) {
      Image(systemName: "ellipsis")
       .font(.caption)
       .foregroundColor(.textSecondary)
     }
    }
   }
   .padding()
   .background(Color.white)
   .cornerRadius(16)
   .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
   .opacity(isCompleted ? 0.6 : 1.0)
   
   // Confetti overlay
   if showConfetti {
    ConfettiView()
   }
  }
 }
}

// MARK: - Backlog Task Item
struct BacklogTaskItem: View {
 let task: Task
 let taskManager: TaskManager
 @State private var showConfetti: Bool = false
 
 var body: some View {
  ZStack {
   VStack(alignment: .leading, spacing: 12) {
    HStack {
     // Completion Button
     Button(action: {
      withAnimation(.easeInOut(duration: 0.3)) {
       taskManager.toggleTaskCompletion(task)
       showConfetti = true
       DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
        showConfetti = false
       }
      }
     }) {
      Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
       .font(.title3)
       .foregroundColor(task.isCompleted ? .myGreen : .textSecondary)
     }
     .buttonStyle(.plain)
     
     Text(task.title)
      .font(.headline)
      .foregroundColor(.blackPrimary)
      .strikethrough(task.isCompleted)
      .opacity(task.isCompleted ? 0.5 : 1.0)
     
     Spacer()
    }
    
    HStack {
     HStack(spacing: 6) {
      Image(systemName: "calendar")
       .font(.caption)
       .foregroundColor(.textSecondary)
      
      Text(task.createdDate.formatted(date: .abbreviated, time: .omitted))
       .font(.caption)
       .foregroundColor(.textSecondary)
     }
     
     Spacer()
     
     Button(action: {}) {
      Image(systemName: "ellipsis")
       .font(.caption)
       .foregroundColor(.textSecondary)
     }
    }
   }
   .padding()
   .background(Color.white)
   .cornerRadius(16)
   .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
   .opacity(task.isCompleted ? 0.6 : 1.0)
   
   // Confetti overlay
   if showConfetti {
    ConfettiView()
   }
  }
 }
}

// MARK: - Priority Badge
struct PriorityBadge: View {
 let priority: String
 let color: Color
 
 var body: some View {
  Text(priority)
   .font(.caption)
   .fontWeight(.semibold)
   .foregroundColor(color)
   .padding(.horizontal, 10)
   .padding(.vertical, 4)
   .background(color.opacity(0.1))
   .cornerRadius(8)
 }
}

#Preview {
 BacklogView()
}

