//
//  LogInView.swift
//  TrailBlazer
//
//  Created by Sadie Smyth on 2024-11-13.
//

import SwiftUI

struct LogInView: View {
    var body: some View {
        
        VStack(spacing: 20) {
            // Placeholder Image
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 314, height: 290)
                .background(
                    AsyncImage(url: URL(string: "https://via.placeholder.com/314x290"))
                )
                .padding(.top, 16)
            
            // Username Field
            HStack(alignment: .top, spacing: 0) {
                Text("Username")
                    .font(Font.custom("Inter", size: 17))
                    .lineSpacing(22)
                    .foregroundColor(.black)
                Spacer()
                Text("Enter your username")
                    .font(Font.custom("Inter", size: 17))
                    .lineSpacing(22)
                    .foregroundColor(Color(red: 0.24, green: 0.24, blue: 0.26).opacity(0.30))
            }
            .padding(.horizontal, 16)
            .frame(width: 317, height: 45)
            .overlay(
                Rectangle()
                    .stroke(Color(red: 0.33, green: 0.33, blue: 0.34).opacity(0.34), lineWidth: 0.17)
            )
            
            // Password Field
            HStack(alignment: .top, spacing: 0) {
                Text("Password")
                    .font(Font.custom("Inter", size: 17))
                    .lineSpacing(22)
                    .foregroundColor(.black)
                Spacer()
                Text("Enter your password")
                    .font(Font.custom("Inter", size: 17))
                    .lineSpacing(22)
                    .foregroundColor(Color(red: 0.24, green: 0.24, blue: 0.26).opacity(0.30))
            }
            .padding(.horizontal, 16)
            .frame(width: 317, height: 45)
            .overlay(
                Rectangle()
                    .stroke(Color(red: 0.33, green: 0.33, blue: 0.34).opacity(0.34), lineWidth: 0.17)
            )
            
            // Welcome Back Text
            Text("Welcome Back!")
                .font(Font.custom("Inter", size: 25))
                .foregroundColor(.black)
                .padding(.top, 20)
            
            // Log In Button
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 287, height: 50)
                .background(Color(red: 0.55, green: 0.74, blue: 0.96))
                .cornerRadius(5)
                .overlay(
                    Text("Log In")
                        .font(Font.custom("Inter", size: 17).weight(.bold))
                        .foregroundColor(.white)
                )
                .padding(.horizontal, 16)
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
