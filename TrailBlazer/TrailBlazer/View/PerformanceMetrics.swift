import SwiftUI

// Struct to represent a performance metric
struct PerformanceMetric: Identifiable, Hashable, Codable {
    var id = UUID()  // Unique identifier for each metric
    var routeName: String
    var elapsedTime: TimeInterval
    var speed: Double
    var elevation: Double
    var date: Date
}

struct PerformanceMetricsView: View {
    @State private var performanceMetrics: [PerformanceMetric] = []
    
    var userName: String

    var body: some View {
        VStack {
            Text("Performance Metrics")
                .font(Font.custom("Inter", size: 25).weight(.bold))
                .foregroundColor(.black)
                .padding()

            if performanceMetrics.isEmpty {
                Text("No past runs available.")
                    .font(Font.custom("Inter", size: 16))
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(performanceMetrics) { metric in
                    VStack(alignment: .leading) {
                        Text("Route: \(metric.routeName)")
                            .font(Font.custom("Inter", size: 16).weight(.bold))
                        Text("Elapsed Time: \(formatTime(metric.elapsedTime))")
                            .font(Font.custom("Inter", size: 14))
                        Text("Speed: \(String(format: "%.1f", metric.speed)) m/s")
                            .font(Font.custom("Inter", size: 14))
                        Text("Elevation: \(String(format: "%.1f", metric.elevation)) m")
                            .font(Font.custom("Inter", size: 14))
                        Text("Date: \(formatDate(metric.date))")
                            .font(Font.custom("Inter", size: 14))
                            .foregroundColor(.gray)
                    }
                    .padding()
                }
            }
        }
        .padding()
        HStack {
            // Home Button
            NavigationLink(destination: HomeView(userName: userName)) { // Pass userName to HomeView
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
            NavigationLink(destination: FriendView(userName: userName)) { // Pass userName to FriendView
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
            NavigationLink(destination: RouteLandingView(userName: userName)) { // Pass userName to SetNewRouteView
                VStack {
                    Image(systemName: "map.fill")
                        .foregroundColor(.black)
                    Text("Map")
                        .foregroundColor(.black)
                        .font(.caption)
                }
            }
            .frame(maxWidth: .infinity)

            // Performance Metrics Button
            NavigationLink(destination: PerformanceMetricsView(userName: userName)) {
                VStack {
                    Image(systemName: "chart.bar.fill") // Represents Metrics
                        .foregroundColor(.black)
                    Text("Metrics")
                        .foregroundColor(.black)
                        .font(.caption)
                }
            }
            .frame(maxWidth: .infinity)
            
            // Profile Button
            NavigationLink(destination: ProfileView(userName: userName)) { // Pass userName to ProfileView
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
        .onAppear {
            performanceMetrics = loadMetrics() // Load metrics when the view appears
        }
    }

    // Format elapsed time into hours, minutes, seconds
    private func formatTime(_ time: TimeInterval) -> String {
        let seconds = Int(time) % 60
        let minutes = (Int(time) / 60) % 60
        let hours = Int(time) / 3600
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    // Format date into readable format
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    // Save metrics directly to UserDefaults
    func saveMetrics(routeName: String, elapsedTime: TimeInterval, speed: Double, elevation: Double) {
        let metric = PerformanceMetric(
            routeName: routeName,
            elapsedTime: elapsedTime,
            speed: speed,
            elevation: elevation,
            date: Date()
        )

        var savedMetrics = loadMetrics() // Load existing metrics
        savedMetrics.append(metric) // Add the new metric

        // Save the updated list of metrics
        if let encodedMetrics = try? JSONEncoder().encode(savedMetrics) {
            UserDefaults.standard.set(encodedMetrics, forKey: "performanceMetrics")
            print("Saved metrics: \(metric)")
        }
    }

    // Load metrics from UserDefaults
    private func loadMetrics() -> [PerformanceMetric] {
        guard let data = UserDefaults.standard.data(forKey: "performanceMetrics"),
              let savedMetrics = try? JSONDecoder().decode([PerformanceMetric].self, from: data) else {
            return [] // Return an empty array if no data is available
        }
        return savedMetrics
    }
}

struct PerformanceMetricsView_Previews: PreviewProvider {
    static var previews: some View {
        PerformanceMetricsView(userName: "sampleUser")
    }
}
