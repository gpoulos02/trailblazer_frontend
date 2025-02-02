import SwiftUI

struct ProfileView: View {
    var userName: String // Accept the userName parameter

    @State private var userFirstName = ""
    @State private var userLastName = ""
    @State private var email = ""
    @State private var bio = ""
    
    @State private var isOfflineMapEnabled = false
    @State private var isDarkModeEnabled = UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
    @State private var showLogoutConfirmation = false // State for showing alert
    @State private var navigateToLandingView = false  // State for navigation
    @State private var showSOSConfirmation = false // State for showing SOS confirmation alert
    @State private var showSaveConfirmation = false // State for showing save confirmation alert
    @State private var isEditMode = false // Tracks if the user is in edit mode

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    // Profile Picture Section
                    VStack {
                        Image("profile")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                    }
                    .padding(.top, 20)

                    // Profile Info Section
                    VStack(alignment: .leading, spacing: 15) {
                        // Title and Edit Button
                        HStack {
                            Text("Profile Information")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Spacer()
                            Button(action: {
                                isEditMode.toggle() // Toggle edit mode
                            }) {
                                Text(isEditMode ? "Cancel" : "Update Profile")
                                    .foregroundColor(.blue)
                                    .padding(8)
                                    .background(Color(UIColor.systemGray5))
                                    .cornerRadius(8)
                            }
                        }

                        // Fields (Editable or Non-editable)
                        VStack(spacing: 10) {
                            // First Name
                            HStack {
                                Text("First Name:")
                                    .fontWeight(.bold)
                                Spacer()
                                if isEditMode {
                                    TextField("Enter First Name", text: $userFirstName)
                                        .padding(8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.white)
                                                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                        )
                                        .frame(maxWidth: 200) // Adjust width for better alignment
                                        .foregroundColor(.primary)
                                } else {
                                    Text(userFirstName)
                                        .foregroundColor(.secondary)
                                }
                            }
                            Divider()

                            // Last Name
                            HStack {
                                Text("Last Name:")
                                    .fontWeight(.bold)
                                Spacer()
                                if isEditMode {
                                    TextField("Enter Last Name", text: $userLastName)
                                        .padding(8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.white)
                                                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                        )
                                        .frame(maxWidth: 200)
                                        .foregroundColor(.primary)
                                } else {
                                    Text(userLastName)
                                        .foregroundColor(.secondary)
                                }
                            }
                            Divider()

                            // Email (Static)
                            HStack {
                                Text("Email:")
                                    .fontWeight(.bold)
                                Spacer()
                                Text(email)
                                    .foregroundColor(.secondary)
                            }
                            Divider()
                            
                            // Bio Section (New)
                            HStack {
                                Text("Bio:")
                                    .fontWeight(.bold)
                                Spacer()
                                if isEditMode {
                                    TextField("Enter Bio", text: $bio)
                                        .padding(8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.white)
                                                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                        )
                                        .frame(maxWidth: 200)
                                        .foregroundColor(.primary)
                                        .lineLimit(4) // Limit number of lines for the bio
                                } else {
                                    Text(bio.isEmpty ? "No bio provided" : bio)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }

                        // Save Changes Button (Only in Edit Mode)
                        if isEditMode {
                            Button(action: {
                                saveProfileChanges()
                                isEditMode = false // Exit edit mode after saving
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
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(UIColor.secondarySystemBackground))
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    )
                    .padding(.horizontal, 20)

                    // Settings Section
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Settings")
                            .font(.title2)
                            .fontWeight(.semibold)

                        Toggle(isOn: $isOfflineMapEnabled) {
                            Text("Enable Offline Map")
                                .font(.subheadline)
                        }
                        .padding(.horizontal, 16)

                        Toggle(isOn: $isDarkModeEnabled) {
                            Text("Enable Dark Mode")
                                .font(.subheadline)
                        }
                        .padding(.horizontal, 16)
                        .onChange(of: isDarkModeEnabled) { value in
                            toggleDarkMode(value: value)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(UIColor.secondarySystemBackground))
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    )
                    .padding(.horizontal, 20)

                    // SOS Button
                    VStack {
                        Button(action: {
                            showSOSConfirmation = true
                        }) {
                            Text("Emergency SOS")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red)
                                .cornerRadius(8)
                        }
                        .alert(isPresented: $showSOSConfirmation) {
                            Alert(
                                title: Text("Are you sure?"),
                                message: Text("Triggering Emergency SOS will alert local authorities and notify your TrailBlazer friends."),
                                primaryButton: .destructive(Text("Proceed")) {
                                    print("SOS triggered")
                                },
                                secondaryButton: .cancel()
                            )
                        }
                    }

                    // Log Out Button
                    VStack {
                        Button(action: {
                            showLogoutConfirmation = true
                        }) {
                            Text("Log Out")
                                .font(.headline)
                                .foregroundColor(.red)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(8)
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

                    // Navigation Link to LandingView
                    NavigationLink(
                        destination: LandingView(),
                        isActive: $navigateToLandingView
                    ) {
                        EmptyView()
                    }
                    Spacer()
                    
                    
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
                            .frame(maxWidth: .infinity)
                        }

                        NavigationLink(destination: RouteLandingView(userName: userName)) {
                            VStack {
                                Image(systemName: "map.fill")
                                    .foregroundColor(.black)
                                Text("Map")
                                    .foregroundColor(.black)
                                    .font(.caption)
                            }
                            .frame(maxWidth: .infinity)
                        }

                        NavigationLink(destination: PerformanceMetricsView(userName: userName)) {
                            VStack {
                                Image(systemName: "chart.bar.fill")
                                    .foregroundColor(.black)
                                Text("Metrics")
                                    .foregroundColor(.black)
                                    .font(.caption)
                            }
                            .frame(maxWidth: .infinity)
                        }

                        NavigationLink(destination: ProfileView(userName: userName)) {
                            VStack {
                                Image(systemName: "person.fill")
                                    .foregroundColor(.black)
                                Text("Profile")
                                    .foregroundColor(.black)
                                    .font(.caption)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding()
                    .background(Color.white)

                }
                .padding(.bottom, 40)
            }
            .onAppear {
                fetchProfileData()
            }
            .navigationTitle("My Profile")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(isDarkModeEnabled ? .dark : .light)
        }
    }
    private func toggleDarkMode(value: Bool) {
        UserDefaults.standard.set(value, forKey: "isDarkModeEnabled")
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
}


// Profile Model
struct Profile: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let bio: String
}
