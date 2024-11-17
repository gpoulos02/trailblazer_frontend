//
//  UserModel.swift
//  TrailBlazer
//
//  Created by Sadie Smyth on 2024-11-17.
//

import Foundation

struct User: Identifiable {
    let id: UUID
    let firstName: String
    let lastName: String
    let email: String
    let username: String
    let password: String

    init(firstName: String, lastName: String, email: String, username: String, password: String) {
        self.id = UUID() // Generate a unique ID for each user
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.username = username
        self.password = password
    }
}
