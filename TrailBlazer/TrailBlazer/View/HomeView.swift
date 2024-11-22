import SwiftUI

struct HomeView: View {
    var userName: String // Accepts the logged-in user's name as a parameter
    @State private var currentRoute = "None"
    @State private var isHomeActive = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Header
                Text("Welcome, \(userName)")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                
                // Current Route Status
                Text("Current Route: \(currentRoute)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 40)
                
                // Quick Access Buttons (Create New Route and Set New Route)
                HStack {
                    NavigationLink(destination: CreateNewRouteView(userName: userName)) { // Pass userName
                        HomeButton(title: "Create New Route", imageName: "plus.circle.fill")
                    }
                    NavigationLink(destination: SetNewRouteView(userName: userName)) { // Pass userName
                        HomeButton(title: "Set New Route", imageName: "map.fill")
                    }
                }
                .padding()
                
                // Weather Widget
                NavigationLink(destination: WeatherView()) {
                    VStack {
                        HStack {
                            Image(systemName: "cloud.sun.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.blue)
                            
                            Text("Weather")
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                }
                .padding(.top, 20)
                
                Spacer() // Pushes content upwards so the bottom navigation stays at the bottom
                
                // Navigation Bar at the Bottom
                HStack {
                    // Home Button
                    NavigationLink(destination: HomeView(userName: userName)) { // Pass userName
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
                    NavigationLink(destination: FriendView(userName: userName)) { // Pass userName
                        VStack {
                            Image(systemName: "person.2.fill")
                                .foregroundColor(.black)
                            Text("Friends")
                                .foregroundColor(.black)
                                .font(.caption)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Map Button
                    NavigationLink(destination: SetNewRouteView(userName: userName)) { // Pass userName
                        VStack {
                            Image(systemName: "map.fill")
                                .foregroundColor(.black)
                            Text("Map")
                                .foregroundColor(.black)
                                .font(.caption)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Profile Button
                    NavigationLink(destination: ProfileView(userName: userName)) { // Pass userName
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
        .frame(maxWidth: .infinity)
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
