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
                    
                    Button(action: saveNameChanges) {
                        Text("Save Changes")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                    }
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
                Button(action: triggerSOS) {
                    Text("Emergency SOS")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(8)
                }
                .padding()
                
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
                    print("Logging out...")
                }) {
                    Text("Log Out")
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding(.top, 20)
                }
                .padding(.horizontal, 16)
                
                Spacer()
            }
            .padding()

            // Bottom Navigation Bar
            HStack {
                // Home Button
                NavigationLink(destination: HomeView(userName: userName)) { // Pass userName to HomeView
                    VStack {
                        Image(systemName: "house.fill")
                            .foregroundColor(.black)
                        Text("Home")
                            .foregroundColor(.black)
                            .font(.caption)
                    }
                }
                .frame(maxWidth: .infinity)
                
                // Friends Button
                NavigationLink(destination: FriendView(userName: userName)) { // Pass userName to FriendView
                    VStack {
                        Image(systemName: "person.2.fill")
                            .foregroundColor(.black)
                        Text("Friends")
                            .foregroundColor(.black)
                            .font(.caption)
                    }
                }
                .frame(maxWidth: .infinity)
                
                // Map Button
                NavigationLink(destination: RouteLandingView(userName: userName)) { // Pass userName to SetNewRouteView
                    VStack {
                        Image(systemName: "map.fill")
                            .foregroundColor(.black)
                        Text("Map")
                            .foregroundColor(.black)
                            .font(.caption)
                    }
                }
                .frame(maxWidth: .infinity)

                // Performance Metrics Button
                NavigationLink(destination: PerformanceMetricsView()) {
                    VStack {
                        Image(systemName: "chart.bar.fill") // Represents Metrics
                            .foregroundColor(.black)
                        Text("Metrics")
                            .foregroundColor(.black)
                            .font(.caption)
                    }
                }
                .frame(maxWidth: .infinity)
                
                // Profile Button
                NavigationLink(destination: ProfileView(userName: userName)) { // Pass userName to ProfileView
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
        }
    }

    // Save name changes to the backend (placeholder logic)
    func saveNameChanges() {
        print("Name updated to \(userFirstName) \(userLastName)")
    }

    // Trigger SOS action (placeholder logic)
    func triggerSOS() {
        print("SOS triggered")
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(userName: "John Doe") // Provide a sample userName for preview
    }
}
