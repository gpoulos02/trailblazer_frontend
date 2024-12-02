import SwiftUI

struct HomeView: View {
    var userName: String // Accepts the logged-in user's name as a parameter
    @State private var currentRoute = "None"
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Text Logo at the top
                Image("TextLogo") // Replace with the name of your text logo asset
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
                    .padding(.top, 20)
                
                // Welcome message
                Text("Welcome, \(userName)")
                    .font(.title)
                    .fontWeight(.bold)
                
                // Current Route Status
                Text("Current Route: \(currentRoute)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                // Buttons (same size and vertically stacked)
                VStack(spacing: 15) {
                    // View Map Button with the map image
                    NavigationLink(destination: RouteLandingView(userName: userName)) {
                        MapButton()
                    }
                    
                    // Create Route Button
                    NavigationLink(destination: CreateNewRouteView(userName: userName)) {
                        HomeButton(title: "Create Route", imageName: "plus.circle.fill")
                    }
                    
                    // View Weather Button
                    NavigationLink(destination: WeatherView(userName: userName)) {
                        HomeButton(title: "View Weather", imageName: "cloud.sun.fill")
                    }
                }
                .padding(.top, 20)
                
                Spacer()
                
                // Navigation Bar at the Bottom
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
                            Image(systemName: "chart.bar.fill") // Represents Metrics
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
            .padding(.horizontal, 20)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct HomeButton: View {
    var title: String
    var imageName: String
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .font(.title)
                .foregroundColor(.blue)
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 60) // Ensures all buttons are the same size
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct MapButton: View {
    var body: some View {
        VStack {
            // Map Image
            Image("map")
                .resizable()
                .scaledToFit()
                .frame(height: 150) // Increased height to make the map bigger
                .cornerRadius(10)
            
            // Icon and Text Side by Side
            HStack {
                Image(systemName: "map.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
                Text("View Map")
                    .font(.headline)
                    .foregroundColor(.black)
            }
            .padding(.top, 5) // Adds some space between the image and the label
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 160) // Ensures the button is large enough
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(userName: "John Doe") // Provide a sample username for preview
    }
}
