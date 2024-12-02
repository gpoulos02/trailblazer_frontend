import SwiftUI

struct ProfileView: View {
    var userName: String // Accept the userName parameter

    @State private var userFirstName = ""
    @State private var userLastName = ""
    @State private var email = ""

    @State private var isOfflineMapEnabled = false
    @State private var isDarkModeEnabled = UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
    @State private var showLogoutConfirmation = false // State for showing alert
    @State private var navigateToLandingView = false  // State for navigation
    @State private var showSOSConfirmation = false // State for showing SOS confirmation alert

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    // Profile Picture Section
                    VStack {
                        Image("profile")
                            .resizable() // Make the image resizable
                            .scaledToFill() // Scale the image to completely fill the frame
                            .frame(width: 185, height: 185) // Set the size of the image
                            .clipShape(Circle()) // Clip the image into a circular shape


                    }
                    .padding(.top, 20)

                    // Profile Info Section (Card Style)
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Profile Information")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.bottom, 10)

                        HStack {
                            Text("First Name:")
                                .fontWeight(.bold)
                            Spacer()
                            Text(userFirstName)
                                .foregroundColor(.secondary)
                        }
                        Divider()

                        HStack {
                            Text("Last Name:")
                                .fontWeight(.bold)
                            Spacer()
                            Text(userLastName)
                                .foregroundColor(.secondary)
                        }
                        Divider()

                        HStack {
                            Text("Email:")
                                .fontWeight(.bold)
                            Spacer()
                            Text(email)
                                .foregroundColor(.secondary)
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
                        .padding()
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
                        .padding()
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
                }
                .padding(.bottom, 40) // Extra padding at the bottom
            }
            .onAppear {
                fetchProfileData()
            }
            .navigationTitle("My Profile")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(isDarkModeEnabled ? .dark : .light)
        }
    }

    // Save the dark mode preference to UserDefaults
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
                    print("Profile fetched successfully")
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

                print("Logged out successfully")
                UserDefaults.standard.removeObject(forKey: "authToken") // Clear token
                self.navigateToLandingView = true // Trigger navigation to LandingView
            }
        }.resume()
    }
}

// Profile Model
struct Profile: Codable {
    let firstName: String
    let lastName: String
    let email: String
}
