import SwiftUI

struct HomeView: View {
 @State private var showQuickAdd = false
 @State private var quickAddText = ""
 @State private var showCreationConfetti = false
 @State private var showEnergyInput = false
 @State private var showEnergyWarning = false
 @State private var energyInputValue: String = ""
 @FocusState private var isInputFocused: Bool
 @Environment(\.taskManager) var taskManager

 var formattedDate: String {
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "dd MMM"
  return dateFormatter.string(from: Date())
 }

 // Get top 3 tasks
 var topThreeTasks: [Task] {
  Array(taskManager.tasks.prefix(3))
 }

 // Calculate task completion percentage (out of 3)
 var taskCompletionPercentage: Double {
  let completedTasks = topThreeTasks.filter { $0.isCompleted }.count
  return Double(completedTasks) / 3.0 * 100
 }

 // Calculate energy percentage (energy spent / ceiling)
 var energyPercentage: Double {
  let totalEnergySpent = topThreeTasks
   .filter { $0.isCompleted }
   .reduce(0) { $0 + $1.energyCost }

  guard taskManager.dailyEnergyCeiling > 0 else { return 0 }
  return Double(totalEnergySpent) / Double(taskManager.dailyEnergyCeiling) * 100
 }
 
 var body: some View {
  ZStack {
   ScrollView {
    // Welcome back message
    VStack{
     HStack {
      VStack{
       HStack {
        Text("Top 3")
         .font(.largeTitle)
         .fontWeight(.medium)
         .fontDesign(.serif)
         .foregroundColor(.blackPrimary)
         .padding(.horizontal)
       }
      }
      Spacer()
     }
    }
    .padding(.bottom, -10)
    

    

    
    
    ZStack{
     Text("\(formattedDate)")
      .fontDesign(.serif)
      .font(.title3)
      .foregroundStyle(Color.textSecondary)

     // Task completion ring (outer)
     ActivityRings(
      lineWidth: 34,
      backgroundColor: Color.accent.opacity(0.1),
      foregroundColor: Color.accent.opacity(0.7),
      percentage: taskCompletionPercentage,
      percent: 100,
      startAngle: -96,
      adjustedSympol: "shippingbox",
      iconSize: 20
     )
      .frame(width: 279, height: 349)

     // Energy level ring (inner) with input button
     ZStack {
      ActivityRings(
       lineWidth: 29,
       backgroundColor: Color.cyan.opacity(0.1),
       foregroundColor: Color.cyan.opacity(0.7),
       percentage: energyPercentage,
       percent: 100,
       startAngle: -97,
       adjustedSympol: "arrow.forward.to.line",
       iconSize: 18
      )

      // Energy input button
      if !taskManager.isEnergySetForToday() {
       Button(action: { showEnergyInput = true }) {
        VStack(spacing: 4) {
         Image(systemName: "bolt.fill")
          .font(.title3)
         Text("Set Energy")
          .font(.caption2)
          .fontWeight(.semibold)
        }
        .foregroundColor(.white)
        .frame(width: 60, height: 60)
        .background(Color.cyan.opacity(0.8))
        .clipShape(Circle())
        .shadow(color: Color.cyan.opacity(0.5), radius: 8)
       }
      }
     }
      .frame(width: 207, height: 207)
    }
     
    
    
    
    HStack() {
     TaskCircleView(
      color: .orange,
      icon: "arrow.triangle.capsulepath",
      title: "Energy Used",
      value: "\(Int(energyPercentage))%",
      percentage: min(energyPercentage, 100)
     )

     Spacer()

     TaskCircleView(
      color: .cyan,
      icon: "arrow.forward.to.line",
      title: "Tasks Done",
      value: "\(topThreeTasks.filter { $0.isCompleted }.count)/3",
      percentage: taskCompletionPercentage
     )
    }
    .padding(.horizontal, 50)
    
    
    
    

    // Display Top 3 Tasks
    if !topThreeTasks.isEmpty {
     VStack(alignment: .leading, spacing: 12) {
      Text("Top 3")
       .font(.headline)
       .foregroundColor(.blackPrimary)
       .padding(.horizontal)

      ForEach(Array(taskManager.tasks.enumerated()), id: \.element.id) { index, _ in
       if index < 3 {
        TaskCardWithEnergyCheck(
         taskIndex: index,
         taskManager: taskManager,
         showEnergyWarning: $showEnergyWarning
        )
       }
      }
     }
     .padding(.horizontal)
     .padding(.bottom, 40)
    }
    
    
    
    
    
    
    
    
   }
   .scrollIndicators(.hidden)

   .toolbar {
    ToolbarItemGroup(placement: .topBarTrailing) {
    
     Button(action: {
      withAnimation(.easeInOut(duration: 0.25)) {
       showQuickAdd = true
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
       isInputFocused = true
      }
     }) {
      Image(systemName: "plus")
       .font(.headline)
     }
    }
//
//    ToolbarItemGroup(placement: .topBarLeading) {
//     HStack{
//      Button(action: {}) {
//       Image(systemName: "party.popper.fill")
//       Text("2")
//       Text("/")
//       Text("3")
//      }
//
//     }
//     .bold()
//     .font(.caption)
//    }
   }

   // Input Accessory Overlay above Keyboard
   if showQuickAdd {
    ZStack {
     // Dismiss background
     Color.black.opacity(0.3)
      .ignoresSafeArea()
      .onTapGesture {
       withAnimation(.easeInOut(duration: 0.25)) {
        showQuickAdd = false
       }
      }

     VStack(spacing: 0) {
      Spacer()

      // Quick Add View positioned above keyboard
      QuickAddTaskView(
       isPresented: $showQuickAdd,
       taskText: $quickAddText,
       onAddTask: addTask
      )
      .presentationDetents([.height(150)])
     }
     .ignoresSafeArea(.keyboard)
    }
   }

   // Confetti overlay for task creation
   if showCreationConfetti {
    ConfettiView()
   }
  }
  .sheet(isPresented: $showEnergyInput) {
   EnergyInputSheet(
    isPresented: $showEnergyInput,
    energyValue: $energyInputValue,
    taskManager: taskManager
   )
  }
  .alert("Set Energy First", isPresented: $showEnergyWarning) {
   Button("Set Energy Now") {
    showEnergyInput = true
   }
   Button("Later", role: .cancel) { }
  } message: {
   Text("Please set your daily energy level before marking tasks as complete. This helps track your daily capacity!")
  }
 }
 

 private func addTask() {
  let taskTitle = quickAddText.trimmingCharacters(in: .whitespaces)
  if !taskTitle.isEmpty {
   // Randomly select color and symbol
   let colors = ["purple", "orange", "blue", "green", "red", "pink", "cyan", "yellow"]
   let symbols = ["checkmark", "star.fill", "bolt.fill", "flame.fill", "heart.fill", "sparkles", "target", "gift.fill", "lightbulb.fill", "crown.fill"]

   let randomColor = colors.randomElement() ?? "purple"
   let randomSymbol = symbols.randomElement() ?? "checkmark"

   // Create task with random color and symbol
   var newTask = Task(title: taskTitle)
   newTask.taskColor = randomColor
   newTask.taskSymbol = randomSymbol
   taskManager.addTask(newTask)

   quickAddText = ""
   showQuickAdd = false

   // Trigger creation confetti
   withAnimation {
    showCreationConfetti = true
   }

   // Hide confetti after animation completes (2.0s for premium glow + 0.2s buffer)
   DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
    showCreationConfetti = false
   }
  }
 }
}

// MARK: - Stat Card
struct StatCard: View {
 let title: String
 let value: String
 let icon: String
 let color: Color
 
 var body: some View {
  VStack(alignment: .leading, spacing: 12) {
   HStack {
    Image(systemName: icon)
     .font(.title2)
     .foregroundColor(color)
    
    Spacer()
   }
   
   Text(value)
    .font(.system(size: 32, weight: .bold))
    .foregroundColor(.blackPrimary)
   
   Text(title)
    .font(.subheadline)
    .foregroundColor(.textSecondary)
  }
  .padding()
  .frame(maxWidth: .infinity)
  .background(Color.cardBackground)
  .cornerRadius(16)
  .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
 }
}

// MARK: - Task Row
struct TaskRow: View {
 let title: String
 let time: String
 @Binding var isCompleted: Bool
 @State private var showConfetti: Bool = false

 var body: some View {
  ZStack {
   HStack(spacing: 12) {
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

    VStack(alignment: .leading, spacing: 4) {
     Text(title)
      .font(.body)
      .foregroundColor(.blackPrimary)
      .strikethrough(isCompleted)
      .opacity(isCompleted ? 0.5 : 1.0)

     Text(time)
      .font(.caption)
      .foregroundColor(.textSecondary)
    }

    Spacer()
   }
   .padding()
   .background(Color.gray.opacity(0.05))
   .cornerRadius(12)
   .opacity(isCompleted ? 0.6 : 1.0)

   // Confetti overlay
   if showConfetti {
    ConfettiView()
   }
  }
 }
}

// MARK: - Activity Row
struct ActivityRow: View {
 let icon: String
 let title: String
 let time: String
 let color: Color

 var body: some View {
  HStack(spacing: 12) {
   Image(systemName: icon)
    .font(.title3)
    .foregroundColor(color)
    .frame(width: 40, height: 40)
    .background(color.opacity(0.1))
    .cornerRadius(20)

   VStack(alignment: .leading, spacing: 4) {
    Text(title)
     .font(.body)
     .foregroundColor(.blackPrimary)

    Text(time)
     .font(.caption)
     .foregroundColor(.textSecondary)
   }

   Spacer()
  }
 }
}

// MARK: - Goal Card
struct GoalCard: View {
 let title: String
 let progress: Double
 let color: Color

 var body: some View {
  VStack(alignment: .leading, spacing: 12) {
   HStack {
    Text(title)
     .font(.body)
     .foregroundColor(.blackPrimary)

    Spacer()

    Text("\(Int(progress * 100))%")
     .font(.caption.bold())
     .foregroundColor(color)
   }

   GeometryReader { geometry in
    ZStack(alignment: .leading) {
     RoundedRectangle(cornerRadius: 4)
      .fill(Color.gray.opacity(0.1))

     RoundedRectangle(cornerRadius: 4)
      .fill(color.opacity(0.6))
      .frame(width: geometry.size.width * progress)
    }
   }
   .frame(height: 8)
  }
  .padding()
  .background(Color.gray.opacity(0.02))
  .cornerRadius(12)
 }
}

// MARK: - Collab Activity Card
struct CollabActivityCard: View {
 let icon: String
 let title: String
 let description: String
 let time: String
 let color: Color
 
 var body: some View {
  HStack(alignment: .top, spacing: 12) {
   Image(systemName: icon)
    .font(.title2)
    .foregroundColor(color)
    .frame(width: 44, height: 44)
    .background(color.opacity(0.1))
    .cornerRadius(22)
   
   VStack(alignment: .leading, spacing: 4) {
    Text(title)
     .font(.body.bold())
     .foregroundColor(.blackPrimary)
    
    Text(description)
     .font(.subheadline)
     .foregroundColor(.textSecondary)
    
    Text(time)
     .font(.caption)
     .foregroundColor(.textSecondary.opacity(0.8))
   }
   
   Spacer()
  }
  .padding()
  .background(Color.gray.opacity(0.05))
  .cornerRadius(12)
 }
}

// MARK: - Add Todos Card
struct AddTodosCard: View {
 let totalCount: Int
 @Binding var completedCount: Int
 @State private var showConfetti: Bool = false

 private var progress: Double {
  guard totalCount > 0 else { return 0 }
  return Double(completedCount) / Double(totalCount)
 }

 var body: some View {
  ZStack {
   VStack(spacing: 0) {
    HStack(spacing: 12) {
     ZStack {
      Circle()
       .fill(Color.yellow.opacity(0.35))
       .frame(width: 29, height: 29)

      Image(systemName: "checkmark")
       .font(.body.weight(.semibold))
     }

     Text("Add your to-dos to the list")
      .font(.body)
      .strikethrough(completedCount > 0)
      .foregroundColor(completedCount > 0 ? .gray : .primary)

     Spacer()

     // Tappable completion circle
     Button(action: {
      if completedCount < totalCount && totalCount > 0 {
       withAnimation(.easeInOut(duration: 0.3)) {
        completedCount += 1
        showConfetti = true
       }
       // Hide confetti after animation completes (1.2s lifetime + 0.2s buffer)
       DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
        showConfetti = false
       }
      }
     }) {
      ZStack {
       Circle()
        .stroke(Color.black.opacity(0.9), lineWidth: 1)
        .frame(width: 25, height: 25)

       if completedCount < totalCount && totalCount > 0 {
        Image(systemName: "plus")
         .font(.caption.weight(.semibold))
         .foregroundColor(.black)
       }
      }
     }
     .disabled(completedCount >= totalCount || totalCount == 0)
    }
    .padding(.horizontal)

    if totalCount > 0 {
     Divider()
      .opacity(0.06)

     HStack {
      GeometryReader { geo in
       ZStack(alignment: .leading) {
        Capsule()
         .fill(Color.black.opacity(0.06))
         .frame(height: 12)

        Capsule()
         .fill(Color.myGreen.opacity(0.8))
         .frame(width: geo.size.width * progress, height: 12)
       }
      }
      .frame(height: 12)
      .frame(maxWidth: 60)

      Text("\(completedCount) / \(totalCount)")
       .font(.headline.weight(.semibold))
       .foregroundColor(.gray)

      Spacer()

      Image(systemName: "chevron.down")
       .font(.headline.weight(.semibold))
       .foregroundColor(.gray)
     }
     .padding(.horizontal)
     .padding(.vertical, 8)
    }
   }
   .padding(.vertical, 8)
   .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 22))

   // Confetti overlay
   if showConfetti {
    ConfettiView()
   }
  }
 }
}

#Preview {
 HomeView()
}


struct RingShape: Shape {
 var percent: Double
 let startAngle: Double
 
 typealias AnimatableData = Double
 var animatableData: Double {
  get {
   return percent
  }
  set {
   percent = newValue
  }
 }
 
 init(percent: Double = 100, startAngle: Double = -90) {
  self.percent = percent
  self.startAngle = startAngle
 }
 
 static func percentToAngle(percent: Double, startAngle: Double) -> Double {
  return (percent / 100 * 360) + startAngle
 }
 
 func path(in rect: CGRect) -> Path {
  let width = rect.width
  let height = rect.height
  let radius = min(height, width) / 2
  let center = CGPoint(x: width / 2, y: height / 2)
  let endAngle = Self.percentToAngle(percent: percent, startAngle: startAngle)
  
  return Path { path in
   path.addArc(center: center, radius: radius, startAngle: Angle(degrees: startAngle), endAngle: Angle(degrees: endAngle), clockwise: false)
  }
 }
}


struct ActivityRings: View {
 let lineWidth : CGFloat
 let backgroundColor: Color
 let foregroundColor: Color
 let percentage: Double
 var percent: Double
 var startAngle: Double
 var adjustedSympol : String
 var iconSize : CGFloat
 
 var body: some View {
  GeometryReader { geometry in
   ZStack {
    let width = geometry.size.width
    let height = geometry.size.height
    let radius = min(height, width) / 2
    let center = CGPoint(x: width / 2, y: height / 2)
    let startAngleRadians = startAngle * .pi / 180
    let arrowX = center.x + radius * cos(CGFloat(startAngleRadians))
    let arrowY = center.y + radius * sin(CGFloat(startAngleRadians))
    RingShape()
     .stroke(style: StrokeStyle(lineWidth: lineWidth))
     .fill(backgroundColor)
    RingShape(percent: percentage)
     .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
     .fill(foregroundColor)
    Image(systemName: adjustedSympol)
     .position(x: arrowX, y: arrowY)
     .font(.system(size: iconSize))
   }
   .padding(lineWidth / 2)
  }
 }
}



struct TaskCircleView: View {
 var color: Color
 var icon: String
 var title: String
 var value: String
 var percentage: Double
 
 var body: some View {
  ZStack {
   RingShape()
    .stroke(style: StrokeStyle(lineWidth: 3))
    .fill(color.opacity(0.1))
    .frame(width: 100, height: 110)
   RingShape(percent: percentage)
    .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round))
    .fill(color.opacity(0.7))
    .frame(width: 100, height: 110)
   Circle()
    .frame(width: 105, height: 110)
    .foregroundStyle(color.opacity(0.1))
   VStack {
    Image(systemName: icon)
     .padding(.bottom, 0.5)
    Text(title)
     .font(.caption2)
     .foregroundStyle(.gray)
     .padding(.bottom, 1)
    Text(value)
     .font(.headline)
     .foregroundStyle(color)
   }
  }
 }
}

// MARK: - Task Card with Energy Check
struct TaskCardWithEnergyCheck: View {
 let taskIndex: Int
 @Bindable var taskManager: TaskManager
 @Binding var showEnergyWarning: Bool

 var body: some View {
  ZStack {
   if taskIndex < taskManager.tasks.count {
    TaskCard(task: $taskManager.tasks[taskIndex])
   }
  }
  .onChange(of: taskManager.tasks[safe: taskIndex]?.isCompleted ?? false) { _, isCompleted in
   // Check if energy is not set when task is completed
   if isCompleted && !taskManager.isEnergySetForToday() {
    showEnergyWarning = true
    if taskIndex < taskManager.tasks.count {
     taskManager.tasks[taskIndex].isCompleted = false
    }
   }
  }
 }
}

// Safe array access extension
extension Array {
 subscript(safe index: Int) -> Element? {
  indices.contains(index) ? self[index] : nil
 }
}

// MARK: - Energy Input Sheet
struct EnergyInputSheet: View {
 @Binding var isPresented: Bool
 @Binding var energyValue: String
 var taskManager: TaskManager
 @State private var selectedEnergy: Int = 100
 @Environment(\.dismiss) private var dismiss

 var body: some View {
  NavigationStack {
   VStack(spacing: 24) {
    VStack(spacing: 16) {
     Text("How much energy do you have today?")
      .font(.title2)
      .fontWeight(.bold)
      .foregroundColor(.blackPrimary)

     Text("Set your daily energy ceiling to help us track your productivity.")
      .font(.body)
      .foregroundColor(.textSecondary)
    }
    .padding(.horizontal)
    .padding(.top, 20)

    VStack(spacing: 20) {
     VStack(spacing: 12) {
      Text("\(selectedEnergy)")
       .font(.system(size: 64, weight: .ultraLight))
       .fontDesign(.serif)
       .foregroundColor(.myPurple)

      Text("Energy Points")
       .font(.caption)
       .foregroundColor(.textSecondary)
     }

     Slider(value: Binding(
      get: { Double(selectedEnergy) },
      set: { selectedEnergy = Int($0) }
     ), in: 25...500, step: 5)
      .accentColor(.myPurple)
      .padding(.horizontal)

     HStack {
      Text("25")
       .font(.caption)
       .foregroundColor(.textSecondary)
      Spacer()
      Text("500")
       .font(.caption)
       .foregroundColor(.textSecondary)
     }
     .padding(.horizontal)
    }
    .padding(20)
    .background(Color.gray.opacity(0.05))
    .cornerRadius(16)
    .padding(.horizontal)

    Spacer()

    Button(action: {
     taskManager.setDailyEnergy(selectedEnergy)
     isPresented = false
    }) {
     HStack(spacing: 8) {
      Image(systemName: "bolt.fill")
      Text("Set Energy")
       .bold()
     }
     .frame(maxWidth: .infinity)
     .padding(.vertical, 14)
     .foregroundColor(.white)
     .background(Color.myPurple)
     .cornerRadius(12)
    }
    .padding(.horizontal)
    .padding(.bottom, 20)
   }
   .navigationTitle("Daily Energy")
   .navigationBarTitleDisplayMode(.inline)
   .toolbar {
    ToolbarItem(placement: .topBarLeading) {
     Button(role: .cancel) {
      dismiss()
     } label: {
      Text("Cancel")
     }
    }
   }
  }
 }
}
