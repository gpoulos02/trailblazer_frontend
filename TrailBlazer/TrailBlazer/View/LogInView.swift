import SwiftUI

struct LogInView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var isLoggedIn = false
    @State private var token: String?
    @State private var userName: String?

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Title
                Text("Log In")
                    .font(Font.custom("Inter", size: 25).weight(.bold))
                    .foregroundColor(.black)
                    .padding()
                
                // Username Input
                TextField("Username", text: $username)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .disableAutocorrection(true)

                // Password Input
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)

                // Error Message Display
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding([.horizontal])
                }

                // Log In Button
                Button(action: {
                    logIn() // Trigger log in functionality
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.blue)
                            .frame(width: 287, height: 50)
                        
                        Text("Log In")
                            .font(.title2)
                            .foregroundColor(.white)
                    }

                }
                .padding()
            }
            .padding()
            .navigationDestination(isPresented: $isLoggedIn) {
                HomeView(userName: userName ?? "User")
            }
        }
    }

    // Log In Functionality
    private func logIn() {
        // Ensure fields are filled
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }
        
        // API Endpoint
        let loginURL = URL(string: "https://TrailBlazer33:5001/api/auth/login")!
        var request = URLRequest(url: loginURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Request Body
        let body: [String: String] = [
            "username": username,
            "password": password
        ]
        print("Request Body: \(body)")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: body) else {
            errorMessage = "Failed to encode request body."
            return
        }
        request.httpBody = httpBody

        // Send Request
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                // Handle Errors
                if let error = error {
                    errorMessage = "Request failed: \(error.localizedDescription)"
                    return
                }
                
                // Validate Response
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    errorMessage = "Invalid credentials. Please try again."
                    return
                }
                
                print("HTTP Status Code: \(httpResponse.statusCode)")
                
                // Validate Data
                guard let data = data else {
                    errorMessage = "No data received from server."
                    return
                }
                
                // Parse Response
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let token = json["token"] as? String {
                        self.token = token
                        self.userName = username // Use the entered username
                        self.isLoggedIn = true // This triggers navigation
                        UserDefaults.standard.set(token, forKey: "authToken")
                        print("Token saved: \(token)")

                    } else {
                        errorMessage = "Invalid response from server."
                    }
                } catch {
                    errorMessage = "Failed to parse server response."
                }
            }
        }.resume()
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
