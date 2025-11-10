import SwiftUI

struct FocusView: View {
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


struct CircularTimer: View {
 @State private var progress: CGFloat = 22.0 / 60.0
 private let totalMinutes: CGFloat = 60
 private let size: CGFloat = 280
 private let ringWidth: CGFloat = 35
 
 // For minute-based haptics
 @State private var minuteForHaptics: Int = 22
 
 var body: some View {
  ZStack {
   // Track ring
   Circle()
    .stroke(Color.softSalmon.opacity(0.18), lineWidth: ringWidth)
    .frame(width: size, height: size)
   
   GeometryReader { geo in
    let frame = min(geo.size.width, geo.size.height)
    let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
    
    ZStack {
     // Outer progress arc
     Circle()
      .trim(from: 0, to: progress)
      .stroke(
       Color.softSalmon,
       style: StrokeStyle(lineWidth: ringWidth, lineCap: .round)
      )
      .frame(width: frame, height: frame)
      .rotationEffect(.degrees(-90))
      .animation(.linear(duration: 0.12), value: progress)
     // Inner dashed indicator arc
     Circle()
      .trim(from: 0, to: progress)
      .stroke(
       Color.textSecondary.opacity(0.2),
       style: StrokeStyle(
        lineWidth: 10,
        lineCap: .butt,
        dash: [2, 4],     // dash length, gap
        dashPhase: 0
       )
      )
      .rotationEffect(.degrees(-90))
     
    }
//    .contentShape(Rectangle()) // full-surface dragging
    .gesture(
     DragGesture(minimumDistance: 0)
      .onChanged { value in
       // Map drag to angle around center
       let v = CGVector(dx: value.location.x - center.x,
                        dy: value.location.y - center.y)
       var theta = atan2(v.dy, v.dx) + .pi / 2
       if theta < 0 { theta += 2 * .pi }
       var newProgress = theta / (2 * .pi)
       newProgress = min(max(newProgress, 0), 1)
       progress = newProgress
       
       // Minute rounding for haptics
       let minute = Int(round(progress * totalMinutes))
       if minute != minuteForHaptics {
        minuteForHaptics = minute
        playLegacyHaptic() // fallback for < iOS 17
       }
      }
    )
   }
   .frame(width: size, height: size)
   
   // Center labels (dummy)
   ZStack {
    VStack(spacing: 6) {
     Text("\(Int(round(progress * totalMinutes)))")
      .font(.system(size: 48, weight: .bold, design: .rounded))
     Text("MINS")
      .font(.title3.weight(.bold))
      .fontDesign(.rounded)
    }
    
    VStack {
     Text("60")
     Spacer()
     Text("30")
    }
    .foregroundStyle(.secondary)
    .font(.headline.bold())
    .fontDesign(.rounded)

    HStack {
     Text("45")
     Spacer()
     Text("15")
    }
    .foregroundStyle(.secondary)
    .font(.headline.bold())
    .fontDesign(.rounded)

   }
   .frame(width: 218, height: 218)
  }
  .frame(width: size, height: size)
  // iOS 17+ haptics (fires when minuteForHaptics changes)
  .modifier(SensoryFeedbackModifier(trigger: minuteForHaptics))
  .padding(25)
 }
 
 // MARK: - Legacy haptics (for < iOS 17)
 private func playLegacyHaptic() {
  if #available(iOS 17, *) {
   // Prefer the sensoryFeedback modifier path above
  } else {
   let generator = UIImpactFeedbackGenerator(style: .light)
   generator.impactOccurred()
  }
 }
}

// Wrap sensoryFeedback so it compiles on older SDKs
struct SensoryFeedbackModifier: ViewModifier {
 var trigger: Int
 func body(content: Content) -> some View {
  if #available(iOS 17, *) {
   content.sensoryFeedback(.selection, trigger: trigger)
  } else {
   content
  }
 }
}

private extension CGFloat {
 var deg: CGFloat { self * 180 / .pi }
}
