import SwiftUI

struct BacklogView: View {
 @State private var selectedFilter = "All"
 
 let filters = ["All", "High Priority", "Medium", "Low"]
 
 var body: some View {
  ZStack {
    Color.background
     .ignoresSafeArea()
    
    ScrollView {
     VStack(spacing: 0) {
      // Filter Pills
      ScrollView(.horizontal, showsIndicators: false) {
       HStack(spacing: 12) {
        ForEach(filters, id: \.self) { filter in
         FilterPill(
          title: filter,
          isSelected: selectedFilter == filter
         ) {
          selectedFilter = filter
         }
        }
       }
       .padding(.horizontal)
       .padding(.vertical, 16)
      }

      // Backlog Items
      VStack(spacing: 16) {
       BacklogItem(
        title: "Redesign landing page",
        description: "Update UI components and improve user experience",
        priority: "High",
        dueDate: "Dec 25, 2024",
        color: .myRed
       )

       BacklogItem(
        title: "Write API documentation",
        description: "Document all endpoints and request/response formats",
        priority: "Medium",
        dueDate: "Dec 28, 2024",
        color: .softSalmon
       )

       BacklogItem(
        title: "Setup CI/CD pipeline",
        description: "Configure automated testing and deployment",
        priority: "High",
        dueDate: "Jan 2, 2025",
        color: .myRed
       )

       BacklogItem(
        title: "User research interviews",
        description: "Conduct 5 user interviews to gather feedback",
        priority: "Low",
        dueDate: "Jan 5, 2025",
        color: .myGreen
       )

       BacklogItem(
        title: "Update dependencies",
        description: "Update all npm packages to latest versions",
        priority: "Medium",
        dueDate: "Jan 8, 2025",
        color: .softSalmon
       )
      }
      .padding(.horizontal)
      .padding(.bottom, 30)
     }
    }
   }
   .navigationTitle("Backlog")
   .navigationBarTitleDisplayMode(.large)
 }
}

// MARK: - Filter Pill
struct FilterPill: View {
 let title: String
 let isSelected: Bool
 let action: () -> Void
 
 var body: some View {
  Button(action: action) {
   Text(title)
    .font(.subheadline)
    .fontWeight(isSelected ? .semibold : .regular)
    .foregroundColor(isSelected ? .white : .blackPrimary)
    .padding(.horizontal, 20)
    .padding(.vertical, 10)
    .background(isSelected ? Color.primary : Color.white)
    .cornerRadius(20)
    .overlay(
     RoundedRectangle(cornerRadius: 20)
      .stroke(isSelected ? Color.clear : Color.textSecondary.opacity(0.2), lineWidth: 1)
    )
  }
 }
}

// MARK: - Backlog Item
struct BacklogItem: View {
 let title: String
 let description: String
 let priority: String
 let dueDate: String
 let color: Color
 
 var body: some View {
  VStack(alignment: .leading, spacing: 12) {
   HStack {
    Text(title)
     .font(.headline)
     .foregroundColor(.blackPrimary)
    
    Spacer()
    
    PriorityBadge(priority: priority, color: color)
   }
   
   Text(description)
    .font(.subheadline)
    .foregroundColor(.textSecondary)
    .lineLimit(2)
   
   HStack {
    HStack(spacing: 6) {
     Image(systemName: "calendar")
      .font(.caption)
      .foregroundColor(.textSecondary)
     
     Text(dueDate)
      .font(.caption)
      .foregroundColor(.textSecondary)
    }
    
    Spacer()
    
    Button(action: {}) {
     Image(systemName: "ellipsis")
      .font(.caption)
      .foregroundColor(.textSecondary)
    }
   }
  }
  .padding()
  .background(Color.white)
  .cornerRadius(16)
  .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
 }
}

// MARK: - Priority Badge
struct PriorityBadge: View {
 let priority: String
 let color: Color
 
 var body: some View {
  Text(priority)
   .font(.caption)
   .fontWeight(.semibold)
   .foregroundColor(color)
   .padding(.horizontal, 10)
   .padding(.vertical, 4)
   .background(color.opacity(0.1))
   .cornerRadius(8)
 }
}

#Preview {
 BacklogView()
}

