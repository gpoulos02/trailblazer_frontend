import SwiftUI

struct FriendRequestsView: View {
    var userName: String
    @State private var searchText = ""
    @State private var searchResults: [[String: Any]] = [] // Use [[String: Any]] directly

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search for users...", text: $searchText, onCommit: searchUsers)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                List(searchResults, id: \._id) { user in // Use _id as identifier
                    if let username = user["username"] as? String, let userId = user["_id"] as? String {
                        HStack {
                            Text(username)
                            Spacer()
                            Button("Add Friend") {
                                sendFriendRequest(to: userId)
                            }
                            .buttonStyle(.bordered)
                        }
                    } else {
                        Text("Invalid search result")
                    }
                }

                NavigationLink(destination: PendingRequestsView()) {
                    Text("View Pending Friend Requests")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Friends")
        }
    }

    func searchUsers() {
        guard !searchText.isEmpty else { return }
        guard let encodedQuery = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let url = URL(string: "https://TrailBlazer33:5001/api/friends/search?query=\(encodedQuery)") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data { // Unwrap data here
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    DispatchQueue.main.async {
                        searchResults = json
                    }
                } else {
                    print("Decoding error: \(String(describing: error))")
                    if let string = String(data: data, encoding: .utf8) {
                        print("Response String: \(string)")
                    }
                }
            } else if let error = error {
                print("Network error: \(error)")
            }
        }.resume()
    }

    func sendFriendRequest(to userID: String) {
        guard let url = URL(string: "https://TrailBlazer33:5001/api/friends/send/\(userID)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                print("Send friend request status code: \(httpResponse.statusCode)")
            }
            if let error = error {
                print("Send friend request error: \(error)")
            }
        }.resume()
    }
}

struct PendingRequestsView: View {
    @State private var friendRequests: [String] = []
    
    var body: some View {
        List(friendRequests, id: \.self) { requestID in
            Text(requestID)
        }
        .onAppear(perform: fetchFriendRequests)
        .navigationTitle("Pending Requests")
    }
    
    func fetchFriendRequests() {
        guard let url = URL(string: "https://TrailBlazer33:5001/api/friends/requests") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data { // Unwrap data here!
                if let decodedResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String] {
                    DispatchQueue.main.async {
                        friendRequests = decodedResponse
                    }
                } else {
                    print("Decoding error: \(String(describing: error))")
                    if let string = String(data: data, encoding: .utf8) {
                        print("Response String: \(string)")
                    }
                }
            } else if let error = error {
                print("Network error: \(error)")
            }
        }.resume()
        
    }}

struct FriendRequestsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendRequestsView(userName: "John Doe")
    }
}

extension Dictionary where Key == String, Value == Any {
    var _id: String {
        return self["_id"] as? String ?? ""
    }
}
