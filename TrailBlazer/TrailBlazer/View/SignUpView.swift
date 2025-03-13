import SwiftUI
import Firebase
import FirebaseAuth

struct SignUpView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var errorMessage: String?
    @State private var successMessage: String?
    @State private var isEmailVerified = false
    @State private var navigateToLogin = false // This state triggers navigation
    @State private var showLoginButton = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Sign Up")
                    .font(Font.custom("Inter", size: 25).weight(.bold))
                    .foregroundColor(.black)
                    .padding()
                
                // Input fields
                TextField("First Name", text: $firstName)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)

                TextField("Last Name", text: $lastName)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)

                TextField("Email", text: $email)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .autocapitalization(.none)

                TextField("Username", text: $username)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .autocapitalization(.none)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .autocapitalization(.none)

                if let errorMessage = errorMessage {
                    Text(errorMessage).foregroundColor(.red)
                }

                if let successMessage = successMessage {
                    Text(successMessage).foregroundColor(.green)
                }

                // Sign-Up Button
                VStack {
                            Button("Sign Up") {
                                signUp()
                                showLoginButton = true
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            
                            if showLoginButton {
                                Text("Check your email for verification.")
                                    .foregroundColor(.blue)
                                    .padding(.top)
                                
                                NavigationLink(destination: LogInView()) {
                                    Text("Log In")
                                        .padding()
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(5)
                                }
                            }
                        }
                        .padding()
                    
            
                


                // Only show the navigation to login when the email is verified
//                if isEmailVerified {
//                    NavigationLink(destination: LogInView(), isActive: $navigateToLogin) {
//                        EmptyView()  // Hidden, just to trigger navigation
//                    }
//                }
            }
            .padding()
            .navigationBarTitle("Sign Up", displayMode: .inline)
        }
    }

    private func signUp() {
        guard !email.isEmpty, !username.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }
        showLoginButton = true

        // Send the request to the backend to create the user
        let body: [String: String] = [
            "username": username,
            "password": password,
            "firstName": firstName,
            "lastName": lastName,
            "email": email
        ]

        guard let url = URL(string: "https://TrailBlazer33:5001/api/auth/register") else { return }

        NetworkManager.shared.postData(url: url, body: body) { result in
            switch result {
            case .success:
                // After successfully registering the user, send the Firebase email verification link
                Auth.auth().currentUser?.sendEmailVerification { error in
                    if let error = error {
                        DispatchQueue.main.async {
                            successMessage = nil
                            errorMessage = "Error sending verification email: \(error.localizedDescription)"
                            print("Error sending verification email: \(error.localizedDescription)") // Debug statement
                        }
                    } else {
                        DispatchQueue.main.async {
                            successMessage = "Sign-up successful! Check your email for the verification link."
                            errorMessage = nil
                            isEmailVerified = true  // Set the flag to show the login button
                            navigateToLogin = true // Activate the navigation to login page
                            showLoginButton = true
                            print("Email verification sent successfully!") // Debug statement
                            print("isEmailVerified is now: \(isEmailVerified)") // Debug statement
                        }
                    }
                }
            case .failure:
                DispatchQueue.main.async {
                    successMessage = nil
                    errorMessage = "Failed to register. Please try again."
                    print("Failed to register user.") // Debug statement
                }
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
