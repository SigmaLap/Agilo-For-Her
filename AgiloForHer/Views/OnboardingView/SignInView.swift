import SwiftUI

struct SignInView: View {
 let onSignInSuccess: () -> Void
 
 @State private var isSignUp = false
 @State private var email = "demo@agilo.com"
 @State private var password = "Demo123!"
 @State private var displayName = "Jane Doe"
 @State private var confirmPassword = "Demo123!"
 @State private var showPassword = false
 @State private var navigateToHome = false
 
 var body: some View {
  NavigationStack {
   ZStack {
    Color.background
     .ignoresSafeArea()
    
    ScrollView {
     VStack(spacing: 20) {
      // Header
      VStack(spacing: 15) {
       Image("icon")
        .resizable()
        .scaledToFit()
        .frame(width: 80, height: 80)
        .clipShape(RoundedRectangle(cornerRadius: 15))

       
       Text(isSignUp ? "Create Account" : "Welcome Back")
        .font(.system(size: 32, weight: .bold))
        .foregroundColor(.blackPrimary)
       
       Text(isSignUp ? "Join Agilo to get started" : "Sign in to continue")
        .font(.body)
        .foregroundColor(.textSecondary)
      }
      .padding(.top)
      .padding(.bottom, 30)
      
      // Form Fields
      VStack(spacing: 16) {
       if isSignUp {
        TextField("Full Name", text: $displayName)
         .font(.body)
         .padding()
         .foregroundStyle(.blackText)
         .background(Color.white)
         .cornerRadius(12)
         .textInputAutocapitalization(.words)
         .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
       }
       
       TextField("Email", text: $email)
        .font(.body)
        .foregroundStyle(.blackText)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .textInputAutocapitalization(.never)
        .keyboardType(.emailAddress)
        .autocorrectionDisabled()
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
       
       HStack(spacing: 12) {
        Group {
         if showPassword {
          TextField("Password", text: $password)
           .font(.body)
         } else {
          SecureField("Password", text: $password)
           .font(.body)
         }
        }
        .foregroundStyle(.blackText)
        .padding()
        
        Button(action: { showPassword.toggle() }) {
         Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
          .foregroundStyle(.blackText)
          .padding(.trailing, 12)
        }
       }
       .background(Color.white)
       .cornerRadius(12)
       .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
       
       if isSignUp {
        HStack(spacing: 12) {
         Group {
          if showPassword {
           TextField("Confirm Password", text: $confirmPassword)
            .font(.body)
          } else {
           SecureField("Confirm Password", text: $confirmPassword)
            .font(.body)
          }
         }
         .padding()
         
         Button(action: { showPassword.toggle() }) {
          Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
           .foregroundColor(.textSecondary)
           .padding(.trailing, 12)
         }
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        
        // Password Strength Indicator
        if !password.isEmpty {
         PasswordStrengthIndicator(password: password)
          .padding(.top, 4)
        }
       }
      }
      .padding(.horizontal)
      
      // Sign In / Sign Up Button
      Button(action: {
       navigateToHome = true
       onSignInSuccess()
      }) {
       HStack {
        Text(isSignUp ? "Create Account" : "Sign In")
         .font(.headline)
       }
       .frame(maxWidth: .infinity)
       .padding(.vertical, 16)
       .background(Color.black)
       .foregroundColor(.white)
       .cornerRadius(12)
       .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
      }
      .padding(.horizontal)
      .padding(.top, 8)
      
      // Toggle Sign In / Sign Up
      HStack(spacing: 10) {
       Text(isSignUp ? "Already have an account?" : "Don't have an account?")
        .font(.body)
        .foregroundColor(.textSecondary)
       
       Button(action: {
        withAnimation {
         isSignUp.toggle()
        }
       }) {
        Text(isSignUp ? "Sign In" : "Sign Up")
         .font(.headline)
         .foregroundColor(.primary)
       }
      }
      .padding(.top, 8)
      
      // Divider
      HStack(spacing: 15) {
       Rectangle()
        .fill(Color.textSecondary.opacity(0.3))
        .frame(height: 1)
       
       Text("OR")
        .font(.caption)
        .foregroundColor(.textSecondary)
       
       Rectangle()
        .fill(Color.textSecondary.opacity(0.3))
        .frame(height: 1)
      }
      .padding(.horizontal)
      .padding(.vertical, 20)
      
      // Social Sign In Buttons
      VStack(spacing: 12) {
       // Sign In with Apple
       Button(action: {
        onSignInSuccess()
        navigateToHome = true
       }) {
        HStack(spacing: 12) {
         Image(systemName: "apple.logo")
          .font(.system(size: 18, weight: .semibold))
         
         Text("Sign in with Apple")
          .font(.headline)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.black)
        .foregroundColor(.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
       }
       
       // Sign In with Google
       Button(action: {
        onSignInSuccess()
        navigateToHome = true
       }) {
        HStack(spacing: 12) {
         Image("Google")
          .resizable()
          .frame(width: 18, height: 18)
         
         Text("Sign in with Google")
          .font(.headline)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.white)
        .foregroundColor(.black)
        .cornerRadius(12)
        .overlay(
         RoundedRectangle(cornerRadius: 12)
          .stroke(Color.textSecondary.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
       }
       

      }
      .padding(.horizontal)
      
      // Terms and Privacy
      VStack(spacing: 10) {
       Text("By signing in, you agree to our Terms of Service and Privacy Policy")
        .font(.caption2)
        .foregroundColor(.textSecondary)
        .multilineTextAlignment(.center)
        .padding(.horizontal, 40)
      }
      .padding(.top, 20)
      .padding(.bottom, 30)
     }
    }
   }
   .navigationDestination(isPresented: $navigateToHome) {
    MainView()
   }
  }
 }
}

// MARK: - Password Strength Indicator

struct PasswordStrengthIndicator: View {
 let password: String
 
 var strength: PasswordStrength {
  var score = 0
  
  if password.count >= 6 { score += 1 }
  if password.count >= 10 { score += 1 }
  if password.range(of: "[A-Z]", options: .regularExpression) != nil { score += 1 }
  if password.range(of: "[a-z]", options: .regularExpression) != nil { score += 1 }
  if password.range(of: "[0-9]", options: .regularExpression) != nil { score += 1 }
  if password.range(of: "[^A-Za-z0-9]", options: .regularExpression) != nil { score += 1 }
  
  switch score {
  case 0...1:
   return .weak
  case 2...3:
   return .fair
  case 4...5:
   return .strong
  default:
   return .veryStrong
  }
 }
 
 var body: some View {
  VStack(alignment: .leading, spacing: 8) {
   HStack(spacing: 8) {
    ForEach(0..<4, id: \.self) { index in
     Capsule()
      .fill(index < strength.filledBars ? strengthColor : Color.gray.opacity(0.2))
      .frame(height: 4)
      .animation(.spring(response: 0.3), value: strength.filledBars)
    }
   }
   
   HStack {
    Text("Password Strength: \(strength.label)")
     .font(.caption)
     .foregroundColor(strengthColor)
    
    Spacer()
    
    if strength == .veryStrong {
     Image(systemName: "checkmark.circle.fill")
      .foregroundColor(.myGreen)
      .font(.caption)
    }
   }
  }
  .padding(.horizontal, 4)
 }
 

 
 private var strengthColor: Color {
  switch strength {
  case .weak:
   return Color.myRed
  case .fair:
   return Color(red: 1, green: 0.7, blue: 0)
  case .strong:
   return Color(.myGreen)
  case .veryStrong:
   return Color(red: 0.2, green: 0.8, blue: 0.2)
  }
 }
}

enum PasswordStrength {
 case weak, fair, strong, veryStrong
 
 var label: String {
  switch self {
  case .weak: return "Weak"
  case .fair: return "Fair"
  case .strong: return "Strong"
  case .veryStrong: return "Very Strong"
  }
 }
 
 var filledBars: Int {
  switch self {
  case .weak: return 1
  case .fair: return 2
  case .strong: return 3
  case .veryStrong: return 4
  }
 }
}

#Preview {
 SignInView(onSignInSuccess: {
  // In this preview, the button does nothing
  print("Sign In Tapped!")
 })
}
