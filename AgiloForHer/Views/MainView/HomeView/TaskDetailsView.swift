import SwiftUI

struct TaskDetailsView: View {
 @Binding var isPresented: Bool
 let taskText: String
 
 @State private var selectedTimeOfDay = "To-do"
 @State private var duration = "30m"
 @State private var subTasks: [String] = []
 @State private var notes = ""
 @State private var showSuggestBreakdown = false
 @State private var sliderValue: Double = 0
 
 var body: some View {
  NavigationStack{
   ZStack {
    Color.background.ignoresSafeArea()
    
    VStack(spacing: 0) {
     // Header with X and Add task title
     HStack {
      Button(action: { isPresented = false }) {
       Image(systemName: "xmark")
        .font(.system(size: 24, weight: .semibold))
        .foregroundColor(.blackPrimary)
      }
      
      Spacer()
      
      Text("Add task")
       .font(.system(size: 18, weight: .bold))
       .foregroundColor(.blackPrimary)
      
      Spacer()
      
      Button(action: {}) {
       Image(systemName: "checkmark")
        .font(.system(size: 24, weight: .semibold))
        .foregroundColor(.white)
        .frame(width: 48, height: 48)
        .background(Color.myPurple)
        .clipShape(Circle())
      }
     }
     .padding(.horizontal, 20)
     .padding(.vertical, 16)
     
     ScrollView {
      VStack(spacing: 16) {
       // Task input with circle
       HStack(spacing: 12) {
        Circle()
         .stroke(Color.myPurple.opacity(0.3), lineWidth: 2)
         .frame(width: 44, height: 44)
        
        Text(taskText.isEmpty ? "Make a cake" : taskText)
         .font(.system(size: 20, weight: .light))
         .foregroundColor(.blackPrimary)
        
        Spacer()
       }
       .padding(.horizontal, 20)
       
       Divider()
        .padding(.horizontal, 20)
       
       // Time of day
       VStack(alignment: .leading, spacing: 12) {
        Text("Time of day")
         .font(.system(size: 16, weight: .semibold))
         .foregroundColor(.blackPrimary)

        Slider(value: $sliderValue, in: 0...1, step: 0.25) {
         Text("Time of day")
        } minimumValueLabel: {
         Image(systemName: "sun.horizon.fill")
        } maximumValueLabel: {
         Image(systemName: "moon.stars.fill")
        }
        .onChange(of: sliderValue) { _, newValue in
         let timeOfDays = ["Morning", "Afternoon", "Evening", "Night", "Late Night"]
         let index = min(Int(round(newValue * 4)), 4)
         selectedTimeOfDay = timeOfDays[index]
        }

        Text(selectedTimeOfDay)
         .font(.system(size: 16, weight: .semibold))
         .foregroundColor(.myPurple)
         .frame(maxWidth: .infinity, alignment: .center)
       }
       .padding(.horizontal, 20)
       
       Divider()
        .padding(.horizontal, 20)
       
       // Duration
       VStack(alignment: .leading, spacing: 12) {
        HStack {
         Text("Duration")
          .font(.system(size: 16, weight: .semibold))
          .foregroundColor(.blackPrimary)
         
         Spacer()
         
         Menu(duration) {
          Section{
           Button("15m") { duration = "15m" }
           Button("30m") { duration = "30m" }
           Button("1h") { duration = "1h" }
           Button("2h") { duration = "2h" }
          }
          Section{
           Button("All Day") { duration = "24h" }
          }
         }
         .font(.system(size: 16, weight: .semibold))
         .foregroundColor(.blackPrimary)
        }
       }
       .padding(.horizontal, 20)
       
       Divider()
        .padding(.horizontal, 20)
       
       // Sub-tasks
       VStack(alignment: .leading, spacing: 12) {
        HStack {
         Text("Sub-tasks")
          .font(.system(size: 16, weight: .semibold))
          .foregroundColor(.blackPrimary)
         
         Spacer()
         
         Button(action: { showSuggestBreakdown = true }) {
          HStack(spacing: 6) {
           Text("SUGGEST BREAKDOWN")
            .font(.system(size: 12, weight: .semibold))
           Image(systemName: "list.clipboard")
          }
          .foregroundColor(.blackPrimary)
          .padding(5)
         }
        }
        .buttonStyle(.glass)
        
        HStack {
         Text("ADD NEW")
          .font(.system(size: 13, weight: .semibold))
          .foregroundColor(.textSecondary)
         
         Button(action: {}) {
          Image(systemName: "plus")
           .foregroundColor(.textSecondary)
         }
         
         Spacer()
         
         Button(action: {}) {
          Image(systemName: "lock.fill")
           .foregroundColor(.textSecondary)
         }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.white)
        .cornerRadius(8)
       }
       .padding(.horizontal, 20)
       
       Divider()
        .padding(.horizontal, 20)
       
       // Notes
       VStack(alignment: .leading, spacing: 12) {
        Text("Notes")
         .font(.system(size: 16, weight: .semibold))
         .foregroundColor(.blackPrimary)
        
        TextEditor(text: $notes)
         .font(.system(size: 16, weight: .regular))
         .foregroundColor(.textSecondary)
         .frame(minHeight: 120)
         .padding(.horizontal, 12)
         .padding(.vertical, 8)
         .background(Color.white)
         .cornerRadius(8)
       }
       .padding(.horizontal, 20)
       
       // Add button at bottom
       Button(action: {}) {
        Image(systemName: "plus")
         .font(.title.bold())
         .padding(2)
//         .foregroundColor(.blackPrimary)
//         .frame(width: 56, height: 56)
//         .background(Color.white)
//         .clipShape(Circle())
       }
       .buttonStyle(.borderedProminent)
       .tint(.myGreen)
       .padding(.vertical, 20)
      }
      .padding(.vertical, 16)
     }
    }
   }
   //   .toolbar {
   //    Button()
   //     .confirmationDialog("Delete?", isPresented: $PresentDialog){
   //
   //     }
   //   }
  }
 }
}

#Preview("Default") {
 TaskDetailsView(isPresented: .constant(true), taskText: "Make a cake")
}

#Preview("Long title • Dark Mode") {
 TaskDetailsView(isPresented: .constant(true), taskText: "Bake a triple-layer chocolate cake with ganache and decorations")
  .environment(\.colorScheme, .dark)
}
