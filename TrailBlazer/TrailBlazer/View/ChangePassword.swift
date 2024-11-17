import SwiftUI

struct ChangePasswordView: View {
    var body: some View {
        VStack(spacing: 20) {
            AsyncImage(url: URL(string: "https://via.placeholder.com/314x290"))
                .frame(width: 314, height: 290)
                .padding(.top, 16)
            Text("Change Password")
                .font(.largeTitle)
                .bold()
            
            // Password Fields
            SecureField("Enter your current password", text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            SecureField("Enter your new password", text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            SecureField("Confirm your new password", text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // Update Button
            Button("Update Password") {
                print("Change Password action triggered")
            }
            .frame(width: 287, height: 50)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(5)
        }
        .navigationTitle("Change Password")
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
    }
}
