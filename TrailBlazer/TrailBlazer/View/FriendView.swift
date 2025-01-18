import SwiftUI

struct FriendView: View {
    var userName: String // Accepts the logged-in user's name as a parameter

    var body: some View {
        VStack(spacing: 20) {
            // Placeholder content for connecting with friends, performance metrics, and location sharing
            VStack {
                Text("Connect with Friends")
                    .font(Font.custom("Inter", size: 25).weight(.bold))
                    .foregroundColor(.black)
                    .padding()
                
                // Add buttons or features related to adding/viewing friends
                Button(action: {
                    // Action for adding a friend
                    print("Add friend tapped")
                }) {
                    Text("Add Friend")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Text("Share Performance Metrics")
                    .font(.title2)
                    .padding()
                
                Button(action: {
                    // Action for sharing performance metrics
                    print("Share performance metrics tapped")
                }) {
                    Text("Share Metrics")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Text("Share Your Location")
                    .font(.title2)
                    .padding()
                
                Button(action: {
                    // Action for sharing location
                    print("Share location tapped")
                }) {
                    Text("Share Location")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            
            Spacer()

            // Navigation Bar at the Bottom
            HStack {
                // Home Button
                NavigationLink(destination: HomeView(userName: userName)) { // Pass `userName` to HomeView
                    VStack {
                        Image(systemName: "house.fill")
                            .foregroundColor(.black)
                        Text("Home")
                            .foregroundColor(.black)
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                
                // Friends Button
                NavigationLink(destination: FriendView(userName: userName)) { // Pass `userName` to FriendView
                    VStack {
                        Image(systemName: "person.2.fill") // Represents friends
                            .foregroundColor(.black)
                        Text("Friends")
                            .foregroundColor(.black)
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                
                // Map Button
                NavigationLink(destination: RouteLandingView(userName: userName)) { // Pass `userName` to SetNewRouteView
                    VStack {
                        Image(systemName: "map.fill") // Represents Map
                            .foregroundColor(.black)
                        Text("Map")
                            .foregroundColor(.black)
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                }
                

                // Metrics Button
                NavigationLink(destination: PerformanceMetricsView(userName: userName)) {
                    VStack {
                        Image(systemName: "chart.bar.fill") // Represents Metrics
                            .foregroundColor(.black)
                        Text("Metrics")
                            .foregroundColor(.black)
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                
                // Profile Button
                NavigationLink(destination: ProfileView(userName: userName)) { // Pass `userName` to ProfileView
                    VStack {
                        Image(systemName: "person.fill") // Represents Profile
                            .foregroundColor(.black)
                        Text("Profile")
                            .foregroundColor(.black)
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                }
                
            }
            .padding()
            .background(Color.white)
            //.shadow(radius: 5)
        }
        .padding(.horizontal, 20)
    }
}

struct FriendView_Previews: PreviewProvider {
    static var previews: some View {
        FriendView(userName: "John Doe") // Provide a sample userName for preview
    }
}
