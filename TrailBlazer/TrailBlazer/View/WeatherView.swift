import SwiftUI
import CoreLocation

struct WeatherView: View {
    @ObservedObject private var locationManager = LocationManager()
    @State private var weatherInfo: String = "Fetching..."
    @State private var condition: String = "Loading..."
    @State private var locationName: String = "Your Location"
    @State private var notifications: [String] = ["Snowstorm warning", "High wind alert", "Clear skies today"]
    @State private var forecast: [ForecastWeather] = []
    @State private var currentTab: Tab = .home
    @State private var searchText: String = ""

    var userName: String

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Location Name at the Top
                Text(locationName)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.top, 20)

                // Search Bar for Future Use
                TextField("Search Location...", text: $searchText)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)

                // Current Weather Information
                VStack {
                    Image(systemName: conditionIcon(for: condition))
                        .font(.system(size: 70))
                        .foregroundColor(.blue)

                    Text(weatherInfo)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.top, 10)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.top, 10)

                // Forecast Section with Modern Styling
                VStack(alignment: .leading, spacing: 10) {
                    Text("Weather Forecast")
                        .font(.headline)
                        .padding(.leading, 16)

                    ScrollView {
                        ForEach(forecast) { weather in
                            HStack(alignment: .center) {
                                // Weather Icon
                                Image(systemName: conditionIcon(for: weather.condition))
                                    .font(.system(size: 30))
                                    .foregroundColor(.blue)
                                    .padding(.leading, 16)

                                // Weather Details
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(formatDateTime(weather.time))
                                        .font(.headline)
                                        .bold()
                                        .foregroundColor(.primary)

                                    Text("\(Int(weather.temperature))°C, \(weather.condition.capitalized)")
                                        .font(.title2) // Larger temperature font
                                        .foregroundColor(.secondary)
                                }
                                .padding(.leading, 10)

                                Spacer()
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: .gray.opacity(0.3), radius: 5, x: 2, y: 2)
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.top, 20)

                Spacer()
                // Navigation Bar at the Bottom
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
                .background(Color.white)
                .shadow(radius: 5)
            }
            .onAppear {
                fetchWeather()
                fetchLocationName()
            }
        }
    }

    func conditionIcon(for condition: String) -> String {
        switch condition.lowercased() {
        case "clear": return "sun.max.fill"
        case "clouds": return "cloud.fill"
        case "rain": return "cloud.rain.fill"
        case "snow": return "cloud.snow.fill"
        default: return "cloud.fill"
        }
    }

    func fetchWeather() {
        guard let location = locationManager.currentLocation else {
            weatherInfo = "Unable to get location"
            print("Debug: Location is nil")
            return
        }

        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude

        guard let url = URL(string: "https://TrailBlazer33:5001/api/weather?latitude=\(latitude)&longitude=\(longitude)") else {
            print("Debug: URL creation failed")
            return
        }

        print("Debug: Fetching weather data from \(url)")

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Debug: Error occurred - \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Debug: No HTTP response")
                return
            }
            print("Debug: HTTP Response Code - \(httpResponse.statusCode)")

            guard let data = data else {
                print("Debug: Data is nil")
                return
            }

            do {
                let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                DispatchQueue.main.async {
                    let current = weatherData.current
                    self.weatherInfo = "\(Int(current.temperature))°C, \(current.description.capitalized)"
                    self.condition = current.condition
                    self.forecast = weatherData.forecast
                }
            } catch {
                print("Debug: JSON Decoding failed - \(error)")
            }
        }.resume()
    }

    func fetchLocationName() {
        guard let location = locationManager.currentLocation else {
            locationName = "Unknown Location"
            return
        }

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Debug: Reverse geocoding failed - \(error.localizedDescription)")
                return
            }

            if let placemark = placemarks?.first {
                DispatchQueue.main.async {
                    self.locationName = placemark.locality ?? "Unknown Location"
                }
            }
        }
    }

    func formatDateTime(_ dateTime: String) -> String {
        let dateFormatter = ISO8601DateFormatter()
        guard let date = dateFormatter.date(from: dateTime) else { return dateTime }

        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "MMM d, yyyy, h:mm a"
        return displayFormatter.string(from: date)
    }
}

struct WeatherData: Codable {
    let current: CurrentWeather
    let forecast: [ForecastWeather]

    struct CurrentWeather: Codable {
        let temperature: Double
        let condition: String
        let description: String
    }
}

struct ForecastWeather: Codable, Identifiable {
    let time: String
    let temperature: Double
    let condition: String

    var id: UUID { UUID() }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(userName: "john doe")
    }
}
