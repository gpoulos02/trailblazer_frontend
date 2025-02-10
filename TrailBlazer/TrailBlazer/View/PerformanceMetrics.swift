import SwiftUI

struct PerformanceMetricsView: View {
    @State private var metricsData: [MetricsData] = []
    @State private var originalMetricsData: [MetricsData] = []
    @State private var isLoading: Bool = true
    @State private var selectedFilter: String? = nil
    @State private var selectedTrailName: String? = nil
    var userName: String
    @State private var currentTab: Tab = .metrics
    @State private var runNames: [Int: String] = [:] // Use Int as the key type for runID
    @State private var allTrailNames: [String] = []
    @State private var isTrailNameListVisible: Bool = true
    @State private var sortLabel: String = ""
    
    let baseURL = "https://TrailBlazer33:5001/api"
    
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
                
                GridView(metricsData: metricsData)
            }
            .padding(.top, 20)
            
            Spacer()
            
            // Metrics Data Header
            HStack {
                Text("All Metrics Data:")
                    .font(Font.custom("Inter", size: 18).weight(.bold))
                    .padding(.leading, 20)
                Spacer()
                
                Menu {
                    Button("Date") {
                        selectedFilter = "Date"
                        resetFilter()
                        sortMetricsData()
                        sortLabel = "Sorted by Date"
                    }
                    Button("Trail Name") {
                        selectedFilter = "Trail Name"
                        fetchAllTrailNames()
                        isTrailNameListVisible = true
                        sortLabel = "Sorted by Trail Name"
                    }
                    Button("Speed") {
                        selectedFilter = "Speed"
                        resetFilter()
                        sortMetricsData()
                        sortLabel = "Sorted by Speed"
                    }
                    Button("Distance") {
                        selectedFilter = "Distance"
                        resetFilter()
                        sortMetricsData()
                        sortLabel = "Sorted by Distance"
                    }
                    Button("Elevation") {
                        selectedFilter = "Elevation"
                        resetFilter()
                        sortMetricsData()
                        sortLabel = "Sorted by Elevation"
                    }
                    Button("Duration") {
                        selectedFilter = "Duration"
                        resetFilter()
                        sortMetricsData()
                        sortLabel = "Sorted by Duration"
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
            if !sortLabel.isEmpty {
                Text(sortLabel)
                    .font(Font.custom("Inter", size: 16).weight(.bold))
                    .padding(.top, 10)
                    .padding(.leading, 20)
                    .foregroundColor(.gray)
            }
            
            // Dropdown for Trail Name
            if selectedFilter == "Trail Name" {
                VStack {
                    
                    
                    if isTrailNameListVisible {
                        Text("Select Trail Name")
                            .font(Font.custom("Inter", size: 16).weight(.bold))
                            .padding(.leading, 20)
                        List(allTrailNames, id: \.self) { trailName in
                            Button(action: {
                                selectedTrailName = trailName // Set the selected trail name
                                filterByTrailName()
                                metricsData = sortMetricsData()
                                isTrailNameListVisible = false// Filter metrics by selected trail name
                            }) {
                                Text(trailName)
                            }
                        }
                        .frame(height: 200)
                    }
                }
            }
            
            // Metrics Data Display
            if isLoading {
                ProgressView("Loading Metrics...")
                    .padding(.top, 30)
            } else if metricsData.isEmpty {
                Text("No metrics available.")
                    .padding(.top, 30)
                    .foregroundColor(.gray)
            } else {
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(sortMetricsData(), id: \.sessionID) { metric in
                            VStack(alignment: .leading, spacing: 10) {
                                if let runName = runNames[metric.runID] {
                                    Text("Run Name: \(runName)")
                                        .font(.headline)
                                        .padding(.bottom, 5)
                                } else {
                                    Text("Run Name: Loading...")
                                        .font(.headline)
                                }
                                
                                Text("Run Date: \(metric.createdAt)")
                                    .font(.headline)
                                
                                MetricRowView(title: "Top Speed", value: metric.sessionData.topSpeed)
                                MetricRowView(title: "Elevation Gain", value: metric.sessionData.elevationGain)
                                MetricRowView(title: "Distance", value: metric.sessionData.distance)
                                MetricRowView(title: "Duration", value: metric.sessionData.duration)
                            }
                            .padding(15)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                        }
                    }
                }
            }
            
            Spacer()
            
            // Navigation Bar at the Bottom
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
        .onAppear {
            fetchMetricsData { data in
                DispatchQueue.main.async {
                    self.metricsData = data
                    self.originalMetricsData = data
                    self.isLoading = false
                    self.loadRunNames(for: data)
                }
            }
        }
    }
    
    private func fetchMetricsData(completion: @escaping ([MetricsData]) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "authToken"),
              let url = URL(string: "\(baseURL)/metrics/all") else {
            print("Invalid URL or missing token")
            completion([])
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error fetching metrics: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion([])
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let metrics = try decoder.decode([MetricsData].self, from: data)
                completion(metrics)
            } catch {
                print("Error decoding metrics: \(error.localizedDescription)")
                completion([])
            }
        }.resume()
    }
    private func resetFilter() {
        // Reset the metrics data to the original state before applying any filter
        metricsData = originalMetricsData
    }
    
    private func totalRunsForToday() -> Int {
        let today = formattedDate(date: Date())
        return metricsData.filter { $0.createdAt.starts(with: today) }.count
    }

    private func topSpeedForToday() -> Double {
        let today = formattedDate(date: Date())
        return metricsData.filter { $0.createdAt.starts(with: today) }
            .map { $0.sessionData.topSpeed }
            .max() ?? 0.0
    }

    private func longestRunForToday() -> Double {
        let today = formattedDate(date: Date())
        return metricsData.filter { $0.createdAt.starts(with: today) }
            .map { $0.sessionData.distance }
            .max() ?? 0.0
    }

    private func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM dd, yyyy"
        return formatter.string(from: date)
    }
    
    private func loadRunNames(for metrics: [MetricsData]) {
        for metric in metrics {
            fetchRunName(runID: metric.runID) { runName in
                DispatchQueue.main.async {
                    self.runNames[metric.runID] = runName
                }
            }
        }
    }
    
    private func fetchRunName(runID: Int, completion: @escaping (String) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "authToken"),
              let url = URL(string: "https://TrailBlazer33:5001/api/routes/runNamebyID?runID=\(runID)") else {
            print("Invalid URL or missing token")
            completion("Unknown Run")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error fetching run name: \(error.localizedDescription)")
                    completion("Unknown Run")
                    return
                }

                guard let data = data else {
                    print("No data received for runID: \(runID)")
                    completion("Unknown Run")
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode([String: String].self, from: data)
                    if let runName = response["runName"] {
                        completion(runName)
                    } else {
                        completion("Unknown Run")
                    }
                } catch {
                    completion("Unknown Run")
                }
            }
        }.resume()
    }
    
    private func fetchAllTrailNames() {
        guard let token = UserDefaults.standard.string(forKey: "authToken"),
              let url = URL(string: "https://TrailBlazer33:5001/api/routes/route-names") else {
            print("Invalid URL or missing token")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        print("Fetching trail names with URL: \(url)") // Debugging: Log the request URL

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching trail names: \(error.localizedDescription)") // Debugging: Log the error
                return
            }
            
            guard let data = data else {
                print("No data received from the server.") // Debugging: Log if no data received
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let trailResponse = try decoder.decode(TrailResponse.self, from: data)
                print("Decoded response: \(trailResponse)") // Debugging: Log the decoded response
                
                DispatchQueue.main.async {
                    self.allTrailNames = trailResponse.routes // Extract the routes array
                    print("Trail names: \(self.allTrailNames)") // Debugging: Log the trail names
                }
            } catch {
                print("Error decoding trail names: \(error.localizedDescription)") // Debugging: Log the error
            }
        }.resume()
    }


    
    private func filterByTrailName() {
        guard let selectedTrailName = selectedTrailName else { return }
        
        // Only filter when runNames has been populated for each runID
        metricsData = originalMetricsData.filter { runNames[$0.runID] == selectedTrailName }
    }


    // Sorting based on selected filter
    private func sortMetricsData() -> [MetricsData] {
        switch selectedFilter {
        case "Date":
            return metricsData.sorted { $0.createdAt > $1.createdAt }
        case "Trail Name":
            return metricsData.sorted { runNames[$0.runID] ?? "" < runNames[$1.runID] ?? "" }
        case "Speed":
            return metricsData.sorted { $0.sessionData.topSpeed > $1.sessionData.topSpeed }
        case "Distance":
            return metricsData.sorted { $0.sessionData.distance > $1.sessionData.distance }
        case "Elevation":
            return metricsData.sorted { $0.sessionData.elevationGain > $1.sessionData.elevationGain }
        case "Duration":
            return metricsData.sorted { $0.sessionData.duration > $1.sessionData.duration }
        default:
            return metricsData.sorted { $0.createdAt > $1.createdAt }
        }
    }

    private struct MetricRowView: View {
        var title: String
        var value: Any
        
        var body: some View {
            HStack {
                Text(title)
                    .font(Font.custom("Inter", size: 16).weight(.medium))
                    .foregroundColor(.gray)
                Spacer()
                if let doubleValue = value as? Double {
                    Text(String(format: "%.2f", doubleValue))
                        .font(Font.custom("Inter", size: 18).weight(.bold))
                } else {
                    Text("N/A")
                        .font(Font.custom("Inter", size: 18).weight(.bold))
                }
            }
            .padding(.vertical, 5)
        }
    }
    
    struct GridView: View {
        var metricsData: [MetricsData]

        var body: some View {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 2), spacing: 15) {
                GridItemView(title: "Total Runs", value: "\(totalRunsForToday())")
                GridItemView(title: "Top Speed", value: "\(String(format: "%.2f", topSpeedForToday())) km/h")
                GridItemView(title: "Longest Run", value: "\(String(format: "%.2f", longestRunForToday())) km")
                GridItemView(title: "Average Difficulty", value: "Coming Soon")
            }
            .padding(.horizontal, 20)
        }

        private func totalRunsForToday() -> Int {
            let today = formattedDate(date: Date())
            return metricsData.filter { $0.createdAt.starts(with: today) }.count
        }

        private func topSpeedForToday() -> Double {
            let today = formattedDate(date: Date())
            return metricsData.filter { $0.createdAt.starts(with: today) }
                .map { $0.sessionData.topSpeed }
                .max() ?? 0.0
        }

        private func longestRunForToday() -> Double {
            let today = formattedDate(date: Date())
            return metricsData.filter { $0.createdAt.starts(with: today) }
                .map { $0.sessionData.distance }
                .max() ?? 0.0
        }

        private func formattedDate(date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: date)
        }
    }
    struct GridItemView: View {
        var title: String
        var value: String

        var body: some View {
            VStack {
                Text(title)
                    .font(.headline)
                    .padding(.bottom, 5)
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            .frame(maxWidth: .infinity, minHeight: 100)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.all, 5)
        }
    }
    
    
    struct SessionData: Codable {
        var topSpeed: Double
        var distance: Double
        var elevationGain: Double
        var duration: Double
    }
    
    struct MetricsData: Codable {
        var sessionID: String
        var userID: String
        var runID: Int
        var sessionData: SessionData
        var createdAt: String
    }
    struct TrailResponse: Codable {
        let message: String
        let routes: [String]
    }
    
}
