import SwiftUI

class LogInController {
    private let appState: AppState
    private let userController: UserController

    init(appState: AppState, userController: UserController) {
        self.appState = appState
        self.userController = userController
    }

    func logIn(username: String, password: String) -> Bool {
        if let user = userController.login(username: username, password: password) {
            appState.currentUser = user
            appState.isLoggedIn = true
            return true
        }
        return false
    }
}
