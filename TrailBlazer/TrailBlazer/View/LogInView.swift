import SwiftUI

struct LogInView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var isLoggedIn = false
    @State private var token: String?

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Log In")
                    .font(Font.custom("Inter", size: 25).weight(.bold))
                    .foregroundColor(.black)
                    .padding()
                
                TextField("Username", text: $username)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .disableAutocorrection(true)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }

                Button(action: logIn) {
                    Text("Log In")
                        .frame(width: 287, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
                
                NavigationLink(
                    destination: HomeView(),
                    isActive: $isLoggedIn
                ) {
                    EmptyView()
                }
            }
            .padding()
        }
    }

    private func logIn() {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }
        
        let loginURL = URL(string: "https://TrailBlazer33:5001/api/auth/login")!
        var request = URLRequest(url: loginURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = [
            "username": username,
            "password": password
        ]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: body) else {
            errorMessage = "Failed to encode request body."
            return
        }
        request.httpBody = httpBody

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    errorMessage = "Request failed: \(error.localizedDescription)"
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    errorMessage = "Invalid response from server."
                    return
                }
                
                guard let data = data else {
                    errorMessage = "No data received from server."
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let token = json["token"] as? String {
                        self.token = token
                        self.isLoggedIn = true
                    } else {
                        errorMessage = "Invalid credentials."
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
