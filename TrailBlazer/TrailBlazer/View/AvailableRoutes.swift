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
    @State private var currentTab: Tab = .map

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
