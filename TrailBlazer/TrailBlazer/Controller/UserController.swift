//
//  UserController.swift
//  TrailBlazer
//
//  Created by Sadie Smyth on 2024-11-17.
//

class UserController {
    private var users: [User] = []
    
    init() {
        // Create a default test account on initialization
        let testUser = User(firstName: "Team", lastName: "33", email: "team33@gmail.com", username: "Team33", password: "Team33")
        users.append(testUser)
    }

    func register(firstName: String, lastName: String, email: String, username: String, password: String) -> Bool {
        guard !users.contains(where: { $0.username == username || $0.email == email }) else {
            return false
        }
        let user = User(firstName: firstName, lastName: lastName, email: email, username: username, password: password)
        users.append(user)
        return true
        
        

    }

    func login(username: String, password: String) -> User? {
        return users.first { $0.username == username && $0.password == password }
    }
    
}
