import SwiftUI

struct FriendRequestsView: View {
    var userName: String // Accepts the logged-in user's name as a parameter

    var body: some View {
        VStack {
            Text("Friend Requests for \(userName)")
                .font(.title)
                .padding()

            // Add more UI elements to represent friend requests here
        }
    }
}

struct FriendRequestsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendRequestsView(userName: "John Doe")
    }
}
