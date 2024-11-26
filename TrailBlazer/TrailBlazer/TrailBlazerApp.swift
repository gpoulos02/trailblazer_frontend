//
//  TrailBlazerApp.swift
//  TrailBlazer
//
//  Created by Sadie Smyth on 2024-11-12.
//

import SwiftUI

@main
struct TrailBlazerApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            SignUpView()
                
        }
    }
}



