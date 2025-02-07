import SwiftUI

struct HomeView: View {
    var userName: String // Accepts the logged-in user's name as a parameter
    @State private var currentRoute = "None"
    @State private var currentTab: Tab = .home
    @State private var selectedMap: String = "Select a map...."
    

    var body: some View {
        
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
                
                // Map selection drop-down button (Picker)
                Picker("Select a map...", selection: $selectedMap) {
                    Text("Select a Map...").tag("Select a Map...")
                    // Add more map options here when available
                    Text("Blue Mountain").tag("Option 1")
                }
                .pickerStyle(MenuPickerStyle()) // Style it as a dropdown
                .frame(width: 200, height: 40) // Narrower frame width and height
                .padding(.horizontal, 20) // Add padding to avoid edge contact
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5) // Add padding to avoid edge contact
                
                // Buttons (same size and vertically stacked)
                VStack(spacing: 15) {
                    // View Map Button with the map image
                    NavigationLink(destination: RouteLandingView(userName: userName)) {
                        MapButton()
                            .navigationBarBackButtonHidden(false)
                    }
                    
                    // Create Route Button
                    NavigationLink(destination: CreateNewRouteView(userName: userName)) {
                        HomeButton(title: "Create Route", imageName: "plus.circle.fill")
                    }
                    
                    // View Weather Button
                    NavigationLink(destination: WeatherView(userName: userName)) {
                        HomeButton(title: "Weather", imageName: "cloud.sun.fill")
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
                
                Spacer()
                .navigationBarHidden(true)
                
                // Navigation Bar at the Bottom
                HStack {
                    TabBarItem(
                        tab: .home,
                        currentTab: $currentTab,
                        destination: {HomeView(userName: userName)},
                        imageName: "house.fill",
                        label: "Home"
                    )
                    
                    TabBarItem(
                        tab: .friends,
                        currentTab: $currentTab,
                        destination: {FriendView(userName: userName)},
                        imageName: "person.2.fill",
                        label: "Friends"
                    )
                    
                    TabBarItem(
                        tab: .map,
                        currentTab: $currentTab,
                        destination: {RouteLandingView(userName: userName)},
                        imageName: "map.fill",
                        label: "Map"
                    )
                    
                    TabBarItem(
                        tab: .metrics,
                        currentTab: $currentTab,
                        destination: {PerformanceMetricsView(userName: userName)},
                        imageName: "chart.bar.fill",
                        label: "Metrics"
                    )
                    
                    TabBarItem(
                        tab: .profile,
                        currentTab: $currentTab,
                        destination: {ProfileView(userName: userName)},
                        imageName: "person.fill",
                        label: "Profile"
                    )
                    
                }
                .padding()
                .background(Color.white)
            }
            //.padding(.horizontal, 20)
            .navigationBarBackButtonHidden(true)
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
