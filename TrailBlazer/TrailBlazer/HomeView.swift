//  HomeView.swift
//  TrailBlazer
//
//  Created by Sadie Smyth on 2024-11-15.
//

import SwiftUI

struct HomeView: View {
    // Sample data - Replace with actual user data when connected to a database
    @State private var userName = "John Doe"
    @State private var currentRoute = "None"
    @State private var isHomeActive = false
    
    var body: some View {
        VStack(spacing: 20) {
            AsyncImage(url: URL(string: "https://via.placeholder.com/314x290"))
                .frame(width: 314, height: 290)
                .padding(.top, 16)
            // Header
            Text("Welcome, \(userName)")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 40)
            
            // Current Route Status
            Text("Current Route: \(currentRoute)")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 40)
            
            // Quick Access Buttons (Create New Route and Set New Route)
            HStack {
                NavigationLink(destination: CreateNewRouteView()) {
                    HomeButton(title: "Create New Route", imageName: "plus.circle.fill")
                }
                NavigationLink(destination: SetNewRouteView()) {
                    HomeButton(title: "Set New Route", imageName: "map.fill")
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
            // Navigation Bar at the Bottom
            HStack {
                // Home Button
                NavigationLink(destination: HomeView()) {
                    Button(action: {
                        self.isHomeActive = true
                    }) {
                        VStack {
                            Image(systemName: "house.fill")
                                .foregroundColor(.black)
                            Text("Home")
                                .foregroundColor(.black)
                                .font(.caption)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding()
            .background(Color.white)
            .shadow(radius: 5)
            
            Spacer()
        }
        .navigationTitle("Home")
        .padding()
    }
}

struct HomeButton: View {
    var title: String
    var imageName: String
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .font(.title)
                .foregroundColor(.blue)
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewDevice("iPhone 14") // You can specify a device here for better testing
    }
}
