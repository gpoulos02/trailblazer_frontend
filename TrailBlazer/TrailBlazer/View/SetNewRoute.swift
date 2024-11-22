import SwiftUI

struct SetNewRouteView: View {
    var userName: String // Accept the user's name as a parameter

    var body: some View {
        VStack(spacing: 20) {
            // Placeholder for a title or logo
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 256, height: 36)
                .background(
                    AsyncImage(url: URL(string: "https://via.placeholder.com/256x36"))
                )
            
            // Placeholder for map or saved routes section
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 343, height: 362)
                .background(
                    AsyncImage(url: URL(string: "https://via.placeholder.com/343x362"))
                )
                .cornerRadius(5)
            
            // "Set New Route" Button
            HStack(spacing: 8) {
                Text("Set New Route")
                    .font(Font.custom("Inter", size: 16))
                    .lineSpacing(16)
                    .foregroundColor(Color(red: 0.96, green: 0.96, blue: 0.96))
            }
            .padding(12)
            .frame(width: 144, height: 42)
            .background(Color(red: 0.17, green: 0.17, blue: 0.17))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .inset(by: 0.50)
                    .stroke(Color(red: 0.17, green: 0.17, blue: 0.17), lineWidth: 0.50)
            )
            
            // "Saved Routes" Button
            HStack(spacing: 8) {
                Text("Saved Routes")
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
                }
                .frame(maxWidth: .infinity)
                
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
        }
    }
}

struct SetNewRouteView_Previews: PreviewProvider {
    static var previews: some View {
        SetNewRouteView(userName: "John Doe") // Provide a sample `userName` for preview
    }
}
