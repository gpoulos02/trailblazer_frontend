import SwiftUI

struct LandingView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Welcome Text
                Text("Welcome to TrailBlazer")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(.horizontal, 16)
                
                Text("Your all-in-one ski and snowboarding companion")
                    .multilineTextAlignment(.center)
                
                
                Image("FullLogo") 
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 360, height: 360) // Adjust size to fit
                                    .clipShape(Rectangle())
                
                // Log In Button
                NavigationLink(destination: LogInView()) { // Navigates to LogInView
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color(red: 0.55, green: 0.74, blue: 0.96))
                            .frame(width: 287, height: 50)
                        
                        Text("Log In")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                }
                
                // Sign Up Button
                NavigationLink(destination: SignUpView()) { // Navigates to SignUpView
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color(red: 0.84, green: 0.84, blue: 0.84))
                            .frame(width: 287, height: 50)
                        
                        Text("Sign Up")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                }
            }
            .padding()
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}
