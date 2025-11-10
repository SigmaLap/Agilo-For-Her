import SwiftUI

struct HomeView: View {
 @State private var showQuickAdd = false
 @State private var quickAddText = ""
 @FocusState private var isInputFocused: Bool
 
 var body: some View {
  ZStack {
   Color.background
    .ignoresSafeArea()

   ScrollView {
     VStack(spacing: 24) {
      // Welcome Header
      VStack(spacing: 12) {
       Text("Welcome back! 👋")
        .font(.system(size: 32, weight: .bold))
        .foregroundColor(.blackPrimary)

       Text("Let's make today productive")
        .font(.body)
        .foregroundColor(.textSecondary)
      }
      .padding(.top, 20)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.horizontal)

      // Stats Cards
      HStack(spacing: 16) {
       StatCard(
        title: "Tasks Today",
        value: "12",
        icon: "checkmark.circle.fill",
        color: .myGreen
       )

       StatCard(
        title: "Completed",
        value: "8",
        icon: "star.fill",
        color: .myPurple
       )
      }
      .padding(.horizontal)

      // Today's Focus
      VStack(alignment: .leading, spacing: 16) {
       HStack {
        Text("Today's Focus")
         .font(.title2.bold())
         .foregroundColor(.blackPrimary)

        Spacer()

        Button(action: {}) {
         Text("View All")
          .font(.subheadline)
          .foregroundColor(.primary)
        }
       }

       VStack(spacing: 12) {
        TaskRow(
         title: "Complete project proposal",
         time: "9:00 AM",
         isCompleted: true
        )

        TaskRow(
         title: "Team standup meeting",
         time: "11:00 AM",
         isCompleted: false
        )

        TaskRow(
         title: "Review design mockups",
         time: "2:00 PM",
         isCompleted: false
        )
       }
      }
      .padding()
      .background(Color.cardBackground)
      .cornerRadius(20)
      .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
      .padding(.horizontal)

      // Recent Activity
      VStack(alignment: .leading, spacing: 16) {
       Text("Recent Activity")
        .font(.title2.bold())
        .foregroundColor(.blackPrimary)

       VStack(spacing: 12) {
        ActivityRow(
         icon: "checkmark.circle.fill",
         title: "Completed 'Write blog post'",
         time: "2 hours ago",
         color: .myGreen
        )

        ActivityRow(
         icon: "plus.circle.fill",
         title: "Added new task",
         time: "5 hours ago",
         color: .myPurple
        )

        ActivityRow(
         icon: "star.fill",
         title: "Achieved daily goal!",
         time: "Yesterday",
         color: .softSalmon
        )

        ActivityRow(
         icon: "checkmark.circle.fill",
         title: "Started new project",
         time: "3 days ago",
         color: .myGreen
        )

        ActivityRow(
         icon: "bell.fill",
         title: "Reminder set for meeting",
         time: "1 week ago",
         color: .myPurple
        )
       }
      }
      .padding()
      .background(Color.white)
      .cornerRadius(20)
      .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
      .padding(.horizontal)

      // Collaboration Partner Section
      VStack(alignment: .leading, spacing: 16) {
       HStack {
        Text("Your Collab Partner")
         .font(.title2.bold())
         .foregroundColor(.blackPrimary)
        
        Spacer()
        
        // Active status indicator
        HStack(spacing: 6) {
         Circle()
          .fill(Color.myGreen)
          .frame(width: 8, height: 8)
         Text("Active")
          .font(.caption)
          .foregroundColor(.myGreen)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Color.myGreen.opacity(0.1))
        .cornerRadius(12)
       }

       // Partner Profile Card
       HStack(spacing: 12) {
        // Avatar
        ZStack {
         Circle()
          .fill(
           LinearGradient(
            colors: [.myPurple, .myPurple.opacity(0.7)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
           )
          )
          .frame(width: 60, height: 60)
         
         Text("JD")
          .font(.title2.bold())
          .foregroundColor(.white)
        }
        
        VStack(alignment: .leading, spacing: 4) {
         Text("Jordan Davis")
          .font(.headline)
          .foregroundColor(.blackPrimary)
         
         HStack(spacing: 4) {
          Image(systemName: "flame.fill")
           .font(.caption)
           .foregroundColor(.softSalmon)
          Text("12 day streak together")
           .font(.caption)
           .foregroundColor(.textSecondary)
         }
        }
        
        Spacer()
        
        Button(action: {}) {
         Image(systemName: "message.fill")
          .font(.title3)
          .foregroundColor(.myPurple)
        }
       }
       .padding()
       .background(Color.gray.opacity(0.05))
       .cornerRadius(16)

       // Partner Activity Feed
       VStack(spacing: 12) {
        CollabActivityCard(
         icon: "checkmark.seal.fill",
         title: "Your collab hit their goals this week! 🎉",
         description: "Jordan completed all 15 weekly tasks",
         time: "Today, 3:45 PM",
         color: .myGreen
        )
        
        CollabActivityCard(
         icon: "laptopcomputer",
         title: "Your collab is now working",
         description: "Jordan started working on 'Marketing Strategy'",
         time: "25 minutes ago",
         color: .myPurple
        )
        
        CollabActivityCard(
         icon: "star.circle.fill",
         title: "Milestone achieved together!",
         description: "You both completed 50 tasks this month",
         time: "2 days ago",
         color: .softSalmon
        )
       }
      }
      .padding()
      .background(Color.white)
      .cornerRadius(20)
      .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
      .padding(.horizontal)

      // Goals Section
      VStack(alignment: .leading, spacing: 16) {
       Text("Weekly Goals")
        .font(.title2.bold())
        .foregroundColor(.blackPrimary)

       VStack(spacing: 12) {
        GoalCard(
         title: "Complete all planned tasks",
         progress: 0.75,
         color: .myGreen
        )

        GoalCard(
         title: "Maintain 8hrs sleep daily",
         progress: 0.6,
         color: .myPurple
        )

        GoalCard(
         title: "Exercise 5 times",
         progress: 0.4,
         color: .softSalmon
        )

        GoalCard(
         title: "Learn new Swift feature",
         progress: 0.85,
         color: .myGreen
        )
       }
      }
      .padding()
      .background(Color.cardBackground)
      .cornerRadius(20)
      .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
      .padding(.horizontal)
      .padding(.bottom, 30)
     }
    }
   }
   .navigationTitle("Home")
   .navigationBarTitleDisplayMode(.large)
  
   .toolbar {
    ToolbarItemGroup(placement: .topBarTrailing) {
     Menu("Options", systemImage: "ellipsis"){

     }
     .font(.title2)

     Button(action: {
      showQuickAdd = true
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
       isInputFocused = true
      }
     }) {
      Image(systemName: "plus.circle.fill")
       .font(.title2)
     }
    }
    
    ToolbarItemGroup(placement: .topBarLeading) {
     HStack{
      Button(action: {}) {
       Image(systemName: "party.popper.fill")
       Text("0")
       Text("/")
       Text("1")
      }
     
     }
     .bold()
     .font(.caption)
    }
   }
   .sheet(isPresented: $showQuickAdd) {
    QuickAddTaskView(
     isPresented: $showQuickAdd,
     taskText: $quickAddText,
     onAddTask: addTask
    )
    .presentationDetents([.medium])
    .presentationDragIndicator(.visible)
   }
  
  }
 

 private func addTask() {
  let task = quickAddText.trimmingCharacters(in: .whitespaces)
  if !task.isEmpty {
   // TODO: Add task to your data model
   print("Task added: \(task)")
   quickAddText = ""
   showQuickAdd = false
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
 let isCompleted: Bool
 
 var body: some View {
  HStack(spacing: 12) {
   Button(action: {}) {
    Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
     .font(.title3)
     .foregroundColor(isCompleted ? .myGreen : .textSecondary)
   }
   
   VStack(alignment: .leading, spacing: 4) {
    Text(title)
     .font(.body)
     .foregroundColor(.blackPrimary)
     .strikethrough(isCompleted)
    
    Text(time)
     .font(.caption)
     .foregroundColor(.textSecondary)
   }
   
   Spacer()
  }
  .padding()
  .background(Color.gray.opacity(0.05))
  .cornerRadius(12)
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

#Preview {
 HomeView()
}

