import SwiftUI

struct CreateNewRouteView: View {
    @State private var fontSize: CGFloat = 12
    @State private var appliedDifficulties: Set<String> = [] // Keep track of applied difficulties
    @State private var appliedDestinations: Set<String> = [] // Keep track of applied destinations
    @State private var navigateToOnApplyRoute = false
    @State private var isHomeActive = false
    
    let routeOptions = ["Blue", "Black Diamond", "Double Black Diamond", "South Base Lodge"]

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Title Bar
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 256, height: 36)
                    .background(
                        AsyncImage(url: URL(string: "https://via.placeholder.com/256x36"))
                    )
                    .padding()
                
                // Route Selection Text
                Text("Difficulty")
                    .font(Font.custom("Inter", size: 16).weight(.bold))
                    .foregroundColor(.black)
                
                // Difficulty Section
                VStack(spacing: 0) {
                    difficultyRow(title: "Green")
                    difficultyRow(title: "Blue")
                    difficultyRow(title: "Black Diamond")
                    difficultyRow(title: "Double Black Diamond")
                }
                
                // Destination Section
                Text("Destination")
                    .font(Font.custom("Inter", size: 16).weight(.bold))
                    .foregroundColor(.black)
                
                VStack(spacing: 0) {
                    destinationRow(title: "South Base Lodge")
                    destinationRow(title: "Activity Central")
                }
                
                // Filter button at the bottom
                NavigationLink(destination: OnApplyRouteView()) {
//                    Button(action: {
//                        print("Filter button tapped")
//                        self.navigateToOnApplyRoute = true // Trigger navigation to OnApplyRoute view
//                    }) {
                        Text("Filter")
                            .font(Font.custom("Inter", size: fontSize))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(8)
//                    }
                }
                .padding([.top, .bottom])
                .onTapGesture {
                    self.navigateToOnApplyRoute = true
                }
                
                Spacer()
                
                // Navigation Bar at the Bottom
                // Navigation Bar at the Bottom
                HStack {
//                    // Home Button
                    NavigationLink(destination: HomeView()) {
                        Button(action: {
                            self.isHomeActive = true
                        }) {
                            VStack {
                                Image(systemName: "house.fill")
                                    .foregroundColor(.black)
                                Text("Home")
                                    .foregroundColor(.black)
                                    .font(.caption)
                           }
                        }                        .frame(maxWidth: .infinity)
                   }
//
//                    // Friends Button
//                    NavigationLink(destination: FriendsView(), isActive: $isFriendsActive) {
//                        Button(action: {
//                            self.isFriendsActive = true
//                        }) {
//                            VStack {
//                                Image(systemName: "person.2.fill") // Represents friends
//                                    .foregroundColor(.black)
//                                Text("Friends")
//                                    .foregroundColor(.black)
//                                    .font(.caption)
//                            }
//                        }
//                        .frame(maxWidth: .infinity)
//                    }
//
//                    // Map Button
//                    NavigationLink(destination: MapView(), isActive: $isMapActive) {
//                        Button(action: {
//                            self.isMapActive = true
//                        }) {
//                            VStack {
//                                Image(systemName: "map.fill") // Represents Map
//                                    .foregroundColor(.black)
//                                Text("Map")
//                                    .foregroundColor(.black)
//                                    .font(.caption)
//                            }
//                        }
//                        .frame(maxWidth: .infinity)
//                    }
//
//                    // Weather Button
//                    NavigationLink(destination: WeatherView(), isActive: $isWeatherActive) {
//                        Button(action: {
//                            self.isWeatherActive = true
//                        }) {
//                            VStack {
//                                Image(systemName: "cloud.sun.fill") // Represents Weather
//                                    .foregroundColor(.black)
//                                Text("Weather")
//                                    .foregroundColor(.black)
//                                    .font(.caption)
//                            }
//                        }
//                        .frame(maxWidth: .infinity)
//                    }
//
//                    // Profile Button
//                    NavigationLink(destination: ProfileView(), isActive: $isProfileActive) {
//                        Button(action: {
//                            self.isProfileActive = true
//                        }) {
//                            VStack {
//                                Image(systemName: "person.fill") // Represents Profile
//                                    .foregroundColor(.black)
//                                Text("Profile")
//                                    .foregroundColor(.black)
//                                    .font(.caption)
//                            }
//                        }
//                        .frame(maxWidth: .infinity)
//                    }
                }
                .padding()
                .background(Color.white)
                .shadow(radius: 5)
            }
        }
    }
    
    private func difficultyRow(title: String) -> some View {
        SwiftUICore.HStack(spacing: 20) {
            Text(title)
                .font(Font.custom("Inter", size: 17))
                .lineSpacing(22)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 44)
            
            Button(action: {
                toggleSelection(for: title, in: &appliedDifficulties)
            }) {
                Image(systemName: appliedDifficulties.contains(title) ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(.blue)
            }
        }
        .frame(width: 402, height: 44)
        .overlay(
            Rectangle()
                .inset(by: -0.17)
                .stroke(Color(red: 0.33, green: 0.33, blue: 0.34).opacity(0.34), lineWidth: 0.17)
        )
    }
    
    private func destinationRow(title: String) -> some View {
        SwiftUICore.HStack(spacing: 0) {
            Text(title)
                .font(Font.custom("Inter", size: 17))
                .lineSpacing(22)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 44)
            
            Button(action: {
                toggleSelection(for: title, in: &appliedDestinations)
            }) {
                Image(systemName: appliedDestinations.contains(title) ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(.blue)
            }
        }
        .frame(width: 402, height: 44)
        .overlay(
            Rectangle()
                .inset(by: -0.17)
                .stroke(Color(red: 0.33, green: 0.33, blue: 0.34).opacity(0.34), lineWidth: 0.17)
        )
    }
    
    private func toggleSelection(for title: String, in set: inout Set<String>) {
        if set.contains(title) {
            set.remove(title)
        } else {
            set.insert(title)
        }
    }
    
struct CreateNewRouteView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewRouteView()
    }
    }
}

//struct OnApplyRouteView: View {
//    var body: some View {
//        Text("Applied Route Details")
//            .font(.title)
//            .foregroundColor(.black)
//            .padding()
//    }
//}
