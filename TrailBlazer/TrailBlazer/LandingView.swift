import SwiftUI

struct TrailBlazerView: View {
    var body: some View {
        VStack {
            Text("Welcome to TrailBlazer\n\nYour all-in-one ski and snowboarding companion")
                .font(.title) // Changed to system title font
                .foregroundColor(.black)

            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 389, height: 368)
                .background(
                    AsyncImage(url: URL(string: "https://via.placeholder.com/389x368"))
                )

            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 287, height: 50)
                .background(Color(red: 0.55, green: 0.74, blue: 0.96))
                .cornerRadius(5)

            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 287, height: 50)
                .background(Color(red: 0.84, green: 0.84, blue: 0.84))
                .cornerRadius(5)

            Text("Log In")
                .font(.title2) // Changed to system title2 font
                .foregroundColor(.black)

            Text("Sign Up")
                .font(.title2) // Changed to system title2 font
                .foregroundColor(.black)

            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 134) {
                    HStack(spacing: 10) {
                        Text("9:41")
                            .font(.body) // Changed to system body font
                            .lineSpacing(22)
                            .foregroundColor(.black)
                    }
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 6))
                    .frame(maxWidth: .infinity, minHeight: 22, maxHeight: 22)
                    
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 124, height: 10)
                    
                    HStack(spacing: 7) {
                        ZStack() {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 25, height: 13)
                                .cornerRadius(4.30)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4.30)
                                        .inset(by: 0.50)
                                        .stroke(.black, lineWidth: 0.50)
                                )
                                .offset(x: -1.16, y: 0)
                                .opacity(0.35)
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 21, height: 9)
                                .background(.black)
                                .cornerRadius(2.50)
                                .offset(x: -1.16, y: 0)
                        }
                        .frame(width: 27.33, height: 13)
                    }
                    .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 16))
                    .frame(maxWidth: .infinity, minHeight: 13, maxHeight: 13)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(EdgeInsets(top: 21, leading: 0, bottom: 0, trailing: 0))
            .frame(width: 402, height: 50)

            HStack(spacing: 0) {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 144, height: 5)
                    .background(.black)
                    .cornerRadius(100)
                    .rotationEffect(.degrees(-180))
            }
            .padding(EdgeInsets(top: 21, leading: 128, bottom: 8, trailing: 128))
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
