import SwiftUI

struct AvailableRoutesView: View {
    let availableRoutes: [[String]]
    var userName: String
    @State private var currentTab: Tab = .map
    @State private var routeDifficulties: [String: String] = [:]
    
    @State private var mountainID: Int = UserDefaults.standard.integer(forKey: "selectedMountainID")

    var body: some View {
        VStack(spacing: 20) {
            Image("TextLogo")
                .resizable()
                .scaledToFit()
                .frame(height: 40)
                .padding(.top, 20)
            
            Text("Select Your Route")
                .font(Font.custom("Inter", size: 25).weight(.bold))
                .foregroundColor(.black)
                .padding()

            if availableRoutes.isEmpty {
                Text("No routes available. Try a new combination.")
                    .font(Font.custom("Inter", size: 16))
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(availableRoutes.indices, id: \.self) { index in
                            let route = availableRoutes[index]
                            let routeDisplay = route.joined(separator: " → ")
                            
                            NavigationLink(
                                destination: SelectedRouteView(routeName: routeDisplay, userName: userName),
                                label: {
                                    HStack {
                                        Text(routeDisplay)
                                            .font(Font.custom("Inter", size: 16))
                                            .foregroundColor(.black)
                                            .padding(.leading, 10) // Adds padding on the left

                                        Spacer() // Pushes icons to the right
                                        
                                        getDifficultyIcons(for: route) // Icons on the far right
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                                    .padding(.horizontal)
                                }
                            )
                        }
                    }
                }
            }
            
            Spacer()
            bottomTabBar
        }
        .onAppear { fetchDifficulties() }
        .navigationBarBackButtonHidden(true)
    }
    
    // Bottom Navigation Bar
    private var bottomTabBar: some View {
        HStack {
            TabBarItem(tab: .home, currentTab: $currentTab, destination: { HomeView(userName: userName) }, imageName: "house.fill", label: "Home")
            TabBarItem(tab: .friends, currentTab: $currentTab, destination: { FriendView(userName: userName) }, imageName: "person.2.fill", label: "Friends")
            TabBarItem(tab: .map, currentTab: $currentTab, destination: { RouteLandingView(userName: userName) }, imageName: "map.fill", label: "Map")
            TabBarItem(tab: .metrics, currentTab: $currentTab, destination: { PerformanceMetricsView(userName: userName) }, imageName: "chart.bar.fill", label: "Metrics")
            TabBarItem(tab: .profile, currentTab: $currentTab, destination: { ProfileView(userName: userName) }, imageName: "person.fill", label: "Profile")
        }
        .padding()
        .background(Color.white)
    }
    
    // Fetch trail difficulties
    private func fetchDifficulties() {
        let trailNames = availableRoutes.flatMap { $0 }
        guard let url = URL(string: "https://TrailBlazer33:5001/api/trails/\(mountainID)/trail-difficulty") else { return }
        
        // Log the URL and the request body
        print("Request URL: \(url)")
        print("Request body: \(trailNames)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = [
            "trailNames": trailNames,
            "mountainID": mountainID
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")  // Log the error if any
                return
            }

            // Log the HTTP response status code
            if let httpResponse = response as? HTTPURLResponse {
                print("Response Status Code: \(httpResponse.statusCode)")
            }

            guard let data = data else {
                print("No data received")
                return
            }
            
            // Log the raw response data
            if let rawString = String(data: data, encoding: .utf8) {
                print("Raw response data: \(rawString)")  // Log the raw response data
            }

            // Attempt to decode the data
            if let difficulties = try? JSONDecoder().decode([String: String].self, from: data) {
                DispatchQueue.main.async {
                    print("Received difficulties: \(difficulties)")  // Log the decoded difficulties
                    self.routeDifficulties = difficulties
                }
            } else {
                print("Failed to decode data")  // Log decoding failure
            }
        }.resume()
    }

    
    // Get difficulty icons for a route
    private func getDifficultyIcons(for route: [String]) -> some View {
        HStack {
            ForEach(route.prefix(2), id: \.self) { trail in
                if let difficulty = routeDifficulties[trail], !difficulty.isEmpty {
                    Image(difficulty)
                        .resizable()
                        .frame(width: 20, height: 20)
                } else {
                    // Use a default icon if no difficulty is found
                    Image(systemName: "questionmark.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
            if route.count > 2 {
                Text("+")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .frame(width: 50)  // Ensure that this view fits in the expected layout.
    }

}

struct AvailableRoutesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AvailableRoutesView(
                availableRoutes: [["Trail A", "Trail B"], ["Trail C", "Trail D", "Trail E"]],
                userName: "sampleUser"
            )
        }
    }
}
