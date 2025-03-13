import SwiftUI

struct ProfileView: View {
    var userName: String

    @State private var userFirstName = ""
    @State private var userLastName = ""
    @State private var email = ""
    @State private var bio = ""
    
    @State private var isOfflineMapEnabled = false
    @State private var isDarkModeEnabled = UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
    @State private var showLogoutConfirmation = false
    @State private var navigateToLandingView = false
    @State private var showSOSConfirmation = false
    @State private var showSaveConfirmation = false
    @State private var isEditMode = false
    @State private var currentTab: Tab = .profile

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    ProfilePicture()
                    ProfileInfo()
                    SettingsSection()
                    SOSButton()
                    LogoutButton()

                    NavigationLink(
                        destination: LandingView(),
                        isActive: $navigateToLandingView
                    ) {
                        EmptyView()
                    }
                    
                    HStack {
                                            TabBarItem(
                                                tab: .home,
                                                currentTab: $currentTab,
                                                destination: {HomeView(userName: userName)},
                                                imageName: "house.fill",
                                                label: "Home"
                                            )
                                            
                                            TabBarItem(
                                                tab: .friends,
                                                currentTab: $currentTab,
                                                destination: {FriendView(userName: userName)},
                                                imageName: "person.2.fill",
                                                label: "Friends"
                                            )
                                            
                                            TabBarItem(
                                                tab: .map,
                                                currentTab: $currentTab,
                                                destination: {RouteLandingView(userName: userName)},
                                                imageName: "map.fill",
                                                label: "Map"
                                            )
                                            
                                            TabBarItem(
                                                tab: .metrics,
                                                currentTab: $currentTab,
                                                destination: {PerformanceMetricsView(userName: userName)},
                                                imageName: "chart.bar.fill",
                                                label: "Metrics"
                                            )
                                            
                                            TabBarItem(
                                                tab: .profile,
                                                currentTab: $currentTab,
                                                destination: {ProfileView(userName: userName)},
                                                imageName: "person.fill",
                                                label: "Profile"
                                            )
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

    // MARK: - Settings Section
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
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.blue, lineWidth: 1)
                    )
            }
            
            Toggle(isOn: $isDarkModeEnabled) {
                Text("Enable Dark Mode")
                    .font(.subheadline)
            }
            .onChange(of: isDarkModeEnabled) { value in
                toggleDarkMode(value: value)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12)
            .fill(Color(UIColor.secondarySystemBackground))
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        )
        .padding(.horizontal, 20)
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

struct EditableField: View {
    var label: String
    @Binding var value: String
    var isEditable: Bool

    var body: some View {
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
        Divider()
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
