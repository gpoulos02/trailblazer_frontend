import SwiftUI

struct SignUpView: View {
    @State private var viewModel = SignUpViewModel()
    private let controller: SignUpController

    init() {
        let userController = UserController()
        controller = SignUpController(userController: userController)
    }

    var body: some View {
        VStack(spacing: 20) {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 256, height: 36)
                .background(
                    AsyncImage(url: URL(string: "https://via.placeholder.com/256x36"))
                )
                
            TextField("First Name", text: $viewModel.firstName)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

            TextField("Last Name", text: $viewModel.lastName)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

            TextField("Email", text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)

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

            Button("Sign Up") {
                let success = controller.signUp(
                    firstName: viewModel.firstName,
                    lastName: viewModel.lastName,
                    email: viewModel.email,
                    username: viewModel.username,
                    password: viewModel.password
                )
                viewModel.errorMessage = success ? nil : "Username or email already exists"
            }
            .frame(width: 287, height: 50)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(5)
        }
        .padding()
    }
}


struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(AppState())
    }
}
