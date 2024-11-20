// FriendView.swift
// TrailBlazer
//
// Created by Sadie Smyth on 2024-11-15.
//

import SwiftUI

struct FriendView: View {
    var body: some View {
        VStack(spacing: 20) {
//            Text("Friends")
//                .font(.largeTitle)
//                .fontWeight(.bold)
//                .padding()
            
            // Add placeholder content for connecting with friends, performance metrics, and location sharing
            VStack {
                Text("Connect with friends")
                    .font(.title2)
                    .padding()
                
                // Add buttons or features related to adding/viewing friends
                Button(action: {
                    // Action for adding a friend
                    print("Add friend tapped")
                }) {
                    Text("Add Friend")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Text("Share Performance Metrics")
                    .font(.title2)
                    .padding()
                
                Button(action: {
                    // Action for sharing performance metrics
                    print("Share performance metrics tapped")
                }) {
                    Text("Share Metrics")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Text("Share Your Location")
                    .font(.title2)
                    .padding()
                
                Button(action: {
                    // Action for sharing location
                    print("Share location tapped")
                }) {
                    Text("Share Location")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
            Spacer()
            // Navigation Bar at the Bottom
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
            }
            .padding()
            .background(Color.white)
            .shadow(radius: 5)
            
            
        }
        //.navigationTitle("Friends")
        
    }
}

struct FriendView_Previews: PreviewProvider {
    static var previews: some View {
        FriendView()
    }
}
