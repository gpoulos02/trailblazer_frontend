//  RouteLanding.swift
//  TrailBlazer
//
//  Created by Sadie Smyth on 2024-11-13.
//

import SwiftUI

struct RouteLandingView: View {
    
    // Add a navigation state for each tab
    @State private var isHomeActive = false
    @State private var isFriendsActive = false
    @State private var isMapActive = false
    @State private var isWeatherActive = false
    @State private var isProfileActive = false
    
    // Add states for the new route buttons
    @State private var isSetNewRouteActive = false
    @State private var isCreateNewRouteActive = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 256, height: 36)
                    .background(
                        AsyncImage(url: URL(string: "https://via.placeholder.com/256x36"))
                    )
                
                HStack {
                    Text("Your Current Location")
                        .font(Font.custom("Inter", size: 12).weight(.medium))
                        .foregroundColor(Color(red: 0.25, green: 0.25, blue: 0.25))
                        .padding(.horizontal, 12) // Add padding on both sides of the text
                        .padding(.vertical, 6) // Vertical padding for balance
                        .background(Color(red: 0.94, green: 0.94, blue: 0.94)) // Rectangle background color
                        .cornerRadius(5) // Rounded corners
                }
                .frame(maxWidth: .infinity, alignment: .leading) // Ensure the HStack stretches to the width of the screen
                .padding(.leading, 16) // Add space on the left side of the screen
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 343, height: 362)
                    .background(
                        AsyncImage(url: URL(string: "https://via.placeholder.com/343x362"))
                    )
                    .cornerRadius(5)
                
                // Set New Route Button with NavigationLink
                NavigationLink(destination: SetNewRouteView()) {
                    HStack(spacing: 8) {
                        Text("Set New Route")
                            .font(Font.custom("Inter", size: 16))
                            .lineSpacing(16)
                            .foregroundColor(Color(red: 0.96, green: 0.96, blue: 0.96))
                    }
                    .padding(12)
                    .frame(width: 144, height: 42)
                    .background(Color(red: 0.17, green: 0.17, blue: 0.17))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .inset(by: 0.50)
                            .stroke(Color(red: 0.17, green: 0.17, blue: 0.17), lineWidth: 0.50)
                    )
                }
                
                // Create New Route Button with NavigationLink
                NavigationLink(destination: CreateNewRouteView()) {
                    HStack(spacing: 8) {
                        Text("Create New Route")
                            .font(Font.custom("Inter", size: 16))
                            .lineSpacing(16)
                            .foregroundColor(Color(red: 0.96, green: 0.96, blue: 0.96))
                    }
                    .padding(12)
                    .frame(width: 144, height: 42)
                    .background(Color(red: 0.25, green: 0.61, blue: 1))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .inset(by: 0.50)
                            .stroke(Color(red: 0.25, green: 0.61, blue: 1), lineWidth: 0.50)
                    )
                }
                
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
                    
                    // Placeholder for other buttons if needed, e.g. Friends, Map, Weather, Profile...
                }
                .padding()
                .background(Color.white)
                .shadow(radius: 5)
            }
        }
    }
}

struct RouteLandingView_Previews: PreviewProvider {
    static var previews: some View {
        RouteLandingView()
    }
}
