import SwiftUI

struct ChangePasswordView: View {
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Change Password")
                .font(Font.custom("Inter", size: 25).weight(.bold))
                .foregroundColor(.black)
                .padding()
            
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
