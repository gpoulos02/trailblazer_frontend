import SwiftUI

struct ProfileView: View {
    var userName: String // Accept the userName parameter

    @State private var userFirstName = "John"
    @State private var userLastName = "Doe"
    @State private var email = "john.doe@example.com"
    @State private var notificationsEnabled = true
    @State private var isOfflineMapEnabled = false
    @State private var isDarkModeEnabled = false
    @State private var profileImage: Image? = nil
    
    @State private var showLogoutConfirmation = false // State for showing alert
    @State private var navigateToLandingView = false  // State for navigation
    @State private var showSOSConfirmation = false // State for showing SOS confirmation alert

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Profile Picture Section
                VStack {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Button(action: {
                        // Action for changing the profile picture
                        print("Change Profile Picture tapped")
                    }) {
                        Text("Change Profile Picture")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }

                // Profile Info Section
                VStack(spacing: 10) {
                    TextField("First Name", text: $userFirstName)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Last Name", text: $userLastName)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    // Disabled button for saving name changes (no functionality for now)
                    Button(action: {}) {
                        Text("Save Changes")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                    }
                    .disabled(true) // Disable the button for now
                }

                Divider()
                
                // Settings Section
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

                Divider()
                
                // SOS Button
                Button(action: {
                    showSOSConfirmation = true // Show SOS confirmation alert
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
                        message: Text("Are you sure you want to trigger Emergency SOS? Doing so will alert local authorities and your location will be sent to Mountain Ski Patrol, along with your TrailBlazer Friends."),
                        primaryButton: .destructive(Text("Proceed")) {
                            // Add the actual SOS trigger code here
                            print("SOS triggered")
                        },
                        secondaryButton: .cancel()
                    )
                }
                
                // Account Management Section
                NavigationLink(destination: ChangePasswordView()) {
                    Text("Change Password")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 16)
                }

                Divider()
                
                // Log Out Button
                Button(action: {
                    showLogoutConfirmation = true // Show confirmation alert
                }) {
                    Text("Log Out")
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding(.top, 20)
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

                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $navigateToLandingView) {
                LandingView()
            }
        }
    }

    func performLogout() {
        
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            print("Token: \(token)") // Debugging step
        } else {
            print("No token found")
        }
        
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            print("No token found")
            return
        }

        // API endpoint for logout
        guard let url = URL(string: "https://TrailBlazer33:5001/api/auth/logout") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Logout failed: \(error.localizedDescription)")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("Logout failed with response: \(response.debugDescription)")
                    return
                }

                // Handle successful logout
                print("Logged out successfully")
                
                navigateToLandingView = true

            }
        }.resume()
    }

}
