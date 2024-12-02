import SwiftUI
import MapboxMaps
import CoreLocation
import Turf


struct RouteLandingView: View {
    var userName: String // Accept the logged-in user's name as a parameter
    
    @State private var isLoading = true // Simulate loading state
    @State private var apiKey: String? = nil // Store the API key
    @State private var errorMessage: String? = nil // Store any error message
    @State private var isDownloadInProgress = false
    @State private var isDownloadComplete = false
    @State private var isMapCleared = false
    
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
                
                // Download Offline Map Button
                Button(action: {
                    startDownloadOfflineMap()
                }) {
                    Text(isDownloadInProgress ? "Downloading..." : "Download Map")
                        .font(Font.custom("Inter", size: 16))
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 144, height: 42)
                        .background(isDownloadInProgress ? Color.gray : Color.blue)
                        .cornerRadius(8)
                }
                .disabled(isDownloadInProgress || isDownloadComplete)
                
                // Adding the "Map downloaded" text
                if isDownloadComplete {
                    Text("Map downloaded")
                        .font(Font.custom("Inter", size: 14))
                        .foregroundColor(.green)
                        .padding(.top, 8)
                }
                // Clear Map Data Button (visible after download completion)
//                if isDownloadComplete  {
//                    Button(action: {
//                        clearDownloadedMapData()
//                    }) {
//                        Text("Clear Map Data")
//                            .font(Font.custom("Inter", size: 12))
//                            .foregroundColor(.gray)
//                            .padding()
//                            .frame(width: 144, height: 42)
//                            .background(Color.white)
//                            .cornerRadius(8)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 8)
//                                    .inset(by: 0.50)
//                                    .stroke(Color.gray, lineWidth: 0.50)
//                            )
//                    }
//                    .padding(.top, 10)
//                }
                
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
                
            }
            .padding(.horizontal, 20)
            .navigationBarBackButtonHidden(true)
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
    
    
    private func startDownloadOfflineMap() {
        isDownloadInProgress = true
        let offlineManager = OfflineRegionManager()
        
        // Define the region to download (example with a 10 km radius around a coordinate)
        let centerCoordinate = CLLocationCoordinate2D(latitude: 44.4280, longitude: -80.3020) // Change to your target region
        let zoomLevel = 10.0
        let radius = 10000.0 // Radius in meters (optional, can be omitted for default)
        
        // Define the bounding box using the BoundingBox structure
        // Define the geometry directly using the coordinates (you can modify this depending on the SDK's expected geometry format)
        // Define the bounding box using the BoundingBox structure
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
            
            // Manually create a Geometry from the Polygon (if needed by the SDK)
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
    

    

//    private func clearDownloadedMapData() {
//        fetchOfflineRegions { regions in
//            if regions.isEmpty {
//                DispatchQueue.main.async {
//                    self.errorMessage = "No offline regions found to delete."
//                }
//                return
//            }
//
//            for region in regions {
//                region.delete { result in
//                    switch result {
//                    case .success:
//                        DispatchQueue.main.async {
//                            print("Offline region deleted successfully.")
//                        }
//                    case .failure(let error):
//                        DispatchQueue.main.async {
//                            self.errorMessage = "Error deleting offline region: \(error.localizedDescription)"
//                        }
//                    }
//                }
//            }
//
//            // Optionally, you can reset state after deleting all regions:
//            DispatchQueue.main.async {
//                self.isDownloadComplete = false
//                self.isMapCleared = true
//            }
//        }
//    }



    
}
struct MapViewWrapper: UIViewRepresentable {
    var apiKey: String
    

    func makeUIView(context: Context) -> MapView {
        // Set the Mapbox access token
        MapboxOptions.accessToken = apiKey

        // Create MapView with specified style URI
        let options = MapInitOptions(styleURI: StyleURI(rawValue: "mapbox://styles/gpoulakos/cm3nt0prt00m801r25h8wajy5"))
        let mapView = MapView(frame: .zero, mapInitOptions: options)

        let locationManager = LocationManager()

        // Set the location manager as the delegate to receive location updates
        locationManager.delegate = context.coordinator
        

        // Start location updates
        locationManager.startUpdatingLocation()// Enable user location tracking on the MapView
        mapView.location.options = LocationOptions(
            // Use the appropriate tracking mode, followWithHeading is now set differently
            
            puckType: .puck2D()
            //locationProvider: locationManager
        
        )
        

        return mapView
    }

    func updateUIView(_ uiView: MapView, context: Context) {
        // Handle updates to the map view if necessary
    }

    func makeCoordinator() -> Coordinator {
        // No need to call makeUIView directly here
        return Coordinator()
    }
    
    class Coordinator: NSObject, LocationManagerDelegate {
        var mapView: MapView?

        // This is where mapView is passed in from the context
        override init() {
            super.init()
        }
        func didUpdateLocation(_ location: CLLocation) {
            // Update MapView with the new location
            let coordinate = location.coordinate
            let cameraOptions = CameraOptions(
                center: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude),
                zoom: 14.0, // Set the zoom level
                bearing: 0.0, // Set bearing (orientation) if needed
                pitch: 45.0  // Set pitch (tilt) if needed
            )
            
            mapView?.mapboxMap.setCamera(to: cameraOptions)
            // Set the camera without animation (direct change)
            //mapView.setCamera(to: cameraOptions)

            // Optional: Print the location to the console for debugging
            print("Updated location: \(coordinate.latitude), \(coordinate.longitude)")
        }
        func setMapView(_ mapView: MapView) {
                    self.mapView = mapView
                }
    }
}
