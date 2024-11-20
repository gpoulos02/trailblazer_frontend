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
                    .autocapitalization(.none)
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
                    destination: HomeView()
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
        
        let loginURL = URL(string: "https://localhost:3000/login")!
        let body = ["username": username, "password": password]

        NetworkManager.shared.postData(url: loginURL, body: body) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let token = json["token"] as? String {
                            self.token = token
                            self.isLoggedIn = true
                        } else {
                            self.errorMessage = "Invalid response from server."
                        }
                    } catch {
                        self.errorMessage = "Failed to parse response."
                    }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}


struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
             
    }
}
