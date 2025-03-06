//
//  TrailBlazerApp.swift
//  TrailBlazer
//
//  Created by Sadie Smyth on 2024-11-12.
//

import SwiftUI
import Firebase

@main
struct TrailBlazerApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            LandingView()
        }
    }
}



