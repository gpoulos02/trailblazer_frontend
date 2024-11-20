import SwiftUI

struct WeatherView: View {
    @State private var weatherInfo: String = "Fetching..."
    @State private var condition: String = "Loading..."
    @State private var notifications: [String] = ["Snowstorm warning", "High wind alert", "Clear skies today"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Weather Info Section
                VStack {
                    Image(systemName: conditionIcon(for: condition))
                        .font(.system(size: 70))
                        .foregroundColor(.blue)
                    
                    Text(weatherInfo)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding(.top, 10)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.top, 40)
                
                // Notifications Section
                VStack(alignment: .leading) {
                    Text("Recent Notifications")
                        .font(.headline)
                        .padding(.leading, 16)
                    
                    ForEach(notifications, id: \.self) { notification in
                        HStack {
                            Text(notification)
                                .padding()
                                .foregroundColor(.black)
                            Spacer()
                            Button(action: {
                                // Remove notification
                                if let index = notifications.firstIndex(of: notification) {
                                    notifications.remove(at: index)
                                }
                            }) {
                                Image(systemName: "trash.fill")
                                    .foregroundColor(.red)
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 3)
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 20)
                
                Spacer()
                
                // Navigation Bar at the Bottom
                HStack {
                    NavigationLink(destination: HomeView()) {
                        VStack {
                            Image(systemName: "house.fill")
                                .foregroundColor(.black)
                            Text("Home")
                                .foregroundColor(.black)
                                .font(.caption)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    NavigationLink(destination: FriendView()) {
                        VStack {
                            Image(systemName: "person.2.fill")
                                .foregroundColor(.black)
                            Text("Friends")
                                .foregroundColor(.black)
                                .font(.caption)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    NavigationLink(destination: RouteLandingView()) {
                        VStack {
                            Image(systemName: "map.fill")
                                .foregroundColor(.black)
                            Text("Map")
                                .foregroundColor(.black)
                                .font(.caption)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    NavigationLink(destination: PerformanceMetricsView()) {
                        VStack {
                            Image(systemName: "chart.bar.fill")
                                .foregroundColor(.black)
                            Text("Metrics")
                                .foregroundColor(.black)
                                .font(.caption)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    NavigationLink(destination: ProfileView()) {
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
            //.edgesIgnoringSafeArea(.bottom)
            .padding()
            .onAppear {
                fetchWeather()
            }
        }
    }
    
    // Helper function to determine the weather icon
    func conditionIcon(for condition: String) -> String {
        switch condition.lowercased() {
        case "clear": return "sun.max.fill"
        case "clouds": return "cloud.fill"
        case "rain": return "cloud.rain.fill"
        case "snow": return "cloud.snow.fill"
        default: return "cloud.fill"
        }
    }
    
    // Fetch weather data from the backend
    func fetchWeather() {
        guard let url = URL(string: "http://localhost:3000/weather?latitude=44.5&longitude=-80.2") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            if let weatherData = try? JSONDecoder().decode(WeatherData.self, from: data) {
                DispatchQueue.main.async {
                    self.weatherInfo = "\(weatherData.temperature)°C, \(weatherData.description.capitalized)"
                    self.condition = weatherData.condition
                }
            }
        }.resume()
    }
}

struct WeatherData: Codable {
    let temperature: Double
    let condition: String
    let description: String
}


struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
