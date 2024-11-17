import SwiftUI

struct LandingView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Welcome Text
                Text("Welcome to TrailBlazer")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(.horizontal, 16)
                Text("Your all-in-one ski and snowboarding companion")
                    .multilineTextAlignment(.center)
                
                // Image Placeholder
                AsyncImage(url: URL(string: "https://via.placeholder.com/389x368"))
                    .frame(width: 389, height: 360)
                    .clipShape(Rectangle())
                
                // Log In Button
                NavigationLink(destination: LogInView()) {
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
                NavigationLink(destination: SignUpView()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color(red: 0.84, green: 0.84, blue: 0.84))
                            .frame(width: 287, height: 50)
                        
                        Text("Sign Up")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                }

                // Bottom Bar
               
                .padding(.top, 21)
                .padding(.horizontal, 128)
                .frame(width: 400, height: 34)
                
                
                
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
