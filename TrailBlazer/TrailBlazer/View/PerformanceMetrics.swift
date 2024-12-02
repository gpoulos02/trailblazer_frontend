import SwiftUI

struct PerformanceMetricsView: View {
    @State private var metricsOverview: MetricsOverview? = nil
    @State private var isLoading: Bool = true
    
    // Struct to represent aggregated performance metrics
    struct MetricsOverview: Codable {
        var averageSpeed: Double
        var topSpeed: Double
        var averageDistance: Double
        var longestDistance: Double
        var totalDistance: Double
        var averageElevation: Double
        var mostElevation: Double
        var totalElevation: Double
    }


    var userName: String
    let baseURL = "https://TrailBlazer33:5001/api" // Update this to your actual backend URL

    var body: some View {
        VStack {
            // Logo at the top
            Image("TextLogo")
                .resizable()
                .scaledToFit()
                .frame(height: 40)
                .padding(.top, 20)
            // Title at the Top
            Text("Performance Metrics")
                .font(Font.custom("Inter", size: 25).weight(.bold))
                .foregroundColor(.black)
                .padding(.top, 20)
                .frame(maxWidth: .infinity, alignment: .center)

            Spacer().frame(height: 10) // Small spacing

            if isLoading {
                ProgressView("Loading Metrics...")
            } else if let metrics = metricsOverview {
                // Metrics Information with Share Button
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Average Speed: \(String(format: "%.2f", metrics.averageSpeed)) m/s")
                        Text("Top Speed: \(String(format: "%.2f", metrics.topSpeed)) m/s")
                        Text("Average Distance: \(String(format: "%.2f", metrics.averageDistance)) m")
                        Text("Longest Distance: \(String(format: "%.2f", metrics.longestDistance)) m")
                        Text("Total Distance: \(String(format: "%.2f", metrics.totalDistance)) m")
                        Text("Average Elevation: \(String(format: "%.2f", metrics.averageElevation)) m")
                        Text("Most Elevation: \(String(format: "%.2f", metrics.mostElevation)) m")
                        Text("Total Elevation: \(String(format: "%.2f", metrics.totalElevation)) m")
                    }
                    .font(Font.custom("Inter", size: 16))
                    .padding()

                    Spacer()

                    // Share Button
                    Button(action: {
                        print("Share button tapped")
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title)
                            .foregroundColor(.blue)
                            .padding()
                    }
                }
                .padding(.horizontal, 20)
            } else {
                Text("No metrics available.")
                    .font(Font.custom("Inter", size: 16))
                    .foregroundColor(.gray)
                    .padding()
            }

            Spacer() // Push content upwards
            .navigationBarBackButtonHidden(true)

            // Navigation Bar at the Bottom
            HStack {
                NavigationLink(destination: HomeView(userName: userName)) {
                    VStack {
                        Image(systemName: "house.fill")
                            .foregroundColor(.black)
                        Text("Home")
                            .foregroundColor(.black)
                            .font(.caption)
                    }
                }
                .frame(maxWidth: .infinity)

                NavigationLink(destination: FriendView(userName: userName)) {
                    VStack {
                        Image(systemName: "person.2.fill")
                            .foregroundColor(.black)
                        Text("Friends")
                            .foregroundColor(.black)
                            .font(.caption)
                    }
                }
                .frame(maxWidth: .infinity)

                NavigationLink(destination: RouteLandingView(userName: userName)) {
                    VStack {
                        Image(systemName: "map.fill")
                            .foregroundColor(.black)
                        Text("Map")
                            .foregroundColor(.black)
                            .font(.caption)
                    }
                }
                .frame(maxWidth: .infinity)

                NavigationLink(destination: PerformanceMetricsView(userName: userName)) {
                    VStack {
                        Image(systemName: "chart.bar.fill")
                            .foregroundColor(.black)
                        Text("Metrics")
                            .foregroundColor(.black)
                            .font(.caption)
                    }
                }
                .frame(maxWidth: .infinity)

                NavigationLink(destination: ProfileView(userName: userName)) {
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
        }
        .padding(.horizontal, 20)
        .onAppear {
            fetchMetricsOverview { overview in
                DispatchQueue.main.async {
                    self.metricsOverview = overview
                    self.isLoading = false
                }
            }
        }
    }

    // Fetch metrics overview from the backend
    private func fetchMetricsOverview(completion: @escaping (MetricsOverview?) -> Void) {
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
                let overview = try decoder.decode(MetricsOverview.self, from: data)
                completion(overview)
            } catch {
                print("Error decoding metrics: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
}
