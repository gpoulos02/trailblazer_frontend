import SwiftUI
import CoreLocation

struct WeatherView: View {
    @ObservedObject private var locationManager = LocationManager()
    @State private var weatherInfo: String = "Fetching..."
    @State private var condition: String = "Loading..."
    @State private var locationName: String = "Your Location"
    @State private var notifications: [String] = ["Snowstorm warning", "High wind alert", "Clear skies today"]
    @State private var forecast: [ForecastWeather] = []
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Location Name at the Top
                Text(locationName)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .padding(.top, 20)
                
                // Current Weather Information
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
                .padding(.top, 10)
                
                // Forecast Section
                VStack(alignment: .leading) {
                    Text("Weather Forecast")
                        .font(.headline)
                        .padding(.leading, 16)
                    
                    ScrollView {
                        ForEach(forecast) { weather in
                            HStack {
                                Text("\(weather.time): \(Int(weather.temperature))°C, \(weather.condition.capitalized)")
                                    .padding()
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 3)
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.top, 20)
                
                Spacer()
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

    // Automatically generate a unique ID for each item
    var id: UUID { UUID() }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
