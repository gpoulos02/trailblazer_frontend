//
//  AvailableRoutes.swift
//  TrailBlazer
//
//  Created by Sadie Smyth on 2024-11-19.
//

import SwiftUI

struct AvailableRoutesView: View {
    let availableRoutes: [[String]] // Updated to be an array of arrays of trail names
    var userName: String

    var body: some View {
        VStack(spacing: 20) {
            // Title
            // Logo at the top
            Image("TextLogo")
                .resizable()
                .scaledToFit()
                .frame(height: 40)
                .padding(.top, 20)
            
            Text("Available Routes")
                .font(Font.custom("Inter", size: 25).weight(.bold))
                .foregroundColor(.black)
                .padding()

            // Display Routes or No Routes Message
            if availableRoutes.isEmpty {
                Text("No routes available")
                    .font(Font.custom("Inter", size: 16))
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(availableRoutes.indices, id: \.self) { index in
                            let route = availableRoutes[index]
                            let routeDisplay = route.joined(separator: " → ") // Join trail names with an arrow
                            
                            // NavigationLink for each consolidated route
                            NavigationLink(
                                destination: SelectedRouteView(routeName: routeDisplay, userName: userName),
                                label: {
                                    Text(routeDisplay)
                                        .font(Font.custom("Inter", size: 16))
                                        .foregroundColor(.black)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(8)
                                }
                            )
                        }
                    }
                }
                .padding(.horizontal)
            }

            Spacer()
            // Navigation Bar at the Bottom
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
    }
    
}

            
    

struct AvailableRoutesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AvailableRoutesView(
                availableRoutes: [["Trail A", "Trail B"], ["Trail C", "Trail D", "Trail E"]],
                userName: "sampleUser"
            )
        }
    }
}
