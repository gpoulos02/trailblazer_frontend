import SwiftUI

struct PerformanceMetricsView: View {
    @State private var metricsData: MetricsData? = nil
    @State private var isLoading: Bool = true
    @State private var selectedFilter: String? = nil
    var userName: String
    @State private var currentTab: Tab = .metrics
    
    let baseURL = "https://TrailBlazer33:5001/api" // Update with the actual base URL
    
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
                        // Action for selecting today's top speeds
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
            VStack {
                HStack {
                    MetricItemView(title: "Top Speed", value: metricsData?.sessionData.topSpeed ?? 0)
                    MetricItemView(title: "Top Elevation", value: metricsData?.sessionData.elevationGain ?? 0)
                    MetricItemView(title: "Total Distance", value: metricsData?.sessionData.distance ?? 0)
                    
                    MetricItemView(title: "RunID", value: metricsData?.runID ?? 0)
                }
                HStack {
                    MetricItemView(title: "Total Distance", value: metricsData?.sessionData.distance ?? 0)
                    MetricItemView(title: "Total Duration", value: metricsData?.sessionData.duration ?? 0)
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal, 20)
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
    
    private func MetricItemView(title: String, value: Any) -> some View {
        VStack {
            Text(title)
                .font(Font.custom("Inter", size: 14))
                .foregroundColor(.gray)
            
            // Use conditional casting for each type
            if let stringValue = value as? String {
                Text(stringValue)
                    .font(Font.custom("Inter", size: 18).weight(.bold))
                    .foregroundColor(.black)
            } else if let doubleValue = value as? Double {
                Text(String(format: "%.2f", doubleValue))
                    .font(Font.custom("Inter", size: 18).weight(.bold))
                    .foregroundColor(.black)
            } else if let intValue = value as? Int {
                Text(String(intValue))
                    .font(Font.custom("Inter", size: 18).weight(.bold))
                    .foregroundColor(.black)
            } else {
                // In case value is neither String, Double, nor Int
                Text("N/A")
                    .font(Font.custom("Inter", size: 18).weight(.bold))
                    .foregroundColor(.black)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    private func fetchMetricsData(completion: @escaping (MetricsData?) -> Void) {
        // URL without the userID parameter since it's now handled by the JWT token
        guard let token = UserDefaults.standard.string(forKey: "authToken"),
              let url = URL(string: "https://TrailBlazer33:5001/api/metrics/all") else {
            print("Invalid URL or missing token")
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // Add the Authorization header with the token

        // Perform the request
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
                // Attempt to decode the response into your model (MetricsData)
                let decoder = JSONDecoder()
                let metrics = try decoder.decode([MetricsData].self, from: data)
                completion(metrics.first) // return only the first metric
            } catch {
                print("Error decoding metrics: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }


    struct SessionData: Codable {
        var topSpeed: Double
        var distance: Double
        var elevationGain: Double
        var duration: Double
    }
    
    struct MetricsData: Codable {
        var userID: String
        var runID: Int
        var sessionData: SessionData
        var createdAt: String  // You can convert this to a Date if needed
    }
}
