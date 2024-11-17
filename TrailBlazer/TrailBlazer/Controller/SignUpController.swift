//
//  SignUpController.swift
//  TrailBlazer
//
//  Created by Sadie Smyth on 2024-11-17.
//

class SignUpController {
    private let userController: UserController

    init(userController: UserController) {
        self.userController = userController
    }

    func signUp(firstName: String, lastName: String, email: String, username: String, password: String) -> Bool {
        return userController.register(firstName: firstName, lastName: lastName, email: email, username: username, password: password)
    }
}
