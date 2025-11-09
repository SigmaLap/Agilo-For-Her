import SwiftUI

struct WelcomeView: View {
 @State private var showWelcomeView2: Bool = false
 
 var body: some View {
  NavigationStack {
   VStack {
    ZStack(alignment: .top) {
     Image("14")
      .resizable()
      .aspectRatio(contentMode: .fill)
      .clipped()
     
     LinearGradient(
      gradient: Gradient(colors: [
       Color.clear,
       Color.white.opacity(0.01),
       Color.white.opacity(0.03),
       Color.white.opacity(0.04),
       Color.white.opacity(0.06),
       Color.white.opacity(0.08),
       Color.white.opacity(0.10),
       Color.white.opacity(0.12),
       Color.white.opacity(0.14),
       Color.white.opacity(0.20),
       Color.white.opacity(0.30),
       Color.white.opacity(0.40),
       Color.white
      ]),
      startPoint: .top,
      endPoint: .bottom
     )
    }
    .ignoresSafeArea()
    
    VStack(alignment: .leading) {
     VStack(alignment: .leading) {
      Text("Agilo Her - Run Your Own 9-to-5")
       .font(.title2.bold())
       .foregroundStyle(.softSalmon)
      Text("Built to help you finish what you Started!")
       .font(.title3.bold())
       .foregroundStyle(.blackText)
     }
     .padding(.horizontal)
     .padding(.bottom)
     
     Button(action: {
      showWelcomeView2 = true
     }) {
      Text("I'm Ready")
       .bold()
       .foregroundStyle(.whiteText)
       .frame(maxWidth: .infinity)
       .padding(.vertical, 20)
       .background(
        RoundedRectangle(cornerRadius: 20)
         .fill(.black)
         .overlay(
          RoundedRectangle(cornerRadius: 20)
           .stroke(Color.white.opacity(0.3), lineWidth: 2)
         )
       )
       .cornerRadius(20)
       .padding(.horizontal, 20)
       .padding(.bottom, 20)
       .shadow(radius: 10)
       .padding(.bottom)
     }
    }
    .padding()
    .padding(.bottom)
   }
   .background(.white)
   .padding(.bottom)
   .padding(.bottom)
   
   .navigationDestination(isPresented: $showWelcomeView2) {
    SignInView {
     // This will be handled by WelcomeView2's navigation
    }
   }
  }
 }
}
#Preview(){
 WelcomeView()
}
