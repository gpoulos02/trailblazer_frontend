import SwiftUI
import CoreMotion

struct ProfileView: View {
    var userName: String
    
    @State private var userFirstName = ""
    @State private var userLastName = ""
    @State private var email = ""
    @State private var bio = ""
    @State private var role = ""
    
    @State private var isOfflineMapEnabled = false
    @State private var isDarkModeEnabled = UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
    @State private var showLogoutConfirmation = false
    @State private var navigateToLandingView = false
    @State private var showSOSConfirmation = false
    @State private var showSaveConfirmation = false
    @State private var isEditMode = false
    @State private var currentTab: Tab = .profile
    @State private var currentCoordinates: String = "Loading..."
    
    @StateObject private var locationManager = LocationManager()
    @StateObject private var motionManager = MotionManager()
    @State private var isAlertSent = false

    var body: some View {
            NavigationStack {
                ZStack(alignment: .bottom) {
                    VStack {
                        ScrollView {
                            VStack(spacing: 30) {
                                ProfilePicture()
                                ProfileInfo()
                                
                                Text("📍 Location: \(locationManager.currentCoordinates)")
                                    .font(.footnote)
                                    .foregroundColor(.black)
                                    .padding()
                                
                                if role == "admin" {
                                    SettingsSection()
                                }
                                
                                if role == "mountain_owner" {
                                    MountainOwnerSection()
                                }
                                
                                ButtonsSection()
                                
                                if motionManager.isUserInactive {
                                    Text("You have been inactive for too long! Alert sent to friends.")
                                        .foregroundColor(.red)
                                        .padding()
                                        .background(Color.yellow)
                                        .cornerRadius(10)
                                }
                                
                                Button(action: {
                                    motionManager.sendInactivityAlert()
                                    isAlertSent = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                                        isAlertSent = false
                                    }
                                }) {
                                    Text(isAlertSent ? "Alert Sent" : "🚨 Alert Friends")
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(isAlertSent ? Color.green : Color.gray)
                                        .cornerRadius(8)
                                }
                            }
                            .padding(.bottom, 100)
                        }
                        
                        // NavigationLink to LandingView
                        NavigationLink(
                            destination: LandingView(),
                            isActive: $navigateToLandingView
                        ) {
                            EmptyView()
                        }
                    }
                    
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
                        .shadow(radius: 5)
                    }
                    .frame(maxWidth: .infinity)
                }
                .onAppear {
                    fetchProfileData()
                    fetchUserRole()
                }
                .navigationTitle("My Profile")
                .navigationBarTitleDisplayMode(.inline)
                .preferredColorScheme(isDarkModeEnabled ? .dark : .light)
            }
        }
    
    // MARK: - Profile Picture
    private func ProfilePicture() -> some View {
        VStack {
            Image("profile")
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 150)
                .clipShape(Circle())
        }
        .padding(.top, 20)
    }
    
    // MARK: - Profile Info
    private func ProfileInfo() -> some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Profile Information")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
                Button(action: {
                    isEditMode.toggle()
                }) {
                    Text(isEditMode ? "Cancel" : "Update Profile")
                        .foregroundColor(.blue)
                        .padding(8)
                        .background(Color(UIColor.systemGray5))
                        .cornerRadius(8)
                }
            }
            
            EditableField(label: "First Name", value: $userFirstName, isEditable: isEditMode)
            EditableField(label: "Last Name", value: $userLastName, isEditable: isEditMode)
            ReadOnlyField(label: "Email", value: email)
            EditableField(label: "Bio", value: $bio, isEditable: isEditMode)
            
            if isEditMode {
                Button(action: {
                    saveProfileChanges()
                    isEditMode = false
                }) {
                    Text("Save Changes")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12)
            .fill(Color(UIColor.secondarySystemBackground))
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        )
        .padding(.horizontal, 20)
    }
    
    // MARK: - Settings Section (Only for Admins)
    private func SettingsSection() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Settings")
                .font(.title2)
                .fontWeight(.semibold)
            
            NavigationLink(destination: AdminView(userName: userName)) {
                Text("Admin Page")
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .padding(6)
                    .frame(maxWidth: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.blue, lineWidth: 1)
                    )
            }
        }
        .padding()
        .frame(maxWidth: .infinity) // Ensures the entire section is as wide as ProfileInfo
        .background(RoundedRectangle(cornerRadius: 12)
            .fill(Color(UIColor.secondarySystemBackground))
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        )
        .padding(.horizontal, 20)
    }
    
    private func MountainOwnerSection() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Settings")
                .font(.title2)
                .fontWeight(.semibold)

            NavigationLink(destination: MountainOwnerView(userName: userName)) {
                Text("Mountain Owner Page")
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .padding(6)
                    .frame(maxWidth: .infinity) // Make the button expand full width
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.blue, lineWidth: 1)
                    )
            }
        }
        .padding()
        .frame(maxWidth: .infinity) // Ensures the entire section is as wide as ProfileInfo
        .background(RoundedRectangle(cornerRadius: 12)
            .fill(Color(UIColor.secondarySystemBackground))
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        )
        .padding(.horizontal, 20)
    }
    
    // MARK: - SOS and Logout Buttons
    private func ButtonsSection() -> some View {
        VStack(spacing: 10) { // Reduced spacing
            SOSButton()
            LogoutButton()
        }
        .padding(.horizontal, 20) // Matches ProfileInfo padding
    }
    
    // MARK: - SOS Button
    private func SOSButton() -> some View {
        Button(action: {
            showSOSConfirmation = true
        }) {
            Text("Emergency SOS")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .cornerRadius(10)
        }
        .alert(isPresented: $showSOSConfirmation) {
            Alert(
                title: Text("Emergency SOS"),
                message: Text("Triggering Emergency SOS will alert ski patrol. Select the correct mountain."),
                primaryButton: .default(Text("Blue Mountain Ski Patrol")) {
                    callResortPhoneNumber(number: "7054450231") // Resort 1's phone number
                },
                secondaryButton: .default(Text("Boler Mountain Ski Patrol")) {
                    callResortPhoneNumber(number: "5196578822") // Resort 2's phone number
                }
            )
        }
    }

    // MARK: - Logout Button
    private func LogoutButton() -> some View {
        Button(action: {
            showLogoutConfirmation = true
        }) {
            Text("Log Out")
                .font(.headline)
                .foregroundColor(.red)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
        }
        .alert(isPresented: $showLogoutConfirmation) {
            Alert(
                title: Text("Log Out"),
                message: Text("Are you sure you want to log out?"),
                primaryButton: .destructive(Text("Log Out")) {
                    performLogout()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private func toggleDarkMode(value: Bool) {
        UserDefaults.standard.set(value, forKey: "isDarkModeEnabled")
    }
    
    private func callResortPhoneNumber(number: String) {
        // Clean the number in case there are any non-numeric characters
        let cleanedNumber = number.filter { $0.isNumber }// Debug statement
        if let phoneURL = URL(string: "tel://\(cleanedNumber)") {// Debug statement
            
            if UIApplication.shared.canOpenURL(phoneURL) {
                print("Can open URL: \(phoneURL)") // Debug statement
                UIApplication.shared.open(phoneURL)
            } else {
                print("Cannot make a phone call.")
            }
        } else {
            print("Invalid phone URL") // Debug statement
        }
    }
    
    func fetchProfileData() {
        guard let token = UserDefaults.standard.string(forKey: "authToken"),
              let url = URL(string: "https://TrailBlazer33:5001/api/auth/profile") else {
            print("Invalid URL or missing token")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching profile:", error.localizedDescription)
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let profile = try JSONDecoder().decode(Profile.self, from: data)
                DispatchQueue.main.async {
                    self.userFirstName = profile.firstName
                    self.userLastName = profile.lastName
                    self.email = profile.email
                    self.bio = profile.bio
                }
            } catch {
                print("Failed to decode profile data:", error.localizedDescription)
                if let dataString = String(data: data, encoding: .utf8) {
                    print("Received response:", dataString)
                }
            }
        }.resume()
    }
    
    func performLogout() {
        guard let token = UserDefaults.standard.string(forKey: "authToken"),
              let url = URL(string: "https://TrailBlazer33:5001/api/auth/logout") else {
            print("Invalid URL or missing token")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Logout failed:", error.localizedDescription)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("Logout failed with response:", response.debugDescription)
                    return
                }
                
                UserDefaults.standard.removeObject(forKey: "authToken") // Clear token
                self.navigateToLandingView = true // Trigger navigation to LandingView
            }
        }.resume()
    }
    
    func saveProfileChanges() {
        guard let token = UserDefaults.standard.string(forKey: "authToken"),
              let url = URL(string: "https://TrailBlazer33:5001/api/auth/update-profile") else {
            print("Invalid URL or missing token")
            return
        }
        
        let body: [String: Any] = [
            "firstName": userFirstName,
            "lastName": userLastName,
            "bio": bio
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error updating profile:", error.localizedDescription)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("Update failed with response:", response.debugDescription)
                    return
                }
                
                self.showSaveConfirmation = true
            }
        }.resume()
    }
    
    func fetchUserRole() {
        guard let token = UserDefaults.standard.string(forKey: "authToken"),
              let url = URL(string: "https://TrailBlazer33:5001/api/admin/userTypeByID") else {
            print("Invalid URL or missing token")
            return
        }
        
        print("Fetching user role from:", url)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching user role:", error.localizedDescription)
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code:", httpResponse.statusCode)
            }
            
            do {
                let roleResponse = try JSONDecoder().decode(RoleResponse.self, from: data)
                DispatchQueue.main.async {
                    self.role = roleResponse.role
                    print("User role fetched successfully:", self.role)
                }
            } catch {
                print("Failed to decode user role:", error.localizedDescription)
                if let dataString = String(data: data, encoding: .utf8) {
                    print("📥 Received response:", dataString)
                }
            }
        }.resume()
    }
    
    
    // MARK: - MotionManager (Handles Inactivity)
    class MotionManager: NSObject, ObservableObject {
        private let motionManager = CMMotionManager()
        private var lastActivityTime = Date()
        private var inactivityTimer: Timer?
        private let inactivityThreshold: TimeInterval = 300 // 10 seconds
        private let locationManager = LocationManager()
        
        @Published var isUserInactive = false
        
        override init() {
            super.init()
            print("MotionManager initialized!")  // Debug log
            startMotionUpdates()
            startInactivityTimer()
        }
        
        private func startMotionUpdates() {
            if motionManager.isAccelerometerAvailable {
                motionManager.accelerometerUpdateInterval = 1.0
                motionManager.startAccelerometerUpdates(to: OperationQueue.main) { [weak self] (data, error) in
                    guard let self = self, let data = data else { return }
                    
                    let acceleration = abs(data.acceleration.x) + abs(data.acceleration.y) + abs(data.acceleration.z)
                    
                    if acceleration > 0.05 {
                        print("Movement detected - Resetting inactivity timer")
                        self.lastActivityTime = Date()
                        self.isUserInactive = false
                    }
                }
            }
        }
        
        private func startInactivityTimer() {
            print("⏳ Inactivity timer started!")
            
            inactivityTimer?.invalidate()
            inactivityTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                self.checkInactivity()
            }
            
            // Force an immediate check on startup
            checkInactivity()
        }
        
        private func checkInactivity() {
            let elapsed = Date().timeIntervalSince(lastActivityTime)
            print("Checking inactivity... Elapsed time: \(elapsed) seconds (Threshold: \(inactivityThreshold))")
            
            if elapsed >= inactivityThreshold {
                if !isUserInactive {
                    print("User inactive for too long! Sending alert...")
                    isUserInactive = true
                    sendInactivityAlert()
                }
            } else {
                isUserInactive = false
            }
        }
        
        public func sendInactivityAlert() {
            guard let location = locationManager.currentLocation else {
                print("No location available, cannot send alert.")
                return
            }
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            print("Sending inactivity alert for location: \(latitude), \(longitude)")
            
            sendAlertToFriends(latitude: latitude, longitude: longitude)
        }
        
        private func sendAlertToFriends(latitude: Double, longitude: Double) {
            guard let token = UserDefaults.standard.string(forKey: "authToken"),
                  let url = URL(string: "https://TrailBlazer33:5001/api/notifications/inactivity") else {
                print("Invalid URL or missing token")
                return
            }
            
            let body: [String: Any] = [
                "latitude": latitude,
                "longitude": longitude
            ]
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error sending alert:", error.localizedDescription)
                    return
                }
                print("Alert sent successfully!")
            }.resume()
        }
    }
}
    
struct RoleResponse: Codable {
    let role: String
}

// Profile Model
struct Profile: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let bio: String
}

struct EditableField: View {
    var label: String
    @Binding var value: String
    var isEditable: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("\(label):")
                    .fontWeight(.bold)
                Spacer()
                if isEditable {
                    TextField("Enter \(label)", text: $value)
                        .padding(8)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 2)
                } else {
                    Text(value).foregroundColor(.secondary)
                }
            }
            
            if label != "Bio" {
                Divider()
            }
        }
    }
}


struct ReadOnlyField: View {
    var label: String
    var value: String
    
    var body: some View {
        HStack {
            Text("\(label):")
                .fontWeight(.bold)
            Spacer()
            Text(value).foregroundColor(.secondary)
        }
        Divider()
    }
}
