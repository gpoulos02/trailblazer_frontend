import SwiftUI
import MapboxMaps
import CoreLocation

struct RouteLandingView: View {
    var userName: String // Accept the logged-in user's name as a parameter
    
    @State private var isLoading = true // Simulate loading state
    @State private var apiKey: String? = nil // Store the API key
    @State private var errorMessage: String? = nil // Store any error message

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer().frame(height: 20)
                
                // Logo at the top
                Image("TextLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
                    .padding(.top, 20)
                
                // Current Location Section
                HStack {
                    Text("Your Current Location")
                        .font(Font.custom("Inter", size: 12).weight(.medium))
                        .foregroundColor(Color(red: 0.25, green: 0.25, blue: 0.25))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(red: 0.94, green: 0.94, blue: 0.94))
                        .cornerRadius(5)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
                
                // Map Section
                if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .frame(width: 343, height: 362)
                        .cornerRadius(5)
                        .background(Color.red.opacity(0.2))
                } else if isLoading {
                    ProgressView("Loading map...")
                        .frame(width: 343, height: 362)
                        .cornerRadius(5)
                        .onAppear {
                            fetchApiKey() // Fetch the API key when view appears
                        }
                } else if let apiKey = apiKey {
                    MapViewWrapper(apiKey: apiKey)
                        .frame(width: 343, height: 362)
                        .cornerRadius(5)
                } else {
                    Text("Failed to load map.")
                        .foregroundColor(.gray)
                        .frame(width: 343, height: 362)
                        .cornerRadius(5)
                        .background(Color.gray.opacity(0.2))
                }
                
                // Create New Route Button
                NavigationLink(destination: CreateNewRouteView(userName: userName)) {
                    HStack(spacing: 8) {
                        Text("New Route")
                            .font(Font.custom("Inter", size: 16))
                            .lineSpacing(16)
                            .foregroundColor(Color(red: 0.96, green: 0.96, blue: 0.96))
                    }
                    .padding(12)
                    .frame(width: 144, height: 42)
                    .background(Color(red: 0.25, green: 0.61, blue: 1))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .inset(by: 0.50)
                            .stroke(Color(red: 0.25, green: 0.61, blue: 1), lineWidth: 0.50)
                    )
                }
                
                Spacer()
                
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
                        .frame(maxWidth: .infinity)
                    }
                    
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
                .navigationBarBackButtonHidden(true)
            }
        }
    }
    
    private func fetchApiKey() {
        guard let url = URL(string: "https://TrailBlazer33:5001/api/map/key") else {
            errorMessage = "Invalid API URL"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    errorMessage = error.localizedDescription
                    isLoading = false
                    return
                }
                
                guard let data = data,
                      let result = try? JSONDecoder().decode([String: String].self, from: data),
                      let key = result["key"] else {
                    errorMessage = "Failed to decode API response"
                    isLoading = false
                    return
                }
                
                apiKey = key
                isLoading = false
            }
        }.resume()
    }
}

import SwiftUI
import MapboxMaps
import CoreLocation

struct MapViewWrapper: UIViewRepresentable {
    var apiKey: String
    @ObservedObject var locationManager = LocationManager()

    func makeUIView(context: Context) -> MapView {
        // Set the Mapbox access token
        MapboxOptions.accessToken = apiKey

        // Initialize the map with style
        let options = MapInitOptions(styleURI: StyleURI(rawValue: "mapbox://styles/gpoulakos/cm3nt0prt00m801r25h8wajy5"))
        let mapView = MapView(frame: .zero, mapInitOptions: options)

        // Set initial camera options (Bird's-eye view with zoom and pitch)
        let cameraOptions = CameraOptions(
            zoom: 14.0, // Initial zoom level
            bearing: 0.0,
            pitch: 45.0
        )
        mapView.mapboxMap.setCamera(to: cameraOptions)

        // Enable camera movement (rotation, zooming)
//        mapView.mapboxMap.on(MapboxMapCameraChangedEvent.self).observeNext { _ in
//            // Handle any changes in camera (rotation, zoom) dynamically
//            let cameraState = mapView.mapboxMap.cameraState
//            print("Camera moved: \(cameraState)")
//        }

        // Assign Coordinator to listen for location updates
        context.coordinator.mapView = mapView
        locationManager.delegate = context.coordinator

        // Enable the location puck with custom styling
        let locationOptions = LocationOptions(
            puckType: .puck2D(),
            puckBearing: .heading
        )
        mapView.location.options = locationOptions

        return mapView
    }

    func updateUIView(_ uiView: MapView, context: Context) {
        // Handle any updates when the location changes
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    class Coordinator: NSObject, LocationManagerDelegate {
        var mapView: MapView?

        func didUpdateLocation(_ location: CLLocation) {
            guard let mapView = mapView else { return }

            // Update the map's camera to center around the new location
            let coordinate = location.coordinate
            let cameraOptions = CameraOptions(
                center: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude),
                zoom: 14.0,
                bearing: 0.0,
                pitch: 45.0
            )

            mapView.mapboxMap.setCamera(to: cameraOptions)

            // The puck is automatically updated with the CLLocationManager updates
            print("Updated location: \(coordinate.latitude), \(coordinate.longitude)")
        }
    }
}
