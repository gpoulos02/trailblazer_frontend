import SwiftUI

struct LogInView: View {
    @EnvironmentObject var appState: AppState
    @State private var viewModel = LogInViewModel()
    @State private var isLoggedIn = false  // This will track if login is successful
    
    // Initialize controller after appState is available
    private var controller: LogInController {
        let userController = UserController()
        return LogInController(appState: appState, userController: userController)
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
 
                AsyncImage(url: URL(string: "https://via.placeholder.com/314x290"))
                    .frame(width: 314, height: 290)
                    .padding()
                
                TextField("Username", text: $viewModel.username)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)

                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage).foregroundColor(.red)
                }

                Button("Log In") {
                    let success = controller.logIn(username: viewModel.username.isEmpty ? "Team33" : viewModel.username,
                                                    password: viewModel.password.isEmpty ? "Team33" : viewModel.password)
                    viewModel.errorMessage = success ? nil : "Invalid username or password"
                    if success {
                        // If login is successful, set the state to true
                        isLoggedIn = true
                    }
                }
                .frame(width: 287, height: 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(5)

                // Navigation to HomeView upon successful login
                NavigationLink(destination: HomeView()) {
                    EmptyView()
                }
            }
            .padding()
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
            .environmentObject(AppState()) // Ensure to provide an AppState in the preview
    }
}
