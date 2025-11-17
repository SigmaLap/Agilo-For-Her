import SwiftUI


// MARK: - Energy Input Sheet
struct EnergyInputSheet: View {
 @Binding var isPresented: Bool
 @Binding var energyValue: String
 var taskManager: TaskManager
 @State private var selectedEnergy: Int = 25
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
      Text("100")
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
