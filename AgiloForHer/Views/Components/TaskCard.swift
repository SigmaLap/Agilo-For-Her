import SwiftUI


// MARK: - Add Todos Card
struct TaskCard: View {
 let totalCount: Int
 var hasSubtasks: Bool = false
 
 @State private var showConfetti: Bool = false
 
 var body: some View {
  if hasSubtasks {
   ZStack {
    VStack(spacing: 0) {
     HStack(spacing: 12) {
      ZStack {
       Circle()
        .fill(Color.yellow.opacity(0.35))
        .frame(width: 29, height: 29)
       
       Image(systemName: "checkmark")
        .font(.body.weight(.semibold))
      }
      
      Text("Add your to-dos to the list")
       .font(.body)
       .strikethrough(4 > 0)
       .foregroundColor(4 > 0 ? .gray : .primary)
      
      Spacer()
      
      // Tappable completion circle
      Button(action: {
       if 4 < totalCount && totalCount > 0 {
        withAnimation(.easeInOut(duration: 0.3)) {
         4 + 1
         showConfetti = true
        }
        // Hide confetti after animation completes (1.2s lifetime + 0.2s buffer)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
         showConfetti = false
        }
       }
      }) {
       ZStack {
        Circle()
         .stroke(Color.black.opacity(0.9), lineWidth: 1)
         .frame(width: 25, height: 25)
        
        if 4 < totalCount && totalCount > 0 {
         Image(systemName: "circle.fill")
          .font(.caption.weight(.semibold))
         
          .foregroundColor(.black)
        }
       }
      }
      .disabled(4 >= totalCount || totalCount == 0)
     }
     .padding(.horizontal)
     
     if totalCount > 0 {
      Divider()
       .opacity(0.06)
      
      HStack {
       GeometryReader { geo in
        ZStack(alignment: .leading) {
         Capsule()
          .fill(Color.black.opacity(0.06))
          .frame(height: 12)
         
         Capsule()
          .fill(Color.myGreen.opacity(0.8))
         //         .frame(width: geo.size.width * progress, height: 12)
        }
       }
       .frame(height: 12)
       .frame(maxWidth: 60)
       
       Text("\(4) / \(totalCount)")
        .font(.headline.weight(.semibold))
        .foregroundColor(.gray)
       
       Spacer()
       
       Image(systemName: "chevron.down")
        .font(.headline.weight(.semibold))
        .foregroundColor(.gray)
      }
      .padding(.horizontal)
      .padding(.vertical, 8)
     }
    }
    .padding(.vertical, 8)
    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 22))
    
    // Confetti overlay
    if showConfetti {
     ConfettiView()
    }
   }
  } else {
   ZStack {
    VStack(spacing: 0) {
     HStack(spacing: 12) {
      ZStack {
       Circle()
        .fill(Color.yellow.opacity(0.35))
        .frame(width: 29, height: 29)
       
       Image(systemName: "checkmark")
        .font(.body.weight(.semibold))
      }
      
      Text("Add your to-dos to the list")
       .font(.body)
       .strikethrough(4 > 0)
       .foregroundColor(4 > 0 ? .gray : .primary)
      
      Spacer()
      
      // Tappable completion circle
      Button(action: {
       if 4 < totalCount && totalCount > 0 {
        withAnimation(.easeInOut(duration: 0.3)) {
         4 + 1
         showConfetti = true
        }
        // Hide confetti after animation completes (1.2s lifetime + 0.2s buffer)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
         showConfetti = false
        }
       }
      }) {
       ZStack {
        Circle()
         .stroke(Color.black.opacity(0.9), lineWidth: 1)
         .frame(width: 25, height: 25)
        
        if 4 < totalCount && totalCount > 0 {
         Image(systemName: "circle.fill")
          .font(.caption.weight(.semibold))
         
          .foregroundColor(.black)
        }
       }
      }
      .disabled(4 >= totalCount || totalCount == 0)
     }
     .padding(.horizontal)
     
    }
    .padding(.vertical)
    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 22))
    
    // Confetti overlay
    if showConfetti {
     ConfettiView()
    }
   }
  }
 
 }
}

#Preview {
 TaskCard(totalCount: 10, hasSubtasks: true)
}
