import SwiftUI

struct SelectedRouteView: View {
    let routeName: String // Passed from the previous view
    @State private var timerRunning: Bool = false
    @State private var startTime: Date? = nil
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer? = nil

    @ObservedObject private var locationManager = LocationManager()

    @State private var showPerformanceButton = false // Show button after route ends
    @State private var finalSpeed: Double = 0.0 // Store final speed
    @State private var finalElevation: Double = 0.0 // Store final elevation
    @State private var finalTime: TimeInterval = 0.0 // Store final time
    @State private var endRouteDate: String = ""
    @State private var currentTab: Tab = .map
    
    var userName: String

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Route Name
                Text("\(routeName)")
                    .font(Font.custom("Inter", size: 20).weight(.bold))
                    .foregroundColor(.black)

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

                // View Performance Button (Visible after route ends)
                if showPerformanceButton {
                    NavigationLink(destination: PerformanceMetricsView(userName: userName)) {
                        Text("View Performance")
                            .font(Font.custom("Inter", size: 16).weight(.bold))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(8)
                    }
                    .padding(.vertical)
                }
            }
            .padding()
            .onDisappear {
                stopTimer()
                locationManager.stopUpdatingLocation()
            }
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
            
            .padding()
            .background(Color.white)


        }
    }

    // Format elapsed time into hours, minutes, seconds
    private func formatTime(_ time: TimeInterval) -> String {
        let seconds = Int(time) % 60
        let minutes = (Int(time) / 60) % 60
        let hours = Int(time) / 3600
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    // Start/End Timer
    private func toggleTimer() {
        if timerRunning {
            // Stop the timer
            stopTimer()
            if let start = startTime {
                elapsedTime += Date().timeIntervalSince(start)
            }
            saveMetrics() // Save metrics to the backend
            showPerformanceButton = true // Show the "View Performance" button
        } else {
            // Start the timer
            startTime = Date()
            timerRunning = true
            startTimer()
        }
    }

    // Start the Timer
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if let start = startTime {
                elapsedTime = Date().timeIntervalSince(start)
            }
        }
    }

    // Stop the Timer
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        timerRunning = false
    }

    // Save Metrics to Backend (Placeholder)
    private func saveMetrics() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        endRouteDate = formatter.string(from: Date())
        // Simulate saving metrics to backend
        print("Saving metrics: \(elapsedTime) seconds, Speed: \(locationManager.currentSpeed), Elevation: \(locationManager.currentElevation), Date: \(endRouteDate)")
        finalTime = elapsedTime
        finalSpeed = locationManager.currentSpeed
        finalElevation = locationManager.currentElevation
    }
}

struct SelectedRouteView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedRouteView(routeName: "Route 1", userName: "sampleUser")
    }
}
