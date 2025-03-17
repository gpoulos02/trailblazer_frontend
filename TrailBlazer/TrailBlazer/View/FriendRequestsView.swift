import SwiftUI

struct FriendRequestsView: View {
    var userName: String
    @State private var searchText = ""
    @State private var friends: [[String: Any]] = []
    @State private var searchResults: [[String: Any]] = []
    @State private var isLoading = false
    @State private var requestSentUserId: String?
    
    @State private var showUnfriendAlert = false
    @State private var userToUnfriend: (username: String, userId: String)?
    
    @State private var friendRequestSentMessage: String?

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Search bar with clear button
                HStack {
                    TextField("Search for users...", text: $searchText)
                                        .padding(.leading, 30) // Space for the magnifying glass
                                        .frame(height: 45)
                                        .padding(.horizontal, 15) // Adjust the horizontal padding
                                        .background(Color(.systemGray6))
                                        .cornerRadius(12)
                                        .overlay(
                                            HStack {
                                                Image(systemName: "magnifyingglass")
                                                    .foregroundColor(.gray)
                                                    .padding(.leading, 8) // Adjust the padding to avoid overlap
                                                Spacer()
                                            }
                                        )
                                        .padding(.horizontal, 10)
                    
                    Button(action: searchUsers) {
                        Text("Search")
                            .fontWeight(.semibold)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 10)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .padding(.trailing, 10)
                }
                .padding(.horizontal)
                
                if isLoading {
                    ProgressView("Searching...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .padding()
                }

                
                // Friends List
                if !friends.isEmpty {
                    Text("Your Friends")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    List(friends, id: \.userID) { friend in
                        if let username = friend["username"] as? String, let userId = friend["userID"] as? String {
                            HStack {
                                Text(username)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Spacer()
                                Button(action: {
                                    self.userToUnfriend = (username, userId)
                                    showUnfriendAlert = true
                                }) {
                                    Image(systemName: "person.crop.circle.badge.xmark")
                                        .foregroundColor(.red)
                                        .font(.title2)
                                }
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                if let message = friendRequestSentMessage {
                                Text(message)
                                    .foregroundColor(.green)
                                    .fontWeight(.semibold)
                                    .padding()
                            }

                // Search Results List
                if !searchResults.isEmpty {
                    Text("Search Results")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    List(searchResults, id: \.userID) { user in
                           if let username = user["username"] as? String, let userId = user["userID"] as? String {
                               HStack {
                                   Text(username)
                                       .font(.headline)
                                       .foregroundColor(.primary)
                                   Spacer()
                                   
                                   // Only show the "add friend" button if the user is not already a friend
                                   if let isFriend = user["isFriend"] as? Int, isFriend == 0 {
                                       Button(action: {
                                           sendFriendRequest(to: username)
                                       }) {
                                           Image(systemName: "plus.circle")
                                               .foregroundColor(.blue)
                                               .font(.title2)
                                       }
                                   }
                               }
                               .padding(.vertical, 5)
                           }
                       }
                       .listStyle(PlainListStyle())

                }

                // Navigate to Pending Requests
                NavigationLink(destination: PendingRequestsView()) {
                    Text("Friend Requests")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)
            }
            .navigationTitle("Friends")
            .padding(.top, 20)
            .onAppear(perform: fetchFriends)
            .alert(isPresented: $showUnfriendAlert) {
                Alert(
                    title: Text("Unfriend \(userToUnfriend?.username ?? "")?"),
                    message: Text("Are you sure you want to unfriend \(userToUnfriend?.username ?? "")?"),
                    primaryButton: .cancel(),
                    secondaryButton: .destructive(Text("Unfriend")) {
                        if let userId = userToUnfriend?.userId {
                            unfriendUser(with: userId)
                        }
                    }
                )
            }
        }
    }

    func fetchFriends() {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            print("No token found")
            return
        }

        guard let url = URL(string: "https://TrailBlazer33:5001/api/friends/friends") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        isLoading = true

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
            }
            
            if let error = error {
                print("Error fetching friends: \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let friends = jsonResponse["friends"] as? [[String: Any]] {
                        DispatchQueue.main.async {
                            self.friends = friends
                        }
                    }
                } catch {
                    print("Error decoding response: \(error.localizedDescription)")
                }
            }
        }.resume()
    }

    func unfriendUser(with userID: String) {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            print("No token found")
            return
        }

        guard let url = URL(string: "https://TrailBlazer33:5001/api/friends/unfriend/\(userID)") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error unfriending user: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    // Remove the friend from the list
                    self.friends.removeAll { $0["userID"] as? String == userID }
                }
                print("User unfriended successfully")
            }
        }.resume()
    }

    func searchUsers() {
        guard !searchText.isEmpty else { return }
        isLoading = true

        guard let encodedQuery = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://TrailBlazer33:5001/api/friends/search?query=\(encodedQuery)") else {
            print("Invalid URL")
            return
        }

        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            print("No token found")
            isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
            }

            if let error = error {
                print("Search error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received from server")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print("Raw JSON response: \(json)")

                if let array = json as? [[String: Any]] {
                    DispatchQueue.main.async {
                        searchResults = array.map { result in
                            var user = result
                            user["userID"] = user["_id"]  // Map `_id` to `userID`
                            return user
                        }
                    }
                } else if let object = json as? [String: Any] {
                    DispatchQueue.main.async {
                        searchResults = [object] // Wrap single object in an array
                    }
                } else {
                    print("Unexpected JSON format: \(json)")
                }
            } catch {
                print("JSON decoding error: \(error.localizedDescription)")
            }
        }.resume()
    }



    func sendFriendRequest(to username: String) {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            print("No token found")
            return
        }

        // Convert username to userID
        guard let url = URL(string: "https://TrailBlazer33:5001/api/friends/getUserID?username=\(username)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching userID: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data {
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let userID = jsonResponse["userID"] as? String {
                        // Send the friend request
                        sendRequest(to: userID)
                    }
                } catch {
                    print("Error parsing userID response: \(error.localizedDescription)")
                }
            }
        }.resume()
    }

    func sendRequest(to userID: String) {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            print("No token found")
            return
        }

        guard let url = URL(string: "https://TrailBlazer33:5001/api/friends/send/\(userID)") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending friend request: \(error.localizedDescription)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                friendRequestSentMessage = "Friend request has been sent."
                print("Friend request sent successfully")
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        friendRequestSentMessage = nil
                                    }
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 400 {
                friendRequestSentMessage = "Friend request is pending."
                print("Friend request already sent")
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        friendRequestSentMessage = nil
                                    }
            }
        }.resume()
    }
}



struct PendingRequestsView: View {
    @State private var friendRequests: [[String: Any]] = []  // Make this mutable

    var body: some View {
        if friendRequests.isEmpty {
            Text("No friend requests.")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding()
        }
        List(friendRequests, id: \.userID) { request in  // Use _id as the identifier
                    if let username = request["username"] as? String, let userID = request["userID"] as? String {
                        HStack {
                            Text(username)
                                .font(.headline)
                            
                            Spacer()
                            
                            // Reject Button (X)
                            Button(action: {
                                                    rejectFriendRequest(for: userID)
                                                }) {
                                                    Image(systemName: "x.circle.fill")
                                                        .foregroundColor(.red)
                                                        .font(.title2)
                                                }
                                                .buttonStyle(PlainButtonStyle())

                                                // Accept Button (checkmark)
                                                Button(action: {
                                                    acceptFriendRequest(for: userID)
                                                }) {
                                                    Image(systemName: "checkmark.circle.fill")
                                                        .foregroundColor(.green)
                                                        .font(.title2)
                                                }
                                                .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.vertical, 5)
                    }
        }
        .onAppear(perform: fetchFriendRequests)
        .navigationTitle("Friend Requests")
    }

    func fetchFriendRequests() {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            print("No token found")
            return
        }

        guard let url = URL(string: "https://TrailBlazer33:5001/api/friends/requests") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Fetching pending requests failed: \(error.localizedDescription)")
                return
            }

            if let data = data {
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let friendRequests = jsonResponse["friendRequests"] as? [[String: Any]] {
                        DispatchQueue.main.async {
                            print("Friend requests fetched: \(friendRequests)") // Debugging line
                            self.friendRequests = friendRequests
                        }
                    }
                } catch {
                    print("Error decoding response: \(error.localizedDescription)")
                }
            } else {
                print("No data received from server.")
            }
        }.resume()
    }
    
    func acceptFriendRequest(for userID: String) {
            guard let token = UserDefaults.standard.string(forKey: "authToken") else {
                print("No token found")
                return
            }
            
            guard let url = URL(string: "https://TrailBlazer33:5001/api/friends/accept/\(userID)") else {
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error accepting friend request: \(error.localizedDescription)")
                    return
                }

                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        // Remove accepted user from the list
                        self.friendRequests.removeAll { $0["userID"] as? String == userID }
                    }
                    print("Friend request accepted")
                }
            }.resume()
        }

        func rejectFriendRequest(for userID: String) {
            guard let token = UserDefaults.standard.string(forKey: "authToken") else {
                print("No token found")
                return
            }
            
            guard let url = URL(string: "https://TrailBlazer33:5001/api/friends/reject/\(userID)") else {
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error rejecting friend request: \(error.localizedDescription)")
                    return
                }

                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        // Remove rejected user from the list
                        self.friendRequests.removeAll { $0["userID"] as? String == userID }
                    }
                    print("Friend request rejected")
                }
            }.resume()
        }
}




struct FriendRequestsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendRequestsView(userName: "John Doe")
    }
}

extension Dictionary where Key == String, Value == Any {
    var userID: String {
        return self["userID"] as? String ?? ""
    }
}
