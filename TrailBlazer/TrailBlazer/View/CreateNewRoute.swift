import SwiftUI

struct CreateNewRouteView: View {
    var userName: String // Accept the logged-in user's name as a parameter

    @State private var selectedLift: String = ""
    @State private var selectedDestination: String = ""
    @State private var maxDifficulty: String = ""
    @State private var isLoading: Bool = false
    @State private var showError: Bool = false
    @State private var navigateToRoutes: Bool = false // Controls navigation
    @State private var mountainID: Int = UserDefaults.standard.integer(forKey: "selectedMountainID")


    @State private var liftOptions: [String] = []
    @State private var destinationOptions: [String] = []

    @State private var difficultyLevels: [String] = ["Green", "Blue", "Black", "Double Black"]
    @State var errorMessage: String = ""
    @State var routes: [[Trail]] = []
    @State private var availableRoutes: [[String]] = []
    @State private var currentTab: Tab = .map

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                // Logo at the top
                Image("TextLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
                    .padding(.top, 20)
                // Title
                Text("Make a Route")
                    .font(Font.custom("Inter", size: 25).weight(.bold))
                    .foregroundColor(.black)
                    .padding()
                
                // Lift Taken (required)
                VStack(alignment: .leading, spacing: 8) {
                    Text("What lift did you take?")
                        .font(Font.custom("Inter", size: 16).weight(.bold))
                        .foregroundColor(.black)
                    
                    Picker("Select a lift", selection: $selectedLift) {
                        Text("Select a lift").tag("")
                        ForEach(liftOptions, id: \.self) { lift in
                            Text(lift).tag(lift)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .frame(maxWidth: 300)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    
                    // Error message
                    if showError && selectedLift.isEmpty {
                        Text("Please make a Chairlift selection")
                            .font(Font.custom("Inter", size: 14))
                            .foregroundColor(.red)
                    }
                }
                
                // Destination (not required)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Where do you want to go?")
                        .font(Font.custom("Inter", size: 16).weight(.bold))
                        .foregroundColor(.black)
                    
                    Picker("Select a destination", selection: $selectedDestination) {
                        Text("Any Destination").tag("")
                        ForEach(destinationOptions, id: \.self) { destination in
                            Text(destination).tag(destination)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .frame(maxWidth: 300)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }

                
                // Max Difficulty (not required)
                VStack(alignment: .leading, spacing: 8) {
                    Text("What is the highest difficulty you want?")
                        .font(Font.custom("Inter", size: 16).weight(.bold))
                        .foregroundColor(.black)
                    
                    Picker("Select difficulty", selection: $maxDifficulty) {
                        Text("No Limit").tag("")
                        ForEach(difficultyLevels, id: \.self) { difficulty in
                            Text(difficulty).tag(difficulty)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .frame(maxWidth: 300)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    
                    if showError && selectedLift.isEmpty {
                        Text("Please make a Difficulty selection")
                            .font(Font.custom("Inter", size: 14))
                            .foregroundColor(.red)
                    }
                }
                
                // Apply Button
                Button(action: fetchRoutes) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Apply")
                            .font(Font.custom("Inter", size: 16).weight(.bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16) // Reduced padding on sides
                            .padding(.vertical, 8)    // Reduced vertical padding
                            .frame(maxWidth: 200)     // Limiting the width of the button (or you can set a specific width like 200)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
                .padding(.vertical)
                
                // Show error message if there is one
                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(Font.custom("Inter", size: 14))
                        .padding()
                }
            }
            .padding()
            .onAppear(perform: fetchDropdownData)
            .navigationDestination(isPresented: $navigateToRoutes) {
                AvailableRoutesView(availableRoutes: availableRoutes.flatMap { $0 }, userName: userName)
            }

            Spacer()

            // Navigation Bar
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
    }

    private func fetchRoutes() {
        print("Fetch Routes triggered")
        
        guard !selectedLift.isEmpty else {
            showError = true
            errorMessage = "Please select a lift."
            return
        }

        guard let url = URL(string: "https://TrailBlazer33:5001/api/routes/find") else {
            showError = true
            errorMessage = "Invalid URL."
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = UserDefaults.standard.string(forKey: "authToken") {
            print("Token found: \(token)")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("No Auth Token Found")
            showError = true
            errorMessage = "Authentication token missing."
            return
        }
        
        let finalMaxDifficulty = maxDifficulty.isEmpty ? "Double Black" : maxDifficulty

        let requestBody: [String: Any] = [
            "chairliftName": selectedLift,
            "maxDifficulty": finalMaxDifficulty,
            "destination": selectedDestination,
            "mountainID": mountainID
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            print("Request Body: \(requestBody)")
        } catch {
            showError = true
            errorMessage = "Failed to encode request body."
            return
        }

        isLoading = true
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false

                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    self.showError = true
                    self.errorMessage = "Request failed: \(error.localizedDescription)"
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Invalid Response")
                    self.showError = true
                    self.errorMessage = "Invalid server response."
                    return
                }

                print("Response Status Code: \(httpResponse.statusCode)")

                guard let data = data else {
                    print("No Data")
                    self.showError = true
                    self.errorMessage = "No response data received."
                    return
                }

                // Debugging - Print Raw Response Data
                let rawResponse = String(data: data, encoding: .utf8) ?? "Invalid Data"
                print("Raw Response Data: \(rawResponse)")

                // Handle 404 Error (No Routes Found)
                if httpResponse.statusCode == 404 {
                    print("No suitable routes found.")
                    self.showError = true
                    self.errorMessage = "No trails exist for that route."
                    return
                }

                do {
                    // Handle JSON response correctly
                    if let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        if let message = jsonObject["message"] as? String {
                            // Handle error message from server
                            self.showError = true
                            self.errorMessage = message
                            return
                        }
                    }

                    let routes = try JSONDecoder().decode([[Trail]].self, from: data)
                    print("Parsed Routes: \(routes)")
                    self.routes = routes
                    self.availableRoutes = routes.compactMap { $0.map { $0.runName } }
                    self.navigateToRoutes = true
                } catch {
                    print("Error decoding response data: \(error.localizedDescription)")
                    self.showError = true
                    self.errorMessage = "Unexpected response format."
                }
            }
        }
        
        task.resume()
    }




    private func fetchDropdownData() {
        // Updated lift URL to include mountainID
        guard let liftUrl = URL(string: "https://TrailBlazer33:5001/api/chairlifts/\(mountainID)/lift-names/") else { return }
        var liftRequest = URLRequest(url: liftUrl)
        liftRequest.httpMethod = "GET"
        
        // Updated POI URL to include mountainID
        guard let poiUrl = URL(string: "https://TrailBlazer33:5001/api/pois/\(mountainID)") else { return }
        var poiRequest = URLRequest(url: poiUrl)
        poiRequest.httpMethod = "GET"
        
        // Fetch POIs
        URLSession.shared.dataTask(with: poiRequest) { data, response, error in
            if let error = error {
                print("Error fetching POIs: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received for POIs")
                return
            }
            
            // Log raw POI data for debugging
            do {
                // Decode POI response
                let pois = try JSONDecoder().decode([PointOfInterest].self, from: data)
                DispatchQueue.main.async {
                    self.destinationOptions = pois.map { $0.POI_name } // Extract POI names for the dropdown
                }
            } catch {
                print("Error decoding POI response: \(error.localizedDescription)")
            }
        }.resume()
        
        // Fetch Chairlifts
        URLSession.shared.dataTask(with: liftRequest) { data, response, error in
            if let error = error {
                print("Error fetching lifts: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received for lifts")
                return
            }
            
            do {
                // Decode the JSON response for lifts
                let response = try JSONDecoder().decode(LiftResponse.self, from: data)
                DispatchQueue.main.async {
                    self.liftOptions = response.lifts
                }
            } catch {
                print("Error decoding lift response: \(error.localizedDescription)")
            }
        }.resume()
    }


    // Define the response model
    struct LiftResponse: Codable {
        let message: String
        let lifts: [String]
    }
    struct PointOfInterest: Codable {
        let POI_id: Int
        let POI_name: String
        let type: String
    }
//    struct Trail: Codable {
//        let runID: Int
//        let runName: String
//        let difficulty: String
//        let startingLift: Int
//        let endingPoints: [Int]
//        let isEnd: Bool
//        let mergesTo: [Int]
//    }
    struct Trail: Decodable {
        let runID: Int
        let runName: String
        let difficulty: String
        let startingLift: Int? // Make optional if it can be null
        let endingPoints: [Int]? // Make optional and array of Ints
        let isEnd: Bool? // Make optional
        let mergesTo: [Int]? // Make optional and array of Ints
    }
}

struct CreateNewRouteView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewRouteView(userName: "John Doe") // Provide sample userName
    }
}
