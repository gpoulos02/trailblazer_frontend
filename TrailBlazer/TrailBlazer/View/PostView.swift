import SwiftUI

struct PostView: View {
    var post: Post
    @Binding var posts: [Post]
    
    @State private var username: String = "" // Store the fetched username
    @State private var routeName: String = ""
    @State private var role = ""
    
    @State private var isLiked: Bool = false
    @State private var likeCount: Int = 0
    @State private var currentUsername: String = ""
    @State private var showDeleteButton: Bool = false
    
    
        
    
    // DateFormatter to format the ISO date string
    private var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // Assuming the API uses this format
        if let date = dateFormatter.date(from: post.createdAt) {
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            return dateFormatter.string(from: date)
        }
        return post.createdAt // Fallback to raw date string if formatting fails
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Post Header: Username and Date
            HStack {
                // Display username (fetched from the API)
                Text(username.isEmpty ? "Loading..." : username)
                    .font(.headline)
                    .fontWeight(.bold)
                //print("Current User ID: \(currentUserID)")
                
                Spacer()
                
                // Post Creation Date (formatted)
                Text(formattedDate) // Display formatted date
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            // Post Title
            Text(post.title)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.black)
            
            
            // Content Based on Post Type
            if post.type == "text" {
                Text(post.textContent ?? "No content available")
                    .font(.body)
                    .foregroundColor(.black)
            } else if post.type == "performance" {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Speed: \(post.topSpeed ?? 0.0)")  // Provide a default value of 0.0 if nil
                        .font(.body)
                        .foregroundColor(.black)
                    Text("Distance: \(post.distance ?? 0.0)")  // Provide a default value of 0.0 if nil
                        .font(.body)
                        .foregroundColor(.black)
                    Text("Elevation Gain: \(post.elevationGain ?? 0.0)")  // Provide a default value of 0.0 if nil
                        .font(.body)
                        .foregroundColor(.black)
                    Text("Duration: \(post.duration ?? 0.0)")  // Provide a default value of 0.0 if nil
                        .font(.body)
                        .foregroundColor(.black)
                }
                

            } else if post.type == "route" {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Run: \(routeName.isEmpty ? "Loading..." : routeName)")
                        .font(.body)
                        .foregroundColor(.black)
                }
            }
            
            // Divider
            Divider()
                .padding(.vertical, 10)
            
            // Bottom Buttons: Like and Comment
            HStack {
                
                Text("\(likeCount)")  // Display the like count
                    .foregroundColor(.black)
                
                Button(action: {
                    if isLiked {
                        unlikePost()
                    } else {
                        toggleLike()
                    }
                }) {
                    HStack {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(isLiked ? .red : .gray)
                    }
                    .padding()
                }
                
                Spacer()
                if shouldShowDeleteButton() {  // Use shouldShowDeleteButton() to check the condition
                    Button(action: {
                        deletePost()
                    }) {
                        Image(systemName: "trash.fill")
                            .foregroundColor(.red)
                    }
                }

                
                Button(action: {
                    // Handle comment action
                    print("Commented on post")
                }) {
                    HStack {
                        Image(systemName: "bubble.right.fill")
                            .foregroundColor(.blue)
                        Text("Comment")
                            .foregroundColor(.black)
                    }
                    .padding()
                }
            }
            .font(.subheadline)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
        .border(Color.gray.opacity(0.2), width: 1)
        .onAppear {
            fetchUsername()
            fetchLikeCount()
            fetchUserRole()
            
        
            if let routeID = post.routeID {
                fetchRouteName(routeID: routeID)
            }
        }
    }
    

    // Fetch username from the API based on userID
    func fetchUsername() {
        guard let url = URL(string: "https://TrailBlazer33:5001/api/friends/getUsername?userID=\(post.userID)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Add the token (replace `yourTokenHere` with the actual token)
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    // Decode the JSON response which contains the username
                    let responseJson = try JSONDecoder().decode([String: String].self, from: data)
                    if let fetchedUsername = responseJson["username"] {
                        DispatchQueue.main.async {
                            self.username = fetchedUsername

                                                }
                                            }
                } catch {
                    print("Error decoding username:", error)
                }
            }
        }.resume()
    }
    func getUserIDFromToken() -> String? {
            guard let token = UserDefaults.standard.string(forKey: "authToken") else {
                print("Auth token is missing")
                return nil
            }
            
            let parts = token.split(separator: ".")
            guard parts.count == 3 else {
                print("Invalid token format")
                return nil
            }
            
            let base64String = String(parts[1])
            let paddedBase64String = base64String.padding(toLength: (base64String.count + 3) / 4 * 4, withPad: "=", startingAt: 0)
            
            guard let decodedData = Data(base64Encoded: paddedBase64String, options: .ignoreUnknownCharacters) else {
                print("Failed to decode token payload")
                return nil
            }
            
            do {
                // Decode the JSON payload
                let json = try JSONSerialization.jsonObject(with: decodedData, options: []) as? [String: Any]
                return json?["userID"] as? String
                
            } catch {
                print("Error decoding token payload:", error)
                return nil
            }
        }
    
    func shouldShowDeleteButton() -> Bool {
            guard let userIDFromToken = getUserIDFromToken() else {
                return false
            }
            
            return post.userID == userIDFromToken || role == "admin"
            
        }
    
    func fetchRouteName(routeID: String) {
        guard let url = URL(string: "https://TrailBlazer33:5001/api/routes/runNamebyID?runID=\(routeID)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Add the token for authentication
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let responseJson = try JSONDecoder().decode([String: String].self, from: data)
                    if let fetchedRunName = responseJson["runName"] {
                        DispatchQueue.main.async {
                            self.routeName = fetchedRunName
                        }
                    }
                } catch {
                    print("Error fetching route name:", error)
                }
            }
        }.resume()
    }
    

    func deletePost() {
            guard let postID = post.postID else {return}
            guard let url = URL(string: "https://TrailBlazer33:5001/api/posts/delete/\(postID)") else {return}
            
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            
            if let token = UserDefaults.standard.string(forKey: "authToken") {
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            } else {
                print("Auth token is missing")
                return
            }
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error making request:", error)
                    return
                }
                guard let data = data else {
                    print("No data received from request")
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP Status Code:", httpResponse.statusCode)
                }

                let responseString = String(data: data, encoding: .utf8) ?? "Empty response"
                //print("Raw Response:", responseString)

                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    let message = jsonResponse?["message"] as? String ?? "Unknown response"
                    print("Server Message:", message)
                    
                    // After deletion, remove the post from the list in the parent view
                    DispatchQueue.main.async {
                        if let index = posts.firstIndex(where: { $0.postID == postID }) {
                            posts.remove(at: index)
                        }
                    }
                } catch {
                    print("Error decoding response:", error)
                }

            }.resume()
        }
    
    func fetchUserRole() {
//        guard let userIDFromToken = getUserIDFromToken() else {
//            return false
//        }
        guard let token = UserDefaults.standard.string(forKey: "authToken"),
              let url = URL(string: "https://TrailBlazer33:5001/api/admin/userTypeByID") else {
            print("Invalid URL or missing token")
            return
        }

        print("Fetching user role from:", url)

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching user role:", error.localizedDescription)
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code:", httpResponse.statusCode)
            }

            do {
                let roleResponse = try JSONDecoder().decode(RoleResponse.self, from: data)
                DispatchQueue.main.async {
                    self.role = roleResponse.role
                    print("User role fetched successfully:", self.role)
                }
            } catch {
                print("Failed to decode user role:", error.localizedDescription)
                if let dataString = String(data: data, encoding: .utf8) {
                    print("📥 Received response:", dataString)
                }
            }
        }.resume()
    }
    
    
    
    // Updated toggleLike function to handle the response correctly
    func toggleLike() {
            guard let postID = post.postID else { return }
            
            //print("Sending like request for post ID: \(postID)")
            //print("current user:  \(currentUserID)")
            
            guard let url = URL(string: "https://TrailBlazer33:5001/api/posts/\(postID)/like") else {
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // Add the token for authentication
            if let token = UserDefaults.standard.string(forKey: "authToken") {
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            } else {
                print("Auth token is missing")
                return
            }
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error making request:", error)
                    return
                }
                
                guard let data = data else {
                    print("No data received from request")
                    return
                }
                
                do {
                    if let responseJson = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let likesArray = responseJson["likes"] as? [String] { // Extract array
                            let newLikeCount = likesArray.count // Count elements in array
                            
                            DispatchQueue.main.async {
                                self.isLiked.toggle()
                                self.likeCount = newLikeCount
                                //likeCount = likeCount + 1// Update UI with backend count
                                //fetchLikeCount()
                            }
                        }
                    }
                } catch {
                    print("Error decoding response:", error)
                }
                DispatchQueue.main.async {
                    isLiked = true
                    
                    self.fetchLikeCount()
                }
            }.resume()
        }
    
    func fetchLikeCount() {
            guard let postID = post.postID else { return }
            
            //print("Fetching like count for post ID: \(postID)")  // Debugging
            
            guard let url = URL(string: "https://TrailBlazer33:5001/api/posts/\(postID)/getLikeCount") else {
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            // Add the token for authentication
            if let token = UserDefaults.standard.string(forKey: "authToken") {
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error fetching post:", error)
                    return
                }
                
                guard let data = data else {
                    print("No data received from request")
                    return
                }
                
                do {
                    // Debugging: Print raw response data
                    let rawResponseString = String(data: data, encoding: .utf8) ?? "Invalid response"
                    //print("Raw response data: \(rawResponseString)")
                    
                    // Decode the response assuming likeCount is a simple key
                    if let responseJson = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let likeCount = responseJson["likeCount"] as? Int {
                            DispatchQueue.main.async {
                                self.likeCount = likeCount  // Set the like count
                                //print("Fetched like count: \(self.likeCount)")  // Debugging
                            }
                        } else {
                            print("No 'likeCount' key found in response.")
                        }
                    } else {
                        print("Invalid JSON structure in response.")
                    }
                } catch {
                    print("Error decoding response:", error)
                }
            }.resume()
        }




    
    // New function to unlike a post
    func unlikePost() {
            guard let postID = post.postID else { return }
            
            //print("Sending unlike request for post ID: \(postID)")
            
            guard let url = URL(string: "https://TrailBlazer33:5001/api/posts/\(postID)/unlike") else {
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // Add the token for authentication
            if let token = UserDefaults.standard.string(forKey: "authToken") {
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error making request:", error)
                    return
                }
                
                guard let data = data else {
                    print("No data received from request")
                    return
                }
                
                do {
                    if let responseJson = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let likesArray = responseJson["likes"] as? [String] { // Extract array
                            let newLikeCount = likesArray.count // Count elements in array
                            
                            DispatchQueue.main.async {
                                self.isLiked.toggle()  // Toggle the like state
                                self.likeCount = newLikeCount // Update UI with backend count
                            }
                        }
                    }
                } catch {
                    print("Error decoding response:", error)
                }
                DispatchQueue.main.async {
                    self.fetchLikeCount()
                    isLiked = false
                }
            }.resume()
        }
    }





struct LikePostResponse: Codable {
    var message: String
    var post: Post? // The post object returned by the backend
}

