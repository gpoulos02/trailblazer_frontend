//
//  ChangePassword.swift
//  TrailBlazer
//
//  Created by Sadie Smyth on 2024-11-13.
//
import SwiftUI

struct ChangePasswordView: View {
    var body: some View {
        
        VStack(spacing: 20) {
            // Image Placeholder
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 314, height: 290)
                .background(
                    AsyncImage(url: URL(string: "https://via.placeholder.com/314x290"))
                )
                .padding(.top, 16)
            
            // New Password Field
            HStack(alignment: .top, spacing: 0) {
                Text("Password")
                    .font(Font.custom("Inter", size: 17))
                    .lineSpacing(22)
                    .foregroundColor(.black)
                Spacer()
                Text("New Password")
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
            
            // Confirm Password Field
            HStack(alignment: .top, spacing: 0) {
                Text("Re-enter Password")
                    .font(Font.custom("Inter", size: 17))
                    .lineSpacing(22)
                    .foregroundColor(.black)
                Spacer()
                Text("Confirm Password")
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
            
            // Information Text
            Text("Please enter and confirm your new password to proceed.")
                .font(Font.custom("Inter", size: 14))
                .foregroundColor(.black)
                .padding(.horizontal, 20)
                .multilineTextAlignment(.center)
            // Information Text
            Text("By clicking sign up, you agree to the TrailBlazer terms and conditions and privacy policy ")
                .font(Font.custom("Inter", size: 12))
                .foregroundColor(.black)
                .padding(.horizontal, 20)
                .multilineTextAlignment(.center)
            
            // Submit Button
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 287, height: 50)
                .background(Color(red: 0.55, green: 0.74, blue: 0.96))
                .cornerRadius(5)
                .overlay(
                    Text("Next")
                        .font(Font.custom("Inter", size: 17).weight(.bold))
                        .foregroundColor(.white)
                )
                .padding(.horizontal, 16)
            
            Spacer()
        }
        .padding(.top, 30)
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
    }
}


