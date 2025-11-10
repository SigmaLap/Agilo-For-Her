
import SwiftUI

struct CycleView: View {
 @State private var timerMinutes: Int = 18
 @State private var timerSeconds: Int = 32
 @State private var isRunning: Bool = false
 @State private var selectedDuration: Int = 25
 @State private var progress: Double = 0.26 // 26% complete (dummy data)
 
 let durations = [15, 25, 45, 60]
 
 var body: some View {
  
  ScrollView {
   VStack(spacing: 40) {
    // Timer Display
    VStack(spacing: 20) {
     Text("Focus")
      .font(.largeTitle.bold())
      .foregroundColor(.blackPrimary)
      .fontDesign(.rounded)
      .padding(.bottom, 21)
     
     // Circular Timer
     ZStack{
      CircularTimer()
     }
    }
    .padding(.top, 48)
        
    // Control Buttons
    HStack() {
     Button(action: {
      isRunning.toggle()
      // Dummy progress update for demo
      if isRunning {
       // Simulate progress increasing (dummy behavior)
      }
     }) {
      HStack(spacing: 12) {
       Image(systemName: isRunning ? "pause.fill" : "play.fill")
        .font(.title2)
       Text(isRunning ? "Pause" : "Start")
        .font(.headline)
        .fontDesign(.rounded)
      }
      .foregroundStyle(.primary)
      .padding(.horizontal, 24)
      .padding(10)
     }
     .buttonStyle(.glass)
    }
    .padding(.horizontal)
    .padding(.top,4)
   }
  }
 }
}



#Preview {
 FocusView()
}


