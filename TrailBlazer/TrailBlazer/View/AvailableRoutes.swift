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
        }
        .padding()
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
