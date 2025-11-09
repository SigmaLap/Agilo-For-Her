import SwiftUI
import Foundation

struct MainView: View {
 
 var body: some View {
   TabView {
    Tab("Home", systemImage: "house.fill") {
     HomeView()
    }

    Tab("Backlog", systemImage: "list.bullet") {
     BacklogView()
    }

    Tab("Focus", systemImage: "timer") {
     FocusView()
    }

    Tab("Me", systemImage: "person.fill") {
     MeView()
    }
    
    Tab(role: .search){
     NavigationStack {
      SearchTabContent()
     }
    }
   }
   .tabBarMinimizeBehavior(.onScrollDown)
//   .tabViewBottomAccessory {
//    ProgressTaskFocus()
//   }
  
  .navigationBarBackButtonHidden()

 }
}
#Preview {
 MainView()
}
