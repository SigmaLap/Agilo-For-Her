import SwiftUI

struct MeView: View {
 
 var body: some View {
  ZStack {
    Color.background
     .ignoresSafeArea()
    
    ScrollView {
     VStack(spacing: 24) {
      // Profile Header
      VStack(spacing: 16) {
       // Profile Image
       ZStack {
        Circle()
         .fill(
          LinearGradient(
           colors: [Color.primary, Color.primary.opacity(0.7)],
           startPoint: .topLeading,
           endPoint: .bottomTrailing
          )
         )
         .frame(width: 120, height: 120)
        
        Image(systemName: "person.fill")
         .font(.system(size: 50))
         .foregroundColor(.white)
       }
       
       VStack(spacing: 4) {
        Text("Jane Doe")
         .font(.title2.bold())
         .foregroundColor(.blackPrimary)
        
        Text("demo@agilo.com")
         .font(.subheadline)
         .foregroundColor(.textSecondary)
       }
       
       // Stats
       HStack(spacing: 40) {
        VStack(spacing: 4) {
         Text("142")
          .font(.title3.bold())
          .foregroundColor(.blackPrimary)
         Text("Tasks")
          .font(.caption)
          .foregroundColor(.textSecondary)
        }
        
        VStack(spacing: 4) {
         Text("89%")
          .font(.title3.bold())
          .foregroundColor(.blackPrimary)
         Text("Complete")
          .font(.caption)
          .foregroundColor(.textSecondary)
        }
        
        VStack(spacing: 4) {
         Text("28")
          .font(.title3.bold())
          .foregroundColor(.blackPrimary)
         Text("Streak")
          .font(.caption)
          .foregroundColor(.textSecondary)
        }
       }
       .padding(.top, 8)
      }
      .padding(.top, 20)
      
      // Menu Sections
      VStack(spacing: 16) {
       MenuSection(title: "Settings") {
        MenuRow(
         icon: "person.circle.fill",
         title: "Edit Profile",
         color: .myPurple
        )
        
        MenuRow(
         icon: "bell.fill",
         title: "Notifications",
         color: .softSalmon
        )
        
        MenuRow(
         icon: "lock.fill",
         title: "Privacy & Security",
         color: .myGreen
        )
       }
       
       MenuSection(title: "Preferences") {
        MenuRow(
         icon: "paintbrush.fill",
         title: "Appearance",
         color: .myPurple
        )
        
        MenuRow(
         icon: "globe",
         title: "Language",
         color: .softSalmon
        )
        
        MenuRow(
         icon: "chart.bar.fill",
         title: "Statistics",
         color: .myGreen
        )
       }
       
       MenuSection(title: "Support") {
        MenuRow(
         icon: "questionmark.circle.fill",
         title: "Help & Support",
         color: .myPurple
        )
        
        MenuRow(
         icon: "info.circle.fill",
         title: "About",
         color: .softSalmon
        )
        
        MenuRow(
         icon: "arrow.right.square.fill",
         title: "Sign Out",
         color: .myRed
        )
       }
      }
      .padding(.horizontal)
      .padding(.bottom, 30)
     }
    }
   }
   .navigationTitle("Profile")
   .navigationBarTitleDisplayMode(.large)
 }
}

// MARK: - Menu Section
struct MenuSection<Content: View>: View {
 let title: String
 let content: Content
 
 init(title: String, @ViewBuilder content: () -> Content) {
  self.title = title
  self.content = content()
 }
 
 var body: some View {
  VStack(alignment: .leading, spacing: 12) {
   Text(title)
    .font(.headline)
    .foregroundColor(.textSecondary)
    .padding(.horizontal, 4)
   
   VStack(spacing: 0) {
    content
   }
   .background(Color.white)
   .cornerRadius(16)
   .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
  }
 }
}

// MARK: - Menu Row
struct MenuRow: View {
 let icon: String
 let title: String
 let color: Color
 
 var body: some View {
  HStack(spacing: 16) {
   Image(systemName: icon)
    .font(.title3)
    .foregroundColor(color)
    .frame(width: 40, height: 40)
    .background(color.opacity(0.1))
    .cornerRadius(20)
   
   Text(title)
    .font(.body)
    .foregroundColor(.blackPrimary)
   
   Spacer()
   
   Image(systemName: "chevron.right")
    .font(.caption)
    .foregroundColor(.textSecondary)
  }
  .padding()
  .background(Color.white)
  
  if title != "Sign Out" {
   Divider()
    .padding(.leading, 72)
  }
 }
}

#Preview {
 MeView()
}

