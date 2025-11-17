import SwiftUI



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

// MARK: - Previews

#Preview("ActivityRings - Task Completion") {
 ActivityRings(
  lineWidth: 34,
  backgroundColor: Color.cyan.opacity(0.1),
  foregroundColor: Color.cyan.opacity(0.7),
  percentage: 75,
  percent: 100,
  startAngle: -96,
  adjustedSympol: "shippingbox",
  iconSize: 20
 )
 .frame(width: 280, height: 350)
 .padding()
}

#Preview("ActivityRings - Energy Level") {
 ActivityRings(
  lineWidth: 29,
  backgroundColor: Color.cyan.opacity(0.1),
  foregroundColor: Color.cyan.opacity(0.7),
  percentage: 45,
  percent: 100,
  startAngle: -97,
  adjustedSympol: "arrow.forward.to.line",
  iconSize: 18
 )
 .frame(width: 210, height: 210)
 .padding()
}

#Preview("TaskCircleView - Energy Used") {
 TaskCircleView(
  color: .orange,
  icon: "arrow.triangle.capsulepath",
  title: "Energy Used",
  value: "65%",
  percentage: 0.65
 )
 .padding()
}

#Preview("TaskCircleView - Tasks Done") {
 TaskCircleView(
  color: .cyan,
  icon: "arrow.forward.to.line",
  title: "Tasks Done",
  value: "2/3",
  percentage: 0.67
 )
 .padding()
}

#Preview("RingShape - Combined") {
 HStack(spacing: 20) {
  TaskCircleView(
   color: .orange,
   icon: "arrow.triangle.capsulepath",
   title: "Energy",
   value: "70%",
   percentage: 0.70
  )

  TaskCircleView(
   color: .cyan,
   icon: "checkmark.circle",
   title: "Tasks",
   value: "3/3",
   percentage: 1.0
  )
 }
 .padding()
}
