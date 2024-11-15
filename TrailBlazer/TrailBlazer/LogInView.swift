import SwiftUI

struct LogInView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @State private var isLoggedIn: Bool = false // State variable to control navigation

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Placeholder Image
                AsyncImage(url: URL(string: "https://via.placeholder.com/314x290"))
                    .frame(width: 314, height: 290)
                    .padding(.top, 16)
                
                Text("Log In")
                    .font(.largeTitle)
                    .bold()
                
                // Username Input
                TextField("Username", text: $username)
                    .padding()
                    .cornerRadius(8)
                    .disableAutocorrection(true)
                
                // Password Input
                SecureField("Password", text: $password)
                    .padding()
                    .cornerRadius(8)
                
                // Error Message
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                // Log In Button
                Button(action: {
                    handleLogin()
                }) {
                    Text("Log In")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                
                // Change Password Button
                NavigationLink(destination: ChangePasswordView()) {
                    Text("Change Password")
                        .foregroundColor(.blue)
                        .underline()
                }
                
                // Navigation to HomeView upon successful login
                NavigationLink(destination: HomeView()) {
                    EmptyView() // This navigation link triggers when isLoggedIn is true
                }
            }
            .padding()
        }
    }
    
    private func handleLogin() {
        if username.isEmpty || password.isEmpty {
            errorMessage = "Please fill in all fields."
        } else if password.count < 6 {
            errorMessage = "Password must be at least 6 characters long."
        } else {
            errorMessage = ""
            // Simulate login success (you can replace this with an API call)
            print("Logged in with Username: \(username)")
            isLoggedIn = true // Set to true to trigger navigation
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
