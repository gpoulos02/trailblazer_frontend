import SwiftUI

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
                        Text("Share with friends")
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
                
                // Map Placeholder
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 200)
                    .cornerRadius(8)
                    .overlay(
                        Text("Map View (Coming Soon)")
                            .font(Font.custom("Inter", size: 16))
                            .foregroundColor(.black.opacity(0.7))
                    )
                
                // Metrics
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
                Text("Elapsed Time: \(formatTime(elapsedTime))")
                    .font(Font.custom("Inter", size: 16))
                    .foregroundColor(.black)
                
                // Start/End Button
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
                            Text("Save Route")
                                .font(Font.custom("Inter", size: 16).weight(.bold))
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .cornerRadius(8)
                        }
                        
                        // Delete Route Button
                        Button(action: deleteRoute) {
                            Text("Delete Route")
                                .font(Font.custom("Inter", size: 16).weight(.bold))
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.vertical)
                }
                
                Spacer()
                
                // Performance Metrics Button (Always interactive and grey)
                NavigationLink(destination: PerformanceMetricsView(userName: userName)) {
                    Text("View Performance")
                        .font(Font.custom("Inter", size: 16).weight(.bold))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                .padding(.bottom)
                
                // Custom Tab Bar
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
            }
            .padding()
            .onDisappear {
                stopTimer()
                locationManager.stopUpdatingLocation()
            }
        }
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
        print("Saving metrics: \(elapsedTime) seconds, Speed: \(locationManager.currentSpeed), Elevation: \(locationManager.currentElevation), Date: \(endRouteDate), distance: \(locationManager.totalDistance)")
        finalTime = elapsedTime
        finalSpeed = locationManager.currentSpeed
        finalElevation = locationManager.currentElevation
        finalDistance = locationManager.totalDistance
    }
    
    private func saveRoute() {
        print("Route saved: \(routeName), \(finalTime) seconds, \(finalSpeed) m/s, \(finalElevation) m elevation")
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
                  let url = URL(string: "https://TrailBlazer33:5001/api/routes/runIDByRunName?runName=\(routeName)") else {
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
                
                let sessionData: [String: Any] = [
                    "topSpeed": 15.5,
                    "distance": 500,
                    "elevationGain": 200,
                    "duration": 120
                ]
                // Prepare the payload (the JSON object)
                let payload: [String: Any] = [
                    "sessionData": sessionData,
                    "runID": runID]
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
                        } else {
                            print("Failed to save session. Status code: \(httpResponse.statusCode)")
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
                print("Failed to get route ID")
                return
            }
            
            // Debugging: Verify that routeID is non-nil
            print("Retrieved route ID: \(routeID)")
            
            // Ensure the token is available
            guard let token = UserDefaults.standard.string(forKey: "authToken"),
                  let url = URL(string: "https://TrailBlazer33:5001/api/posts/route") else {
                print("Invalid URL or missing token")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            // Set Content-Type to application/json
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // Debugging: Print shareTitle
            print("Share Title: \(shareTitle)")
            
            // Make sure body is correctly structured
            let body: [String: Any] = [
                "routeId": routeID,
                "title": shareTitle
            ]
            
            print("Request Body: \(body)") // Debugging body content
            
            // Ensure the body is properly serialized
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
                request.httpBody = jsonData
            } catch {
                print("Failed to serialize request body: \(error.localizedDescription)")
                return
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error sharing route: \(error.localizedDescription)")
                    return
                }
                
                if let response = response as? HTTPURLResponse {
                    print("HTTP Status Code: \(response.statusCode)")
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print("Response Body: \(responseString)")
                        
                        if response.statusCode == 201 {
                            print("Route shared successfully!")
                        } else {
                            print("Failed to share route")
                        }
                    }
                }
            }
            task.resume()
        }
    }






    
    struct SelectedRouteView_Previews: PreviewProvider {
        static var previews: some View {
            SelectedRouteView(routeName: "Route 1", userName: "sampleUser")
        }
    }
    
}
