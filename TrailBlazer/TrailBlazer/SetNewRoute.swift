//
//  RouteLanding.swift
//  TrailBlazer
//
//  Created by Sadie Smyth on 2024-11-13.
//

import SwiftUI

struct SetNewRouteView: View {
    var body: some View {
        VStack( spacing: 20) {
            HStack(spacing: 134) {
                HStack(spacing: 10) {
                    Text("9:41")
                        .font(Font.custom("Inter", size: 17).weight(.semibold))
                        .lineSpacing(22)
                        .foregroundColor(.black)
                }
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 6))
                .frame(maxWidth: .infinity, minHeight: 22, maxHeight: 22)
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 124, height: 10)
                
                HStack(spacing: 7) {
                    ZStack() {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 25, height: 13)
                            .cornerRadius(4.30)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4.30)
                                    .inset(by: 0.50)
                                    .stroke(.black, lineWidth: 0.50)
                            )
                            .offset(x: -1.16, y: 0)
                            .opacity(0.35)
                        
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 21, height: 9)
                            .background(.black)
                            .cornerRadius(2.50)
                            .offset(x: -1.16, y: 0)
                    }
                    .frame(width: 27.33, height: 13)
                }
                .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 16))
                .frame(maxWidth: .infinity, minHeight: 13, maxHeight: 13)
            }
            .frame(maxWidth: .infinity)
            .padding(EdgeInsets(top: 21, leading: 0, bottom: 0, trailing: 0))
            .frame(width: 402, height: 50)
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 256, height: 36)
                .background(
                    AsyncImage(url: URL(string: "https://via.placeholder.com/256x36"))
                )
     

            
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 343, height: 362)
                .background(
                    AsyncImage(url: URL(string: "https://via.placeholder.com/343x362"))
                )
                .cornerRadius(5)
            
            
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
            
            HStack(spacing: 8) {
                Text("Saved Routes")
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
            
            Spacer()
            
            // Navigation Bar at the Bottom
            HStack {
                // Home Button
                Button(action: {
                    // Action for Home tab
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
                
                // Friends Button
                Button(action: {
                    // Action for Friends tab
                }) {
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
                Button(action: {
                    // Action for Map tab
                }) {
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
                Button(action: {
                    // Action for Weather tab
                }) {
                    VStack {
                        Image(systemName: "cloud.sun.fill") // Represents Weather
                            .foregroundColor(.black)
                        Text("Weather")
                            .foregroundColor(.black)
                            .font(.caption)
                    }
                }
                .frame(maxWidth: .infinity)
                
                // Profile Button
                Button(action: {
                    // Action for Profile tab
                }) {
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
    }
}
struct SetNewRouteView_Previews: PreviewProvider {
    static var previews: some View {
        SetNewRouteView()
    }
}

