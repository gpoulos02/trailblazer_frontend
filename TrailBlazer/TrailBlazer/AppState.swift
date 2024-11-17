//
//  AppState.swift
//  TrailBlazer
//
//  Created by Sadie Smyth on 2024-11-17.
//

import Combine

class AppState: ObservableObject {
    @Published var currentUser: User? = nil
    @Published var isLoggedIn: Bool = false
}
