import SwiftUI

// Struct to represent the Performance Metrics data (You'll later update this with actual data)
struct MetricsData: Codable {
    var totalRuns: Int
    var fastestRun: Double
    var longestRun: Double
    var averageDifficulty: Double
}

struct PerformanceMetricsView: View {
    @State private var metricsData: MetricsData? = nil
    @State private var isLoading: Bool = true
    @State private var selectedFilter: String? = nil
    var userName: String
    @State private var currentTab: Tab = .metrics
    
    
    let baseURL = "https://TrailBlazer33:5001/api" // U
    
    var body: some View {
        VStack {
            
            // Logo at the top
            Image("TextLogo")
                .resizable()
                .scaledToFit()
                .frame(height: 40)
                .padding(.top, 20)
            
            // "Today at a glance" Rectangle
            VStack {
                Text("Today at a glance:")
                    .font(Font.custom("Inter", size: 16))
                    .padding(.leading, 15)
                    .padding(.top, 15)

                // Rectangle for metrics quadrants
                VStack {
                    HStack {
                        MetricItemView(title: "Total Runs", value: metricsData?.totalRuns ?? 0)
                        MetricItemView(title: "Fastest Run", value: metricsData?.fastestRun ?? 0)
                    }
                    HStack {
                        MetricItemView(title: "Longest Run", value: metricsData?.longestRun ?? 0)
                        MetricItemView(title: "Average Difficulty", value: metricsData?.averageDifficulty ?? 0)
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal, 20)
            }
            .padding(.top, 20)

            // All Metrics Data Header
            HStack {
                Text("All Metrics Data:")
                    .font(Font.custom("Inter", size: 18).weight(.bold))
                    .padding(.leading, 20)
                Spacer()
                
                // Filter dropdown menu
                Menu {
                    Button("Trail Name") {
                        // Action for selecting Trail Name
                    }
                    Button("Date") {
                        // Action for selecting Date
                    }
                    Button("Today's Top Speeds") {
                        // Action for sorting today's top speeds
                    }
                } label: {
                    HStack {
                        Text(selectedFilter ?? "Filter by")
                            .foregroundColor(.gray)
                        Image(systemName: "arrowtriangle.down.fill")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 20)
                }
            }
            .padding(.top, 20)

            // Fetching and displaying metrics data
            if isLoading {
                ProgressView("Loading Metrics...")
                    .padding(.top, 30)
            } else if let metrics = metricsData {
                // Metrics information can be displayed here, if required
            } else {
                Text("No metrics available.")
                    .padding(.top, 30)
                    .foregroundColor(.gray)
            }

            Spacer()
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
        .onAppear {
            fetchMetricsData { data in
                DispatchQueue.main.async {
                    self.metricsData = data
                    self.isLoading = false
                }
            }
        }
    }

    // Helper method for displaying individual metrics
    private func MetricItemView(title: String, value: Any) -> some View {
        VStack {
            Text(title)
                .font(Font.custom("Inter", size: 14))
                .foregroundColor(.gray)
            Text("\(value is Double ? String(format: "%.2f", value as! Double) : String(value as! Int))")
                .font(Font.custom("Inter", size: 18).weight(.bold))
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    // Method to fetch the performance metrics data from the backend
    private func fetchMetricsData(completion: @escaping (MetricsData?) -> Void) {
        guard let url = URL(string: "\(baseURL)/metrics/overview") else {
            print("Invalid URL")
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(UserDefaults.standard.string(forKey: "authToken") ?? "")", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching metrics: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                let overview = try decoder.decode(MetricsData.self, from: data)
                completion(overview)
            } catch {
                print("Error decoding metrics: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
}

struct PerformanceMetricsView_Previews: PreviewProvider {
    static var previews: some View {
            PerformanceMetricsView(userName: "TestUser")
        }
    }
