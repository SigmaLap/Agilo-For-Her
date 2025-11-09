import SwiftUI

struct QuickAddTaskView: View {
 @Binding var isPresented: Bool
 @Binding var taskText: String
 @FocusState var isInputFocused: Bool
 let onAddTask: () -> Void

 @State private var showTaskDetails = false

 var body: some View {
  VStack(spacing: 16) {
   // Input Field with placeholder
   HStack {
    TextField("Stay On Track", text: $taskText)
     .font(.system(size: 24, weight: .light))
     .foregroundColor(.textSecondary)
     .padding(.horizontal, 20)
     .padding(.vertical, 16)
     .background(Color.white)
     .cornerRadius(12)
     .focused($isInputFocused)
   }
   .padding(.horizontal, 16)

   // Time and options buttons
   HStack(spacing: 12) {
    Button(action: {}) {
     HStack(spacing: 8) {
      Image(systemName: "clock.fill")
      Text("ANYTIME")
       .font(.system(size: 13, weight: .semibold))
     }
     .foregroundColor(.blackPrimary)
     .padding(.horizontal, 14)
     .padding(.vertical, 10)
     .background(Color.white)
     .cornerRadius(8)
    }

    Button(action: {}) {
     HStack(spacing: 8) {
      Image(systemName: "repeat")
      Text("NO")
       .font(.system(size: 13, weight: .semibold))
     }
     .foregroundColor(.blackPrimary)
     .padding(.horizontal, 14)
     .padding(.vertical, 10)
     .background(Color.white)
     .cornerRadius(8)
    }

    Button(action: { showTaskDetails = true }) {
     Image(systemName: "ellipsis")
      .foregroundColor(.blackPrimary)
      .padding(.horizontal, 14)
      .padding(.vertical, 10)
      .background(Color.white)
      .cornerRadius(8)
    }

    Spacer()

    Button(action: onAddTask) {
     HStack(spacing: 8) {
      Image(systemName: "waveform")
      Text("Speak")
       .font(.caption)
       .fontWeight(.semibold)
     }
     .foregroundColor(.white)
     .padding(.horizontal, 18)
     .padding(.vertical, 10)
     .background(Color.blackPrimary)
     .cornerRadius(20)
    }
   }
   .padding(.horizontal, 16)

   Spacer()
  }
  .padding(.vertical, 20)
  .background(Color(red: 0.95, green: 0.95, blue: 0.97))
  .onAppear {
   isInputFocused = true
  }
  .sheet(isPresented: $showTaskDetails) {
   TaskDetailsView(isPresented: $showTaskDetails, taskText: taskText)
  }
 }
}

#Preview {
 QuickAddTaskView(
  isPresented: .constant(true),
  taskText: .constant(""),
  onAddTask: {}
 )
}
