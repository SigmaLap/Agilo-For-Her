import SwiftUI
import SwiftData

struct HomeView: View {
 @Query private var tasks: [Task]
 @Environment(\.modelContext) private var context
 @State private var taskCompletionPercentage = 25.0
 @State private var energyPercentage = 45.0
 @State private var topThreeTasks = 3
 
 @State private var showTaskDetails = false
 @State private var showCreationConfetti = false
 @State private var showEnergyInput = false
 @State private var showEnergyWarning = false
 @State private var energyInputValue: String = ""
 @Environment(\.taskManager) var taskManager

 var formattedDate: String {
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "dd MMM"
  return dateFormatter.string(from: Date())
 }
 
 var body: some View {
  ZStack {
   ScrollView {
    // Welcome back message
    VStack{
     HStack{
      Text("Today")
       .font(.title)
       .bold()
       .padding(.leading)
       .fontDesign(.serif)
      Text("\(formattedDate)")
       .font(.title3)
       .bold()
       .foregroundStyle(Color.textSecondary)
       .fontDesign(.serif)
      Spacer()
      
     }
     HStack {
      Text("Hey 👋")
       .font(.title2)
       .foregroundStyle(Color.agiloRed)
       .padding(.leading)
      
      Spacer()
     }
    }
    .padding(.bottom, -10)
    .padding(.top, 5)

    

    
    //MARK: - Big Rings
    ZStack{
     ActivityRings(
      lineWidth: 34,
      backgroundColor: Color.agiloRed.opacity(0.1),
      foregroundColor: Color.agiloRed.opacity(0.7),
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

     }
      .frame(width: 207, height: 207)
    }
    
    
    //MARK: - Small Rings
    HStack() {
     TaskCircleView(
      color: .agiloRed,
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
      value: "\(topThreeTasks)/3",
      percentage: taskCompletionPercentage
     )
    }
    .padding(.horizontal, 50)
    .padding(.top, -30)
    .padding(.bottom)
    
    
    
    
    Rectangle()
     .foregroundStyle(Color("spacer"))
     .frame(height: 10)
     .padding(.bottom)
     
    
    
    
    //MARK: - Top 3 Tasks
    VStack (alignment: .leading){
     HStack{
      VStack(spacing: 4){
       Text("Top 3")
        .font(.title)
        .bold()
        .foregroundColor(.blackPrimary)
        .fontDesign(.serif)
       Image("line")
        .resizable()
        .frame(width: 67, height: 3.5)
        .offset(x: 3)
       
      }
      Spacer()
      Text("View All")
       .foregroundStyle(.agiloRed)
     }
     .padding(.horizontal)

      VStack(alignment: .leading, spacing: 12) {
       ForEach(Array(taskManager.tasks.enumerated()), id: \.element.id) { index, _ in
        if index < 3 {
         TaskCard(totalCount: 10)
        }
       }
      }
      .padding(.horizontal)
      .padding(.top, 10)
      
    }
    
    
    
    
    
    
    
    
   }
   .scrollIndicators(.hidden)

   .toolbar {
    ToolbarItemGroup(placement: .topBarTrailing) {

     Button(action: {
      showTaskDetails = true
     }) {
      Image(systemName: "plus")
       .font(.headline)
     }
    }

    ToolbarItemGroup(placement: .topBarLeading) {
     HStack{
      Button(action: {}) {
       Image(systemName: "party.popper.fill")
       Text("2")
       Text("/")
       Text("3")
      }

     }
     .bold()
     .font(.caption)
    }
   }

   // Confetti overlay for task creation
   if showCreationConfetti {
    ConfettiView()
   }
  }
  .background(Color("background"))

  .sheet(isPresented: $showTaskDetails) {
   TaskDetailsView()
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
 
}


#Preview {
 HomeView()
  .modelContainer(for: Task.self, inMemory: true)
}

