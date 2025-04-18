import SwiftUI
import MapboxMaps
import CoreLocation
import Turf

struct RouteLandingView: View {
    var userName: String // Accept the logged-in user's name as a parameter

    @State private var isLoading = true
    @State private var apiKey: String? = nil // Store the API key
    @State private var errorMessage: String? = nil // Store any error message
    @State private var isDownloadInProgress = false
    @State private var isDownloadComplete = false
    @State private var currentTab: Tab = .map
    @State private var fixedCoordinates: CLLocationCoordinate2D? = nil
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        ZStack(alignment: .bottom) {
// Keeps nav bar fixed at the bottom
            VStack {
                if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.red.opacity(0.2))
                } else if isLoading {
                    ProgressView("Loading map...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onAppear {
                            fetchApiKey()
                        }
                } else if let apiKey = apiKey {
                    MapViewWrapper(apiKey: apiKey)
                        .edgesIgnoringSafeArea(.all)
                } else {
                    Text("Failed to load map.")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.gray.opacity(0.2))
                }
            }

            VStack {
                Spacer()


                Spacer()

                // Buttons Section
                HStack(spacing: 16) {
                    NavigationLink(destination: CreateNewRouteView(userName: userName)) {
                        Text("New Route")
                            .font(Font.custom("Inter", size: 16))
                            .foregroundColor(.white)
                            .frame(width: 144, height: 42)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }

                    Button(action: {
                        startDownloadOfflineMap()
                    }) {
                        Text(isDownloadInProgress ? "Downloading..." : "Download Map")
                            .font(Font.custom("Inter", size: 16))
                            .foregroundColor(.white)
                            .frame(width: 144, height: 42)
                            .background(isDownloadInProgress ? Color.gray : Color.blue)
                            .cornerRadius(8)
                    }
                    .disabled(isDownloadInProgress || isDownloadComplete)
                }
                .padding(.vertical, 16)

                if isDownloadComplete {
                    Text("Map downloaded")
                        .font(Font.custom("Inter", size: 14))
                        .foregroundColor(.green)
                        .padding(.bottom, 8)
                }
            }
            .padding(.bottom, 100) // Prevents buttons from overlapping the nav bar

            // Fixed Bottom Navigation Bar with Shadow
            VStack {
                Divider()
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
                .shadow(radius: 5) // Adds shadow effect
            }
            .frame(maxWidth: .infinity)
        }
        .navigationBarBackButtonHidden(true)
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
                        print("Debug: Error fetching API key - \(error.localizedDescription)")
                        return
                    }

                    guard let data = data,
                          let result = try? JSONDecoder().decode([String: String].self, from: data),
                          let key = result["key"] else {
                        errorMessage = "Failed to decode API response"
                        isLoading = false
                        print("Debug: Failed to decode API response or no key found")
                        return
                    }

                    apiKey = key
                    isLoading = false
                    print("Debug: Successfully fetched API key")
                }
            }.resume()
        }
    
    
    private func startDownloadOfflineMap() {
        isDownloadInProgress = true
        let offlineManager = OfflineRegionManager()
        
        // Define the region to download
        let centerCoordinate = CLLocationCoordinate2D(latitude: 44.4280, longitude: -80.3020) // Change to your target region
        let zoomLevel = 10.0
        let radius = 10000.0 // Radius in meters
        
        // Define the bounding box using the BoundingBox structure
        // Define the geometry directly using the coordinates
        let southWest = CLLocationCoordinate2D(latitude: centerCoordinate.latitude - 0.05, longitude: centerCoordinate.longitude - 0.05)
        let northEast = CLLocationCoordinate2D(latitude: centerCoordinate.latitude + 0.05, longitude: centerCoordinate.longitude + 0.05)

        // Create the four corners of the polygon
        let polygonCoordinates: [[CLLocationCoordinate2D]] = [
            [southWest, CLLocationCoordinate2D(latitude: southWest.latitude, longitude: northEast.longitude)], // Bottom-left to top-left
            [CLLocationCoordinate2D(latitude: southWest.latitude, longitude: northEast.longitude), northEast], // Top-left to top-right
            [northEast, CLLocationCoordinate2D(latitude: northEast.latitude, longitude: southWest.longitude)], // Top-right to bottom-right
            [CLLocationCoordinate2D(latitude: northEast.latitude, longitude: southWest.longitude), southWest] // Bottom-right to bottom-left (closing the polygon)
        ]
        
        do {
            // Create the polygon as before
            let closedPolygonCoordinates = polygonCoordinates.flatMap { $0 }
            let polygon = try Polygon([closedPolygonCoordinates])
            
            // Manually create a Geometry from the Polygon
            let geometry = Geometry(polygon)  // Assuming you have this conversion available
            
            let styleURL = "mapbox://styles/gpoulakos/cm3nt0prt00m801r25h8wajy5"
            
            // Create the OfflineRegionGeometryDefinition
            let offlineRegionGeometry = OfflineRegionGeometryDefinition(
                styleURL: styleURL,
                geometry: geometry,  // This is now a valid Geometry type
                minZoom: zoomLevel,
                maxZoom: zoomLevel,
                pixelRatio: 1.0,
                glyphsRasterizationMode: .ideographsRasterizedLocally
            )
            
            offlineManager.createOfflineRegion(for: offlineRegionGeometry) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        isDownloadComplete = true
                        isDownloadInProgress = false
                        print("Offline map download completed successfully.")
                    case .failure(let error):
                        errorMessage = error.localizedDescription
                        isDownloadInProgress = false
                        print("Error downloading offline map: \(error.localizedDescription)")

                        // Log the error type to better understand it
                        print("Error type: \(type(of: error))")
                        
                     
                            print("Unexpected error: \(error.localizedDescription)")
                        if let mapboxError = error as? MapboxMaps.MapError {
                                        print("Mapbox Error Code: \(mapboxError.localizedDescription)")
                                    } else {
                                        // If the error is not a Mapbox error, print it
                                        print("Unexpected error: \(error.localizedDescription)")
                                    }
                    }
                }
            }

        } catch {
            print("Error creating polygon: \(error.localizedDescription)")
            isDownloadInProgress = false
        }
    }
    private func fetchOfflineRegions(completion: @escaping ([OfflineRegion]) -> Void) {
        let offlineManager = OfflineRegionManager()
        
        offlineManager.offlineRegions { result in
            switch result {
            case .success(let regions):
                completion(regions)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to fetch offline regions: \(error.localizedDescription)"
                }
            }
        }
    }

}

struct MapViewWrapper: UIViewRepresentable {
    var apiKey: String
    
    @ObservedObject var locationManager = LocationManager()

    func makeUIView(context: Context) -> MapView {
        // Set the Mapbox access token
        MapboxOptions.accessToken = apiKey

        // Create MapView with specified style URI
        let options = MapInitOptions(styleURI: StyleURI(rawValue: "mapbox://styles/gpoulakos/cm3nt0prt00m801r25h8wajy5"))
        let mapView = MapView(frame: .zero, mapInitOptions: options)

        // Initial camera options
        let cameraOptions = CameraOptions(zoom: 14.0, bearing: 0.0, pitch: 45.0)
        mapView.mapboxMap.setCamera(to: cameraOptions)

        // Assign Coordinator to handle location updates
        context.coordinator.mapView = mapView
        locationManager.delegate = context.coordinator

        // Enable location puck
        let locationOptions = LocationOptions(
            puckType: .puck2D(),
            puckBearing: .heading
        )
        mapView.location.options = locationOptions

        // Start location updates
        locationManager.startUpdatingLocation()

        return mapView
    }

    func updateUIView(_ uiView: MapView, context: Context) {
        // Handle updates to the map view if necessary
    }

    func makeCoordinator() -> Coordinator {
          return Coordinator()
      }


    class Coordinator: NSObject, LocationManagerDelegate {
        var mapView: MapView?


        func didUpdateLocation(_ location: CLLocation) {
            guard let mapView = mapView else { return }

            let coordinate = location.coordinate
            print("Debug: Updated location - Lat: \(coordinate.latitude), Lon: \(coordinate.longitude)")
            
            // Center the map on the new location
            let cameraOptions = CameraOptions(
                           center: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude),
                           zoom: 14.0,
                           bearing: 0.0,
                           pitch: 45.0
                       )
            mapView.mapboxMap.setCamera(to: cameraOptions)
            
        }

    }
}
