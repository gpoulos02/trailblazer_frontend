import SwiftUI

struct HomeView: View {
    var userName: String // Accepts the logged-in user's name as a parameter
    @State private var currentRoute = "None"
    @State private var currentTab: Tab = .home
    @State private var mountains: [Mountain] = []
    @State private var selectedMountainID: Int? = nil
    @State private var selectedMountainImage: String = ""
    @StateObject private var locationManager = LocationManager()
    
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
            
            // Mountain selection dropdown
            Picker("Select a mountain", selection: Binding(
                get: { selectedMountainID ?? 0 },
                set: { newValue in
                    selectedMountainID = newValue
                    UserDefaults.standard.set(newValue, forKey: "selectedMountainID")
                    updateSelectedMountainImage(for: newValue)// Store in local storage
                    setMountainCoordinates(for: newValue)
                }
            )) {
                Text("Select a Mountain...").tag(0)
                ForEach(mountains, id: \ .mountainID) { mountain in
                    Text(mountain.name).tag(mountain.mountainID)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(width: 200, height: 40)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .onAppear {
                fetchMountains()
                selectedMountainID = UserDefaults.standard.integer(forKey: "selectedMountainID")
                let savedID = UserDefaults.standard.integer(forKey: "selectedMountainID")
                selectedMountainID = savedID
                updateSelectedMountainImage(for: savedID) // Retrieve from local storage
                setMountainCoordinates(for: savedID)
            }
            
            VStack(spacing: 15) {
                NavigationLink(destination: RouteLandingView(userName: userName)) {
                    MapButton(imageName: selectedMountainImage) // Pass the selected image to MapButton
                        .navigationBarBackButtonHidden(false)
                }
                NavigationLink(destination: CreateNewRouteView(userName: userName)) {
                    HomeButton(title: "Create Route", imageName: "plus.circle.fill")
                }
                NavigationLink(destination: WeatherView(userName: userName)) {
                    HomeButton(title: "Weather", imageName: "cloud.sun.fill")
                }
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
            
            Spacer()
                .navigationBarHidden(true)
            
            HStack {
                TabBarItem(
                    tab: .home,
                    currentTab: $currentTab,
                    destination: { HomeView(userName: userName) },
                    imageName: "house.fill",
                    label: "Home"
                )
                TabBarItem(
                    tab: .friends,
                    currentTab: $currentTab,
                    destination: { FriendView(userName: userName) },
                    imageName: "person.2.fill",
                    label: "Friends"
                )
                TabBarItem(
                    tab: .map,
                    currentTab: $currentTab,
                    destination: { RouteLandingView(userName: userName) },
                    imageName: "map.fill",
                    label: "Map"
                )
                TabBarItem(
                    tab: .metrics,
                    currentTab: $currentTab,
                    destination: { PerformanceMetricsView(userName: userName) },
                    imageName: "chart.bar.fill",
                    label: "Metrics"
                )
                TabBarItem(
                    tab: .profile,
                    currentTab: $currentTab,
                    destination: { ProfileView(userName: userName) },
                    imageName: "person.fill",
                    label: "Profile"
                )
            }
            .padding()
            .background(Color.white)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func updateSelectedMountainImage(for mountainID: Int) {
        // Map mountain ID to the correct image
        switch mountainID {
        case 1:
            selectedMountainImage = "blueMountainLogo" // Replace with actual image name
        case 2:
            selectedMountainImage = "bolerMountainLogo" // Replace with actual image name
        default:
            selectedMountainImage = "FullLogo" // Default image
        }
    }
    private func setMountainCoordinates(for mountainID: Int) {
        locationManager.stopUpdatingLocation()
        locationManager.useFixedLocation = true
        switch mountainID {
        case 1:
            locationManager.setFixedLocation(latitude: 44.5011, longitude: -80.3161) // Blue Mountain coordinates
            
        case 2:
            locationManager.setFixedLocation(latitude: 42.9444, longitude: -81.3394) // Boler Mountain coordinates
        default:
            print("No fixed coordinates for this mountain")
        }
    }
    
    
    private func fetchMountains() {
        guard let url = URL(string: "https://TrailBlazer33:5001/api/mountains") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching mountains: \(error.localizedDescription)")
                return
            }
            guard let data = data else { return }
            
            do {
                let decodedMountains = try JSONDecoder().decode([Mountain].self, from: data)
                DispatchQueue.main.async {
                    self.mountains = decodedMountains
                }
            } catch {
                print("Error decoding mountains: \(error.localizedDescription)")
            }
        }.resume()
    }
}

struct Mountain: Codable {
    let mountainID: Int
    let name: String
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
        .frame(maxWidth: .infinity, minHeight: 60)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct MapButton: View {
    var imageName: String
    
    var body: some View {
        VStack {
            Image(imageName) // Display the image passed
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                .cornerRadius(10)
            HStack {
                Image(systemName: "map.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
                Text("View Map")
                    .font(.headline)
                    .foregroundColor(.black)
            }
            .padding(.top, 5)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 160)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(userName: "John Doe")
    }
}
