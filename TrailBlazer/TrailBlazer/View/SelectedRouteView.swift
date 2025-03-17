import SwiftUI
import MapboxMaps
import CoreLocation

struct SelectedRouteView: View {
    let routeName: String // Passed from the previous view
    @State private var timerRunning: Bool = false
    @State private var startTime: Date? = nil
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer? = nil
    @ObservedObject private var locationManager = LocationManager()
    @State private var finalSpeed: Double = 0.0
    @State private var finalElevation: Double = 0.0
    @State private var finalTime: TimeInterval = 0.0
    @State private var finalDistance: Double = 0.0
    @State private var endRouteDate: String = ""
    @State private var currentTab: Tab = .map
    @State private var showSaveDeleteButtons = false
    @State private var showSharePrompt = false
    @State private var shareTitle = ""
    @State private var mapView: MapView?
    @State private var apiKey: String? = nil
    @State private var errorMessage: String? = nil
    @State private var isLoading = true
    @State private var routeStatusMessage: String? = nil

    
    @State private var mountainID: Int = UserDefaults.standard.integer(forKey: "selectedMountainID")

    
    var userName: String
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HStack {
                    // Left-aligned route name
                    Text("\(routeName)")
                        .font(Font.custom("Inter", size: 20).weight(.bold))
                        .foregroundColor(.black)

                    Spacer()

                    // Right-aligned "Share with friends" button
                    Button(action: {
                        showSharePrompt.toggle()
                    }) {
                        Text("Share")
                            .font(Font.custom("Inter", size: 16).weight(.bold))
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                    .sheet(isPresented: $showSharePrompt) {
                        VStack(spacing: 20) {
                            Text("Enter Title")
                                .font(Font.custom("Inter", size: 20).weight(.bold))
                                .padding(.top)

                            TextField("Enter title", text: $shareTitle)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()

                            HStack {
                                Button("Cancel") {
                                    showSharePrompt = false
                                }
                                .padding()

                                Button("Share") {
                                    shareRoute()
                                    showSharePrompt = false
                                }
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            }
                        }
                        .padding()
                    }
                }

                ZStack {
                    if let errorMessage = errorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.red.opacity(0.2))
                    } else if isLoading {
                        ProgressView("Loading map...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .onAppear {
                                fetchApiKey()
                            }
                    } else if let apiKey = apiKey {
                        // Display the MapViewWrapper with the user's location
                        MapViewWrapper(apiKey: apiKey)
                            .edgesIgnoringSafeArea(.all)
                    } else {
                        Text("Failed to load map.")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.gray.opacity(0.2))
                    }
                }

                // Metrics Section
                HStack(spacing: 40) {
                    VStack {
                        Text("Speed")
                            .font(Font.custom("Inter", size: 16))
                            .foregroundColor(.black)
                        Text("\(String(format: "%.1f", locationManager.currentSpeed)) m/s")
                            .font(Font.custom("Inter", size: 16).weight(.bold))
                            .foregroundColor(.blue)
                    }

                    VStack {
                        Text("Elevation")
                            .font(Font.custom("Inter", size: 16))
                            .foregroundColor(.black)
                        Text("\(String(format: "%.1f", locationManager.currentElevation)) m")
                            .font(Font.custom("Inter", size: 16).weight(.bold))
                            .foregroundColor(.blue)
                    }

                    VStack {
                        Text("Distance")
                            .font(Font.custom("Inter", size: 16))
                            .foregroundColor(.black)
                        Text("\(String(format: "%.2f", locationManager.totalDistance)) meters")
                            .font(Font.custom("Inter", size: 16).weight(.bold))
                            .foregroundColor(.blue)
                    }
                }

                // Timer
                Text("\(formatTime(elapsedTime))")
                    .font(Font.custom("Inter", size: 16))
                    .foregroundColor(.black)

                // Start/End Route Button
                Button(action: toggleTimer) {
                    Text(timerRunning ? "End Route" : "Start Route")
                        .font(Font.custom("Inter", size: 16).weight(.bold))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(timerRunning ? Color.red : Color.blue)
                        .cornerRadius(8)
                }
                .padding(.vertical)

                // Save/Delete Buttons (Visible after End Route is clicked)
                if showSaveDeleteButtons {
                    HStack(spacing: 20) {
                        // Save Route Button
                        Button(action: { saveSessionData() }) {
                            Text("Save")
                                .font(Font.custom("Inter", size: 16).weight(.bold))
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .cornerRadius(8)
                        }

                        // Delete Route Button
                        Button(action: deleteRoute) {
                            Text("Delete")
                                .font(Font.custom("Inter", size: 16).weight(.bold))
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.vertical)

                    if let statusMessage = routeStatusMessage {
                        Text(statusMessage)
                            .font(Font.custom("Inter", size: 14))
                            .foregroundColor(.gray)
                            .padding(.top, 5)
                    }
                }

                Spacer()

                // Performance Metrics Button (Always interactive and grey)
                NavigationLink(destination: PerformanceMetricsView(userName: userName)) {
                    Text("Performance Metrics")
                        .font(Font.custom("Inter", size: 16).weight(.bold))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                .padding(.bottom)

                // Custom Tab Bar with Proper Shadow
                ZStack {
                    Color.white
                        .edgesIgnoringSafeArea(.bottom)

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
                    .shadow(radius: 5) // Adds consistent shadow without a box effect
                }
            }
            .padding()
            .onDisappear {
                stopTimer()
                locationManager.stopUpdatingLocation()
            }
        }
    }

    private func fetchApiKey() {
            guard let url = URL(string: "https://TrailBlazer33:5001/api/map/key") else {
                errorMessage = "Invalid API URL"
                isLoading = false
                return
            }

            URLSession.shared.dataTask(with: url) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        errorMessage = error.localizedDescription
                        isLoading = false
                        return
                    }

                    guard let data = data,
                          let result = try? JSONDecoder().decode([String: String].self, from: data),
                          let key = result["key"] else {
                        errorMessage = "Failed to decode API response"
                        isLoading = false
                        return
                    }

                    apiKey = key
                    isLoading = false
                }
            }.resume()
        }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let seconds = Int(time) % 60
        let minutes = (Int(time) / 60) % 60
        let hours = Int(time) / 3600
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    private func toggleTimer() {
        if timerRunning {
            stopTimer()
            if let start = startTime {
                elapsedTime += Date().timeIntervalSince(start)
            }
            print("Here!!")
            
            print( routeName)
            
            saveMetrics()
            showSaveDeleteButtons = true
        } else {
            startTime = Date()
            timerRunning = true
            startTimer()
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if let start = startTime {
                elapsedTime = Date().timeIntervalSince(start)
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        timerRunning = false
    }
    
    private func saveMetrics() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        endRouteDate = formatter.string(from: Date())
//        print("Saving metrics: \(elapsedTime) seconds, Speed: \(locationManager.currentSpeed), Elevation: \(locationManager.currentElevation), Date: \(endRouteDate), distance: \(locationManager.totalDistance)")
        finalTime = elapsedTime
        finalSpeed = locationManager.currentSpeed
        finalElevation = locationManager.currentElevation
        finalDistance = locationManager.totalDistance
    }
    
    private func saveRoute() {
        //print("Route saved: \(routeName), \(finalTime) seconds, \(finalSpeed) m/s, \(finalElevation) m elevation")
        resetRoute()
    }
    
    private func deleteRoute() {
        resetRoute()
    }
    
    private func resetRoute() {
        startTime = nil
        elapsedTime = 0
        finalSpeed = 0
        finalElevation = 0
        finalTime = 0
        showSaveDeleteButtons = false
    }
    
    func routeNametoID(completion: @escaping (String?) -> Void) {
                guard let token = UserDefaults.standard.string(forKey: "authToken"),
                      let url = URL(string: "https://TrailBlazer33:5001/api/routes/runIDByName?runName=\(routeName)") else {
                    print("Invalid URL or missing token")
                    completion(nil)
                    return
                }
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                // Send GET request to retrieve runID by routeName
                URLSession.shared.dataTask(with: request) { data, response, error in
                    DispatchQueue.main.async {
                        if let error = error {
                            print("Error fetching runID:", error.localizedDescription)
                            completion(nil)
                            return
                        }
                        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                            print("Failed to fetch runID. Invalid response.")
                            completion(nil)
                            return
                        }
                        guard let data = data else {
                            print("No data received")
                            completion(nil)
                            return
                        }
                        // Debugging the response
                        if let responseString = String(data: data, encoding: .utf8) {
                            print("Server response: \(responseString)")
                        }
                        // Parse the response JSON to extract runID
                        do {
                            if let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                               let runID = jsonResponse["runID"] as? String {
                                completion(runID)
                            } else {
                                print("Invalid response format or missing runID")
                                completion(nil)
                            }
                        } catch {
                            print("Failed to decode JSON response:", error.localizedDescription)
                            completion(nil)
                        }
                    }
                }.resume()
            }
    
    func saveSessionData() {
        routeNametoID { runID in
                guard let runID = runID else {
                    print("Failed to fetch runID")
                    return
                }
                
                print(runID)
            
                // Ensure the token is available
                guard let token = UserDefaults.standard.string(forKey: "authToken"),
                      let url = URL(string: "https://TrailBlazer33:5001/api/metrics") else {
                    print("Invalid URL or missing token")
                    return
                }
                
    //            let sessionData: [String: Any] = [
    //                "topSpeed": locationManager.currentSpeed,
    //                "distance": locationManager.totalDistance,
    //                "elevationGain": locationManager.currentElevation,
    //                "duration": elapsedTime
    //            ]
                
            // Generate random values for session data
            let topSpeed = Double.random(in: 10...50) // Random speed between 10 and 50
            let distance = Double.random(in: 10...500) // Random distance between 10 and 500
            let elevationGain = Double.random(in: 10...500) // Random elevation gain between 10 and 500
            let duration = Double.random(in: 10...300) // Random duration between 10 and 300 minutes
            
            let sessionData: [String: Any] = [
                "topSpeed": topSpeed,
                "distance": distance,
                "elevationGain": elevationGain,
                "duration": duration
            ]
                // Prepare the payload (the JSON object)
                let payload: [String: Any] = [
                    "sessionData": sessionData,
                    "runID": runID,
                    "mountainID": mountainID]
            
                print("Session data:", locationManager.currentSpeed, locationManager.totalDistance, locationManager.currentElevation, elapsedTime)
                
                // Serialize the data
                guard let jsonData = try? JSONSerialization.data(withJSONObject: payload) else {
                    print("Failed to serialize JSON")
                    return
                }
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                
                // Upload task
                URLSession.shared.uploadTask(with: request, from: jsonData) { data, response, error in
                    DispatchQueue.main.async {
                        if let error = error {
                            print("Error saving session:", error.localizedDescription)
                            return
                        }
                        
                        guard let httpResponse = response as? HTTPURLResponse else {
                            print("No response from server")
                            return
                        }
                        
                        if httpResponse.statusCode == 201 {
                            print("Session saved successfully!")
                            routeStatusMessage = "Route has been saved."
                        } else {
                            print("Failed to save session. Status code: \(httpResponse.statusCode)")
                            routeStatusMessage = "Route did not save."
                        }
                        
                        // Optional: Log server response if data is returned
                        if let data = data, let responseString = String(data: data, encoding: .utf8) {
                            print("Server response:", responseString)
                        }
                    }
                }.resume()
            }
        }
    
    private func shareRoute() {
        routeNametoID { routeID in
            guard let routeID = routeID else {
                print("DEBUG: Failed to get route ID")
                return
            }

            print("DEBUG: Retrieved routeID:", routeID) // Ensure routeID is retrieved

            // Ensure the token is available
            guard let token = UserDefaults.standard.string(forKey: "authToken"),
                  let url = URL(string: "https://TrailBlazer33:5001/api/posts/route") else {
                print("DEBUG: Invalid URL or missing token")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            // Ensure that routeID and title are set
            let body: [String: Any] = [
                "routeID": routeID,
                "title": shareTitle,
                "type": "route"  // Explicitly set the type to 'route'
            ]

            print("DEBUG: Request Body:", body) // Debugging body content

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
                request.httpBody = jsonData
            } catch {
                print("DEBUG: Failed to serialize request body:", error.localizedDescription)
                return
            }

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("DEBUG: Error sharing route:", error.localizedDescription)
                    return
                }

                if let response = response as? HTTPURLResponse {
                    print("DEBUG: HTTP Status Code:", response.statusCode)
                    
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print("DEBUG: Response Body:", responseString)
                    }

                    if response.statusCode == 201 {
                        print("DEBUG: Route shared successfully!")
                    } else {
                        print("DEBUG: Failed to share route")
                    }
                }
            }
            task.resume()
        }
    }
    
    struct MapViewWrapper: UIViewRepresentable {
        var apiKey: String
        @ObservedObject var locationManager = LocationManager()

        func makeUIView(context: Context) -> MapView {
            MapboxOptions.accessToken = apiKey
            
            let options = MapInitOptions(styleURI: StyleURI(rawValue: "mapbox://styles/gpoulakos/cm3nt0prt00m801r25h8wajy5"))
            let mapView = MapView(frame: .zero, mapInitOptions: options)

            let cameraOptions = CameraOptions(zoom: 14.0, bearing: 0.0, pitch: 45.0)
            mapView.mapboxMap.setCamera(to: cameraOptions)

            context.coordinator.mapView = mapView
            locationManager.delegate = context.coordinator

            let locationOptions = LocationOptions(
                puckType: .puck2D(),
                puckBearing: .heading
            )
            mapView.location.options = locationOptions

            locationManager.startUpdatingLocation()

            return mapView
        }

        func updateUIView(_ uiView: MapView, context: Context) {}

        func makeCoordinator() -> Coordinator {
            return Coordinator()
        }

        class Coordinator: NSObject, LocationManagerDelegate {
            var mapView: MapView?

            func didUpdateLocation(_ location: CLLocation) {
                guard let mapView = mapView else { return }

                let coordinate = location.coordinate
                let cameraOptions = CameraOptions(
                    center: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude),
                    zoom: 14.0,
                    bearing: 0.0,
                    pitch: 45.0
                )
                mapView.mapboxMap.setCamera(to: cameraOptions)

                print("Updated location: \(coordinate.latitude), \(coordinate.longitude)")
            }
        }
    }




    
    struct SelectedRouteView_Previews: PreviewProvider {
        static var previews: some View {
            SelectedRouteView(routeName: "Route 1", userName: "sampleUser")
        }
    }
    
}
