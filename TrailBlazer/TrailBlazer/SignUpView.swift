//
//  SignUpView.swift
//  TrailBlazer
//
//  Created by Sadie Smyth on 2024-11-13.
//
import SwiftUI

struct SignUpView: View {
    var body: some View {
        
        VStack(spacing: 20) {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 314, height: 290)
                .background(
                    AsyncImage(url: URL(string: "https://via.placeholder.com/314x290"))
                )
                .padding(.top, 16)
            // First Name Field
            HStack(alignment: .top, spacing: 0) {
                Text("First Name")
                    .font(Font.custom("Inter", size: 17))
                    .lineSpacing(22)
                    .foregroundColor(.black)
                Spacer()
                Text("First Name")
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
            
            // E-Mail Field
            HStack(alignment: .top, spacing: 0) {
                Text("Last Name")
                    .font(Font.custom("Inter", size: 17))
                    .lineSpacing(22)
                    .foregroundColor(.black)
                Spacer()
                Text("Last Name")
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
            
            

            // E-Mail Field
            HStack(alignment: .top, spacing: 0) {
                Text("E-Mail")
                    .font(Font.custom("Inter", size: 17))
                    .lineSpacing(22)
                    .foregroundColor(.black)
                Spacer()
                Text("E-Mail Address")
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

            // Address Field
            HStack(alignment: .top, spacing: 0) {
                Text("Address")
                    .font(Font.custom("Inter", size: 17))
                    .lineSpacing(22)
                    .foregroundColor(.black)
                Spacer()
                Text("Home Address")
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

            // Phone Field
            HStack(alignment: .top, spacing: 0) {
                Text("Phone")
                    .font(Font.custom("Inter", size: 17))
                    .lineSpacing(22)
                    .foregroundColor(.black)
                Spacer()
                Text("Cell Phone Number")
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
            Text("You’ll receive a one-time pass code on this phone number to validate your account.")
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
                .overlay( Text("Next")
                .font(Font.custom("Inter", size: 17).weight(.bold))
                .foregroundColor(.white))
                .padding(.horizontal, 16)
            
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
