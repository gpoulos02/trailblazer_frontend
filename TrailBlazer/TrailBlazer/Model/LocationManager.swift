import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocation(_ location: CLLocation)
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    weak var delegate: LocationManagerDelegate?

    @Published var currentLocation: CLLocation?
    @Published var currentSpeed: Double = 0.0
    @Published var currentElevation: Double = 0.0
    @Published var totalDistance: Double = 0.0
    @Published var currentCoordinates: String = ""

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
        
        if let currentLocation = currentLocation {
            let distance = location.distance(from: currentLocation)
            totalDistance += distance
        }
        currentLocation = location
        currentSpeed = location.speed >= 0 ? location.speed : 0
        currentElevation = location.altitude

        // Inform delegate of the updated location
        delegate?.didUpdateLocation(location)
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let formattedCoordinates = "Lat: \(latitude), Lon: \(longitude)"
        
        DispatchQueue.main.async {
            self.delegate?.didUpdateLocation(location)
            print("Updated current coordinates: \(formattedCoordinates)")
            self.currentCoordinates = formattedCoordinates
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
}
