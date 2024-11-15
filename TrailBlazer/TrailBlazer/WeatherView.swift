import SwiftUI

struct WeatherView: View {
    // Sample data - Replace with actual data when connected to a backend
    @State private var weatherInfo = "Sunny, 15°C"
    @State private var notifications = ["Snowstorm warning", "High wind alert", "Clear skies today"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Weather Info Section
                HStack {
                    // Weather Icon
                    Image(systemName: "cloud.sun.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.yellow)
                    
                    // Weather Text
                    VStack(alignment: .leading) {
                        Text("Current Weather")
                            .font(.headline)
                        Text(weatherInfo)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                
                Divider()
                
                // Recent Notifications Section
                VStack(alignment: .leading) {
                    Text("Recent Notifications")
                        .font(.headline)
                        .padding(.leading, 16)
                    
                    // List of notifications
                    List {
                        ForEach(notifications, id: \.self) { notification in
                            HStack {
                                Text(notification)
                                Spacer()
                                // Swipe to delete notification
                                Button(action: {
                                    // Find the index of the notification to delete
                                    if let index = notifications.firstIndex(of: notification) {
                                        notifications.remove(at: index)
                                    }
                                }) {
                                    Image(systemName: "trash.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        .onDelete(perform: deleteNotification) // Perform delete using index
                    }
                }
                
                Spacer()
                
                // Bottom Navigation Bar
                HStack {
                    // Home Button
                    NavigationLink(destination: HomeView()) {
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
                    NavigationLink(destination: FriendView()) {
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
                    NavigationLink(destination: RouteLandingView()) {
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
                   
                    // Profile Button (Navigates to Profile View)
                    NavigationLink(destination: ProfileView()) {
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
            .edgesIgnoringSafeArea(.bottom) // Ensures bottom navigation bar is not obstructed by safe area
            .padding()
        }
    }
    
    // Delete notification using IndexSet
    func deleteNotification(at offsets: IndexSet) {
        notifications.remove(atOffsets: offsets)
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
            .previewDevice("iPhone 14")
    }
}
