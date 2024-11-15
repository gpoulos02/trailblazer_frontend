import SwiftUI

struct SignUpView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var errorMessage: String = ""
    @State private var isSignedUp: Bool = false // State variable to control navigation
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                AsyncImage(url: URL(string: "https://via.placeholder.com/314x290"))
                    .frame(width: 314, height: 290)
                    .padding(.top, 16)
                Text("Sign Up")
                    .font(.largeTitle)
                    .bold()
                
                // Input Fields
                TextField("First Name", text: $firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("Last Name", text: $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("E-Mail Address", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("Phone Number", text: $phoneNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                // Error Message
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top, 10)
                }
                
                // Navigation Link to HomeView, triggered by successful sign-up
                NavigationLink(
                    destination: HomeView(),
                    label: {
                        Button("Submit") {
                            handleSignUp()
                        }
                        .frame(width: 287, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                    }
                )
            }
            .padding()
        }
    }
    
    private func handleSignUp() {
        // Check if all fields are filled
        if firstName.isEmpty || lastName.isEmpty || email.isEmpty || phoneNumber.isEmpty {
            errorMessage = "Please fill in all fields."
        }
        // Check if email is valid
        else if !isValidEmail(email) {
            errorMessage = "Please enter a valid email address."
        }
        // Check if phone number is valid (basic validation for the format)
        else if !isValidPhoneNumber(phoneNumber) {
            errorMessage = "Please enter a valid phone number."
        }
        else {
            errorMessage = "" // Clear error message if validation passes
            // Simulate sign-up success (replace with an actual API call)
            print("Signed up with Email: \(email) and Phone Number: \(phoneNumber)")
            isSignedUp = true // Set to true to trigger navigation
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        // Simple email validation using regex
        let emailRegEx = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    private func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        // Simple phone number validation (10 digits)
        let phoneRegEx = "^\\d{10}$"
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return phoneTest.evaluate(with: phoneNumber)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
