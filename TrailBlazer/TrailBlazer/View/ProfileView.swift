import SwiftUI

struct ProfileView: View {
    @State private var userFirstName = "John"
    @State private var userLastName = "Doe"
    @State private var email = "john.doe@example.com"
    @State private var notificationsEnabled = true
    @State private var isEditingProfile = false
    @State private var isOfflineMapEnabled = false
    @State private var isDarkModeEnabled = false
    @State private var isImagePicked = false
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
                        // Add action for selecting or taking a profile picture
                    }) {
                        Text("Change Profile Picture")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }

                // Profile Info Section
                VStack {
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
                VStack(alignment: .leading) {
                    NavigationLink(destination: ChangePasswordView()) {
                        Text("Change Password")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 16)
                    }
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
            
            HStack {
                // Home Button
                NavigationLink(destination: HomeView()) {
                    VStack {
                        Image(systemName: "house.fill")
                            .foregroundColor(.black)
                        Text("Home")
                            .foregroundColor(.black)
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                }
                NavigationLink(destination: FriendView()) {
                    VStack {
                        Image(systemName: "person.2.fill") // Represents friends
                            .foregroundColor(.black)
                        Text("Friends")
                            .foregroundColor(.black)
                            .font(.caption)
                    }
                }
                .frame(maxWidth: .infinity)
                
                NavigationLink(destination: RouteLandingView()) {
                    VStack {
                        Image(systemName: "map.fill") // Represents Map
                            .foregroundColor(.black)
                        Text("Map")
                            .foregroundColor(.black)
                            .font(.caption)
                    }
                }
                .frame(maxWidth: .infinity)

                //performance metrics button
                NavigationLink(destination: PerformanceMetricsView()) {
                    VStack {
                        Image(systemName: "chart.bar.fill") // Represents Weather
                            .foregroundColor(.black)
                        Text("Metrics")
                            .foregroundColor(.black)
                            .font(.caption)
                    }
                }
                .frame(maxWidth: .infinity)
                // Profile Button (Navigates to Profile View)
                NavigationLink(destination: ProfileView()) {
                    VStack {
                        Image(systemName: "person.fill") // Represents Profile
                            .foregroundColor(.black)
                        Text("Profile")
                            .foregroundColor(.black)
                            .font(.caption)
                    }
                }
                .frame(maxWidth: .infinity)
                
                // Placeholder for other buttons if needed, e.g. Friends, Map, Weather, Profile...
            }
        }
    }

    // Save name changes to the backend (placeholder logic)
    func saveNameChanges() {
        // Save first and last name
        print("Name updated to \(userFirstName) \(userLastName)")
    }

    // Trigger SOS action (placeholder logic)
    func triggerSOS() {
        print("SOS triggered")
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            
    }
}
