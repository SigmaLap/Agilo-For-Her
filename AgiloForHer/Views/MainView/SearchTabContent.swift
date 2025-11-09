import SwiftUI

struct SearchTabContent: View {
 @State private var searchText = ""
 @State private var selectedCategory = "All"
 
 let categories = ["All", "Tasks", "Projects", "Notes", "People"]
 
 // Dummy search results
 let allResults: [SearchResult] = [
  SearchResult(
   title: "Complete project proposal",
   subtitle: "Task • Due Dec 25",
   icon: "checkmark.circle.fill",
   color: .myGreen,
   category: "Tasks"
  ),
  SearchResult(
   title: "Redesign landing page",
   subtitle: "Project • In Progress",
   icon: "folder.fill",
   color: .myPurple,
   category: "Projects"
  ),
  SearchResult(
   title: "Team standup meeting",
   subtitle: "Task • Due Today",
   icon: "checkmark.circle.fill",
   color: .myGreen,
   category: "Tasks"
  ),
  SearchResult(
   title: "Meeting notes - Q4 Planning",
   subtitle: "Note • Updated 2 days ago",
   icon: "note.text",
   color: .softSalmon,
   category: "Notes"
  ),
  SearchResult(
   title: "Review design mockups",
   subtitle: "Task • Due Tomorrow",
   icon: "checkmark.circle.fill",
   color: .myGreen,
   category: "Tasks"
  ),
  SearchResult(
   title: "Sarah Johnson",
   subtitle: "Team Member • Product Manager",
   icon: "person.circle.fill",
   color: .myPurple,
   category: "People"
  ),
  SearchResult(
   title: "API Documentation Project",
   subtitle: "Project • Planning",
   icon: "folder.fill",
   color: .myPurple,
   category: "Projects"
  ),
  SearchResult(
   title: "Weekly sprint notes",
   subtitle: "Note • Updated yesterday",
   icon: "note.text",
   color: .softSalmon,
   category: "Notes"
  )
 ]
 
 var filteredResults: [SearchResult] {
  let categoryFiltered = selectedCategory == "All" 
   ? allResults 
   : allResults.filter { $0.category == selectedCategory }
  
  if searchText.isEmpty {
   return categoryFiltered
  } else {
   return categoryFiltered.filter {
    $0.title.localizedCaseInsensitiveContains(searchText) ||
    $0.subtitle.localizedCaseInsensitiveContains(searchText)
   }
  }
 }
 
 var body: some View {
  ZStack {
   Color.background
    .ignoresSafeArea()
   
   VStack(spacing: 0) {
    // Category Filter
    ScrollView(.horizontal, showsIndicators: false) {
     HStack(spacing: 12) {
      ForEach(categories, id: \.self) { category in
       CategoryPill(
        title: category,
        isSelected: selectedCategory == category
       ) {
        selectedCategory = category
       }
      }
     }
     .padding(.horizontal)
     .padding(.vertical, 16)
    }
    
    // Search Results
    if filteredResults.isEmpty {
     // Empty State
     VStack(spacing: 16) {
      Image(systemName: "magnifyingglass")
       .font(.system(size: 48))
       .foregroundColor(.textSecondary)
      
      Text("No results found")
       .font(.title3.bold())
       .foregroundColor(.blackPrimary)
      
      Text("Try adjusting your search or filters")
       .font(.subheadline)
       .foregroundColor(.textSecondary)
     }
     .frame(maxWidth: .infinity, maxHeight: .infinity)
     .padding()
     
    } else {
     ScrollView {
      VStack(spacing: 12) {
       ForEach(filteredResults) { result in
        SearchResultRow(result: result)
       }
      }
      .padding(.horizontal)
      .padding(.bottom, 30)
     }
    }
   }
  }
  .navigationTitle("Search")
  .navigationBarTitleDisplayMode(.large)
  .searchable(text: $searchText, prompt: "Search tasks, projects, notes...")
 }
}

// MARK: - Search Result Model
struct SearchResult: Identifiable {
 let id = UUID()
 let title: String
 let subtitle: String
 let icon: String
 let color: Color
 let category: String
}

// MARK: - Category Pill
struct CategoryPill: View {
 let title: String
 let isSelected: Bool
 let action: () -> Void
 
 var body: some View {
  Button(action: action) {
   Text(title)
    .font(.subheadline)
    .fontWeight(isSelected ? .semibold : .regular)
    .foregroundColor(isSelected ? .white : .blackPrimary)
    .padding(.horizontal, 16)
    .padding(.vertical, 8)
    .background(isSelected ? Color.primary : Color.white)
    .cornerRadius(20)
    .overlay(
     RoundedRectangle(cornerRadius: 20)
      .stroke(isSelected ? Color.clear : Color.textSecondary.opacity(0.2), lineWidth: 1)
    )
  }
 }
}

// MARK: - Search Result Row
struct SearchResultRow: View {
 let result: SearchResult
 
 var body: some View {
  HStack(spacing: 16) {
   // Icon
   Image(systemName: result.icon)
    .font(.title3)
    .foregroundColor(result.color)
    .frame(width: 44, height: 44)
    .background(result.color.opacity(0.1))
    .cornerRadius(12)
   
   // Content
   VStack(alignment: .leading, spacing: 4) {
    Text(result.title)
     .font(.body)
     .fontWeight(.medium)
     .foregroundColor(.blackPrimary)
    
    Text(result.subtitle)
     .font(.caption)
     .foregroundColor(.textSecondary)
   }
   
   Spacer()
   
   Image(systemName: "chevron.right")
    .font(.caption)
    .foregroundColor(.textSecondary)
  }
  .padding()
  .background(Color.white)
  .cornerRadius(16)
  .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
 }
}

#Preview {
 NavigationStack {
  SearchTabContent()
 }
}

