import SwiftUI

struct TrailBlazerView: View {
    var body: some View {
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
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(red: 0.55, green: 0.74, blue: 0.96))
                    .frame(width: 287, height: 50)
                
                Text("Log In")
                    .font(.title2)
                    .foregroundColor(.black)
            }
            
            // Sign Up Button
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(red: 0.84, green: 0.84, blue: 0.84))
                    .frame(width: 287, height: 50)
                
                Text("Sign Up")
                    .font(.title2)
                    .foregroundColor(.black)
            }

            // Time and Status Icons
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 134) {
                    HStack(spacing: 10) {
                        Text("9:41")
                            .font(.body)
                            .lineSpacing(22)
                            .foregroundColor(.black)
                    }
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 6))
                    .frame(maxWidth: .infinity, minHeight: 22, maxHeight: 22)
                    
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 124, height: 10)
                    
                    HStack(spacing: 7) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 4.30)
                                .stroke(.black, lineWidth: 0.50)
                                .frame(width: 25, height: 13)
                                .opacity(0.35)
                            
                            Rectangle()
                                .fill(.black)
                                .frame(width: 21, height: 9)
                                .cornerRadius(2.5)
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 16))
                    .frame(maxWidth: .infinity, minHeight: 13, maxHeight: 13)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.top, 21)
            .frame(width: 402, height: 50)

            // Bottom Bar
            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 100)
                    .fill(Color.black)
                    .frame(width: 144, height: 5)
                    .rotationEffect(.degrees(-180))
            }
            .padding(.top, 21)
            .padding(.horizontal, 128)
            .frame(width: 400, height: 34)
        }
        .padding()
    }
}

struct TrailBlazerView_Previews: PreviewProvider {
    static var previews: some View {
        TrailBlazerView()
    }
}
