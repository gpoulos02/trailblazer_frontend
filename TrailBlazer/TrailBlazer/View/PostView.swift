import SwiftUI

struct PostView: View {
    var post: Post
    
    @State private var username: String = "" // Store the fetched username
    @State private var routeName: String = ""
    @State private var sessionDetails: SessionData? // Store the session details for performance posts
    @State private var isLiked: Bool = false
    @State private var likeCount: Int = 0
    @State private var sessionDetailsMap: [String: SessionData] = [:]
    
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
                if let sessionDetails = sessionDetailsMap[post.postID ?? ""] {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Performance Metrics:")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        Text("Top Speed: \(sessionDetails.sessionData.topSpeed) km/h")
                            .font(.body)
                            .foregroundColor(.black)
                        
                        Text("Distance: \(sessionDetails.sessionData.distance) meters")
                            .font(.body)
                            .foregroundColor(.black)
                        
                        Text("Elevation Gain: \(sessionDetails.sessionData.elevationGain) meters")
                            .font(.body)
                            .foregroundColor(.black)
                        
                        Text("Duration: \(sessionDetails.sessionData.duration) seconds")
                            .font(.body)
                            .foregroundColor(.black)
                    }
                } else {
                    Text("Loading performance data...")
                        .font(.body)
                        .foregroundColor(.gray)
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
            
            // Reset sessionDetails before fetching new data
            if post.type == "performance" {
                self.sessionDetails = nil
            }
            
            if let sessionID = post.performance {
                fetchSessionDetails(sessionID: sessionID, postID: post.postID ?? "")
            }
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
    

    
    // Fetch session details for performance posts
    func fetchSessionDetails(sessionID: String, postID: String) {
            guard let url = URL(string: "https://TrailBlazer33:5001/api/metrics/session/\(sessionID)") else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            // Add the token (replace `yourTokenHere` with the actual token)
            if let token = UserDefaults.standard.string(forKey: "authToken") {
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    do {
                        let decoded = try JSONDecoder().decode(SessionData.self, from: data)
                        
                        // Store the session data for the specific postID in a dictionary
                        DispatchQueue.main.async {
                            self.sessionDetailsMap[postID] = decoded
                        }
                    } catch {
                        print("Error fetching session details:", error)
                    }
                }
            }.resume()
        }
    
    // Updated toggleLike function to handle the response correctly
    func toggleLike() {
            guard let postID = post.postID else { return }
            
            //print("Sending like request for post ID: \(postID)")
            
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
            
            print("Sending unlike request for post ID: \(postID)")
            
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




// Define the SessionData struct to represent session details
struct SessionData: Codable {
    var sessionID: String
    var runID: Int
    var sessionData: SessionMetrics
    var createdAt: String
}

struct SessionMetrics: Codable {
    var topSpeed: Double
    var distance: Double
    var elevationGain: Double
    var duration: Double
}

struct LikePostResponse: Codable {
    var message: String
    var post: Post? // The post object returned by the backend
}

