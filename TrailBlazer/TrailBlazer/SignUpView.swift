import SwiftUI

struct SignUpView: View {
    var body: some View {
        VStack(spacing: 20) {
            AsyncImage(url: URL(string: "https://via.placeholder.com/314x290"))
                .frame(width: 314, height: 290)
                .padding(.top, 16)
            Text("Sign Up")
                .font(.largeTitle)
                .bold()
            
            // Input Fields
            TextField("First Name", text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            TextField("Last Name", text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            TextField("E-Mail Address", text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            TextField("Phone Number", text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // Submit Button
            Button("Submit") {
                print("Sign Up action triggered")
            }
            .frame(width: 287, height: 50)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(5)
        }
        .navigationTitle("Sign Up")
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
