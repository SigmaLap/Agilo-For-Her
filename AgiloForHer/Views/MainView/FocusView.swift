import SwiftUI

struct FocusView: View {
 @State private var timerMinutes: Int = 18
 @State private var timerSeconds: Int = 32
 @State private var isRunning: Bool = false
 @State private var selectedDuration: Int = 25
 @State private var progress: Double = 0.26 // 26% complete (dummy data)
 
 let durations = [15, 25, 45, 60]
 
 var body: some View {
  ZStack {
    Color.background
     .ignoresSafeArea()
    
    ScrollView {
     VStack(spacing: 40) {
      // Timer Display
      VStack(spacing: 20) {
       Text("Focus Session")
        .font(.title2.bold())
        .foregroundColor(.blackPrimary)

       // Circular Timer
       ZStack {
        Circle()
         .stroke(Color.textSecondary.opacity(0.2), lineWidth: 12)
         .frame(width: 280, height: 280)

        Circle()
         .trim(from: 0, to: progress)
         .stroke(
          Color.primary,
          style: StrokeStyle(lineWidth: 12, lineCap: .round)
         )
         .frame(width: 280, height: 280)
         .rotationEffect(.degrees(-90))
         .animation(.linear, value: progress)

        VStack(spacing: 8) {
         Text("\(String(format: "%02d:%02d", timerMinutes, timerSeconds))")
          .font(.system(size: 56, weight: .bold))
          .foregroundColor(.blackPrimary)

         Text(isRunning ? "Focusing..." : "Ready to focus")
          .font(.subheadline)
          .foregroundColor(.textSecondary)
        }
       }
      }
      .padding(.top, 40)

      // Duration Selector
      VStack(spacing: 16) {
       Text("Duration")
        .font(.headline)
        .foregroundColor(.blackPrimary)

       HStack(spacing: 16) {
        ForEach(durations, id: \.self) { duration in
         DurationButton(
          minutes: duration,
          isSelected: selectedDuration == duration
         ) {
          selectedDuration = duration
          timerMinutes = duration
          timerSeconds = 0
          progress = 0
          isRunning = false
         }
        }
       }
      }
      .padding(.horizontal)

      // Control Buttons
      HStack(spacing: 24) {
       Button(action: {
        timerMinutes = selectedDuration
        timerSeconds = 0
        progress = 0
        isRunning = false
       }) {
        Image(systemName: "arrow.clockwise")
         .font(.title2)
         .foregroundColor(.textSecondary)
         .frame(width: 60, height: 60)
         .background(Color.white)
         .cornerRadius(30)
         .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
       }

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
        }
        .foregroundColor(.white)
        .frame(width: 140, height: 60)
        .background(Color.primary)
        .cornerRadius(30)
        .shadow(color: Color.black.opacity(0.2), radius: 12, x: 0, y: 6)
       }

       Button(action: {
        isRunning = false
        progress = 0
        timerMinutes = selectedDuration
        timerSeconds = 0
       }) {
        Image(systemName: "stop.fill")
         .font(.title2)
         .foregroundColor(.textSecondary)
         .frame(width: 60, height: 60)
         .background(Color.white)
         .cornerRadius(30)
         .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
       }
      }
      .padding(.horizontal)

      // Today's Stats
      VStack(spacing: 16) {
       Text("Today's Focus")
        .font(.headline)
        .foregroundColor(.blackPrimary)

       HStack(spacing: 24) {
        StatItem(
         value: "3h 45m",
         label: "Focused",
         icon: "clock.fill",
         color: .myGreen
        )

        StatItem(
         value: "8",
         label: "Sessions",
         icon: "checkmark.circle.fill",
         color: .myPurple
        )

        StatItem(
         value: "92%",
         label: "Success",
         icon: "star.fill",
         color: .softSalmon
        )
       }
      }
      .padding()
      .background(Color.white)
      .cornerRadius(20)
      .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
      .padding(.horizontal)
      .padding(.bottom, 30)
     }
    }
   }
   .navigationTitle("Focus")
   .navigationBarTitleDisplayMode(.large)
  }
 }


// MARK: - Duration Button
struct DurationButton: View {
 let minutes: Int
 let isSelected: Bool
 let action: () -> Void
 
 var body: some View {
  Button(action: action) {
   Text("\(minutes)m")
    .font(.headline)
    .foregroundColor(isSelected ? .white : .blackPrimary)
    .frame(width: 70, height: 50)
    .background(isSelected ? Color.primary : Color.white)
    .cornerRadius(12)
    .overlay(
     RoundedRectangle(cornerRadius: 12)
      .stroke(isSelected ? Color.clear : Color.textSecondary.opacity(0.2), lineWidth: 1)
    )
  }
 }
}

// MARK: - Stat Item
struct StatItem: View {
 let value: String
 let label: String
 let icon: String
 let color: Color
 
 var body: some View {
  VStack(spacing: 8) {
   Image(systemName: icon)
    .font(.title3)
    .foregroundColor(color)
   
   Text(value)
    .font(.title3.bold())
    .foregroundColor(.blackPrimary)
   
   Text(label)
    .font(.caption)
    .foregroundColor(.textSecondary)
  }
  .frame(maxWidth: .infinity)
 }
}

#Preview {
 FocusView()
}

