import SwiftUI

struct SignUpView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var errorMessage: String?
    @State private var successMessage: String?

    var body: some View {
        VStack(spacing: 20) {
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

            TextField("Username", text: $username)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

            if let errorMessage = errorMessage {
                Text(errorMessage).foregroundColor(.red)
            }

            if let successMessage = successMessage {
                Text(successMessage).foregroundColor(.green)
            }

            Button("Sign Up") {
                signUp()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }

    private func signUp() {
        guard let url = URL(string: "http://localhost:3000/register") else { return }

        // Generate a random userID (UUID)
        let userID = UUID().uuidString

        let body: [String: String] = [
            "username": username,
            "password": password,
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "userID": userID
        ]

        // Send the request
        NetworkManager.shared.postData(url: url, body: body) { result in
            switch result {
            case .success(let data):
                if let response = try? JSONDecoder().decode([String: String].self, from: data),
                   let message = response["message"] {
                    DispatchQueue.main.async {
                        errorMessage = nil
                        successMessage = message
                    }
                }
            case .failure:
                DispatchQueue.main.async {
                    successMessage = nil
                    errorMessage = "Failed to register. Please try again."
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
