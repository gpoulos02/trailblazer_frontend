//
//  AvailableRoutes.swift
//  TrailBlazer
//
//  Created by Sadie Smyth on 2024-11-19.
//

import SwiftUI

struct AvailableRoutesView: View {
    let availableRoutes: [String]

    var body: some View {
        VStack(spacing: 20) {
            Text("Available Routes")
                .font(Font.custom("Inter", size: 20).weight(.bold))
                .foregroundColor(.black)
                .padding()

            if availableRoutes.isEmpty {
                Text("No routes available")
                    .font(Font.custom("Inter", size: 16))
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ForEach(availableRoutes, id: \.self) { route in
                    Text(route)
                        .font(Font.custom("Inter", size: 16))
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
            }

            Spacer()
        }
        .padding()
        .navigationBarTitle("Routes", displayMode: .inline)
    }
}

struct AvailableRoutesView_Previews: PreviewProvider {
    static var previews: some View {
        AvailableRoutesView(availableRoutes: ["Route 1", "Route 2", "Route 3"])
    }
}
