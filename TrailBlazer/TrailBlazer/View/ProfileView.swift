//
//  ProfileView.swift
//  TrailBlazer
//
//  Created by Sadie Smyth on 2024-11-15.
//

import SwiftUI

struct ProfileView: View {
    // Sample data - Replace with actual user data when connected to a backend
    @State private var userName = "John Doe"
    @State private var email = "john.doe@example.com"
    @State private var notificationsEnabled = true
    @State private var isEditingProfile = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Profile Info Section
                VStack {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading) {
                            Text(userName)
                                .font(.title)
                                .fontWeight(.bold)
                            Text(email)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    
                    Button(action: {
                        // Toggle editing state
                        isEditingProfile.toggle()
                    }) {
                        Text(isEditingProfile ? "Save Changes" : "Edit Profile")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                    .padding(.top, 10)
                }
                
                Divider()
                
                // Settings Section
                VStack(alignment: .leading) {
                    Text("Settings")
                        .font(.headline)
                        .padding(.leading, 16)
                    
                    Toggle(isOn: $notificationsEnabled) {
                        Text("Enable Notifications")
                            .font(.subheadline)
                    }
                    .padding(.horizontal, 16)
                    
                    // Additional settings like theme, privacy, etc. can be added later
                }
                
                Divider()
                
                // Account Management Section
                VStack(alignment: .leading) {
                    Text("Account Management")
                        .font(.headline)
                        .padding(.leading, 16)
                    
                    NavigationLink(destination: ChangePasswordView()) {
                        Text("Change Password")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 16)
                    }
                    
                    NavigationLink(destination: ChangeEmailView()) {
                        Text("Change Email")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 16)
                    }
                }
                
                Divider()
                
                // Log Out Button
                Button(action: {
                    // Handle log out action here (e.g., call the backend to log out)
                    print("Logging out...")
                }) {
                    Text("Log Out")
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding(.top, 20)
                }
                .padding(.horizontal, 16)
                
                Spacer()
                
                // Bottom Navigation Bar
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
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Friends Button
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
                    
                    // Map Button
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
                    
                    // Weather Button
                    NavigationLink(destination: WeatherView()) {
                        VStack {
                            Image(systemName: "cloud.sun.fill") // Represents Weather
                                .foregroundColor(.black)
                            Text("Weather")
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
                }
                .padding()
                .background(Color.white)
                .shadow(radius: 5)
            }
            .edgesIgnoringSafeArea(.bottom) // Ensures bottom navigation bar is not obstructed by safe area
            .padding()
        }
    }
}



struct ChangeEmailView: View {
    var body: some View {
        Text("Change Email Page")
            .font(.title)
            .padding()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .previewDevice("iPhone 14")
    }
}
