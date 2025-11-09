import SwiftUI

struct ProgressTaskFocus: View {
 @Environment(\.tabViewBottomAccessoryPlacement) var placement
 @State private var isRunning = true
 @State private var remainingMinutes = 18
 @State private var remainingSeconds = 32
 @State private var totalDuration: Int = 25 // minutes
 @State private var progress: Double = 0.26 // 26% complete (dummy data)
 
 var body: some View {
  if placement == .inline {
   // Collapsed view in tab bar
   HStack(spacing: 8) {
    Image(systemName: "timer")
     .font(.caption)
     .foregroundColor(.primary)
    
    Text("\(String(format: "%02d:%02d", remainingMinutes, remainingSeconds))")
     .font(.caption)
     .fontWeight(.semibold)
     .foregroundColor(.blackPrimary)
   }
   .padding(.horizontal, 12)
   .padding(.vertical, 6)
   .background(Color.white)
   .cornerRadius(16)
   .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
   
  } else {
   // Expanded view
   VStack(spacing: 8) {
    HStack(spacing: 12) {
     Image(systemName: "timer")
      .font(.subheadline)
      .foregroundColor(.primary)
     
     Text("Focus Session")
      .font(.subheadline)
      .fontWeight(.semibold)
      .foregroundColor(.blackPrimary)
     
     Spacer()
     
     Text("\(String(format: "%02d:%02d", remainingMinutes, remainingSeconds))")
      .font(.subheadline)
      .fontWeight(.bold)
      .foregroundColor(.blackPrimary)
     
     Button(action: {
      isRunning.toggle()
     }) {
      Image(systemName: isRunning ? "pause.fill" : "play.fill")
       .font(.caption)
       .foregroundColor(.primary)
       .frame(width: 28, height: 28)
       .background(Color.primary.opacity(0.1))
       .cornerRadius(14)
     }
     
     Button(action: {
      // Stop timer action
      isRunning = false
      progress = 0
      remainingMinutes = totalDuration
      remainingSeconds = 0
     }) {
      Image(systemName: "xmark")
       .font(.caption)
       .foregroundColor(.textSecondary)
       .frame(width: 28, height: 28)
       .background(Color.textSecondary.opacity(0.1))
       .cornerRadius(14)
     }
    }
    .padding(.horizontal, 16)
    .padding(.top, 12)
    
    // Progress Bar
    GeometryReader { geometry in
     ZStack(alignment: .leading) {
      Rectangle()
       .fill(Color.textSecondary.opacity(0.1))
       .frame(height: 4)
      
      Rectangle()
       .fill(Color.primary)
       .frame(width: geometry.size.width * progress, height: 4)
       .animation(.linear, value: progress)
     }
    }
    .frame(height: 4)
    .padding(.horizontal, 16)
    .padding(.bottom, 12)
   }
   .background(Color.white)
   .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: -2)
  }
 }
}

#Preview {
 ProgressTaskFocus()
}

