import SwiftUI

struct FriendView: View {
    var userName: String // Accepts the logged-in user's name as a parameter

    @State private var navigateToFriendRequests = false

    var body: some View {
        VStack(spacing: 20) {
            // Top bar with logo and add friend button
            HStack {
                Image("TextLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                    .padding(.leading, 20)
                
                Spacer()
                
                Button(action: {
                        navigateToFriendRequests = true
                    }) {
                        Image("AddFriend")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                            .padding(.trailing, 20)
                    }
                }
                .padding(.top, 20)
                .background(
                    NavigationLink("", destination: FriendRequestsView(userName: userName), isActive: $navigateToFriendRequests)
                )
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.gray.opacity(0.5))
                .padding(.horizontal, 20)

           
            
            // Scrollable Friends Section
            HStack(spacing: 10) {
                Image("Location")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                
                Rectangle()
                    .frame(width: 1, height: 30)
                    .foregroundColor(.black)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        Text("Add friends to see their location!")
                            .font(.body)
                            .foregroundColor(.black)
                    }
                    .padding(.leading, 10)
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            // Bottom Navigation Bar
            HStack {
                NavigationLink(destination: HomeView(userName: userName)) {
                    VStack {
                        Image(systemName: "house.fill")
                            .foregroundColor(.black)
                        Text("Home")
                            .foregroundColor(.black)
                            .font(.caption)
                    }
                }
                .frame(maxWidth: .infinity)
                
                NavigationLink(destination: FriendView(userName: userName)) {
                    VStack {
                        Image(systemName: "person.2.fill")
                            .foregroundColor(.black)
                        Text("Friends")
                            .foregroundColor(.black)
                            .font(.caption)
                    }
                }
                .frame(maxWidth: .infinity)
                
                NavigationLink(destination: RouteLandingView(userName: userName)) {
                    VStack {
                        Image(systemName: "map.fill")
                            .foregroundColor(.black)
                        Text("Map")
                            .foregroundColor(.black)
                            .font(.caption)
                    }
                }
                .frame(maxWidth: .infinity)

                NavigationLink(destination: PerformanceMetricsView(userName: userName)) {
                    VStack {
                        Image(systemName: "chart.bar.fill")
                            .foregroundColor(.black)
                        Text("Metrics")
                            .foregroundColor(.black)
                            .font(.caption)
                    }
                }
                .frame(maxWidth: .infinity)
                
                NavigationLink(destination: ProfileView(userName: userName)) {
                    VStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.black)
                        Text("Profile")
                            .foregroundColor(.black)
                            .font(.caption)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .background(Color.white)
            .shadow(radius: 5)
        }
    }
}

struct FriendView_Previews: PreviewProvider {
    static var previews: some View {
        FriendView(userName: "John Doe")
    }
}
