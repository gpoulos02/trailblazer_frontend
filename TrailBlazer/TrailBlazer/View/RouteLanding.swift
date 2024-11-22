import SwiftUI

struct RouteLandingView: View {
    var userName: String // Accept the logged-in user's name as a parameter

    // Add a navigation state for each tab
    @State private var isHomeActive = false
    @State private var isFriendsActive = false
    @State private var isMapActive = false
    @State private var isWeatherActive = false
    @State private var isProfileActive = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                
                // Placeholder for a logo or title
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 256, height: 36)
                    .background(
                        AsyncImage(url: URL(string: "https://via.placeholder.com/256x36"))
                    )
                
                // Current Location Section
                HStack {
                    Text("Your Current Location")
                        .font(Font.custom("Inter", size: 12).weight(.medium))
                        .foregroundColor(Color(red: 0.25, green: 0.25, blue: 0.25))
                        .padding(.horizontal, 12) // Add padding on both sides of the text
                        .padding(.vertical, 6) // Vertical padding for balance
                        .background(Color(red: 0.94, green: 0.94, blue: 0.94)) // Rectangle background color
                        .cornerRadius(5) // Rounded corners
                }
                .frame(maxWidth: .infinity, alignment: .leading) // Ensure the HStack stretches to the width of the screen
                .padding(.leading, 16) // Add space on the left side of the screen
                
                // Placeholder Map Section
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 343, height: 362)
                    .background(
                        AsyncImage(url: URL(string: "https://via.placeholder.com/343x362"))
                    )
                    .cornerRadius(5)
                
                // Create New Route Button with NavigationLink
                NavigationLink(destination: CreateNewRouteView(userName: userName)) { // Pass `userName` to CreateNewRouteView
                    HStack(spacing: 8) {
                        Text("New Route")
                            .font(Font.custom("Inter", size: 16))
                            .lineSpacing(16)
                            .foregroundColor(Color(red: 0.96, green: 0.96, blue: 0.96))
                    }
                    .padding(12)
                    .frame(width: 144, height: 42)
                    .background(Color(red: 0.25, green: 0.61, blue: 1))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .inset(by: 0.50)
                            .stroke(Color(red: 0.25, green: 0.61, blue: 1), lineWidth: 0.50)
                    )
                }
                
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
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Map Button
                    NavigationLink(destination: RouteLandingView(userName: userName)) { // Pass `userName` to RouteLandingView
                        VStack {
                            Image(systemName: "map.fill") // Represents Map
                                .foregroundColor(.black)
                            Text("Map")
                                .foregroundColor(.black)
                                .font(.caption)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Weather Button
                    NavigationLink(destination: WeatherView()) {
                        VStack {
                            Image(systemName: "cloud.sun.fill") // Represents Weather
                                .foregroundColor(.black)
                            Text("Weather")
                                .foregroundColor(.black)
                                .font(.caption)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Profile Button
                    NavigationLink(destination: ProfileView(userName: userName)) { // Pass `userName` to ProfileView
                        VStack {
                            Image(systemName: "person.fill") // Represents Profile
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
                .navigationBarBackButtonHidden(true)
            }
        }
    }
}

struct RouteLandingView_Previews: PreviewProvider {
    static var previews: some View {
        RouteLandingView(userName: "John Doe") // Provide a sample `userName` for preview
    }
}
