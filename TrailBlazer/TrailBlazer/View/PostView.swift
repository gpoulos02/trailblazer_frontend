import SwiftUI

struct PostView: View {
    var post: Post
    
    @State private var username: String = "" // Store the fetched username
    @State private var routeName: String = ""
    @State private var sessionDetails: SessionData? // Store the session details for performance posts
    @State private var isLiked: Bool = false
    @State private var likeCount: Int = 0
    
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
            
            // Optional Image (smaller placeholder for now)
            Image(systemName: "photo") // Placeholder image for now
                .resizable()
                .scaledToFit()
                .frame(height: 150) // Smaller size
                .cornerRadius(10)
                .padding(.top, 10)
            
            // Content Based on Post Type
            if post.type == "text" {
                Text(post.textContent ?? "No content available")
                    .font(.body)
                    .foregroundColor(.black)
            } else if post.type == "performance" {
                // Display Performance Metrics
                if let sessionDetails = sessionDetails {
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
                    Text("Route Post:")
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    Text("Route Name: \(routeName.isEmpty ? "Loading..." : routeName)") // Display route name or "Loading..."
                        .font(.body)
                        .foregroundColor(.black)
                        .onAppear {
                            // Debugging: Print routeName when the view appears
                            print("Route Name onAppear: \(routeName)")
                        }

                }
            }
            
            // Divider
            Divider()
                .padding(.vertical, 10)
            
            // Bottom Buttons: Like and Comment
            HStack {
                Button(action: {
                    toggleLike()
                }) {
                    HStack {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(isLiked ? .red : .gray)
                        Text("\(likeCount)")
                            .foregroundColor(.black)
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
            if post.type == "route" {
                fetchRouteName()
            }
            fetchUsername()
            
            // Reset sessionDetails before fetching new data
            if post.type == "performance" {
                self.sessionDetails = nil
            }
            
            if let sessionID = post.performance {
                fetchSessionDetails(sessionID: sessionID)
            }
            toggleLike()
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
    
    // Fetch route name for route posts
    // Fetch route name for route posts
    func fetchRouteName() {
          // Debug to see which runID is being sent

        guard let routeID = post.route else {
            print("No route ID found.")
            return
        }
        print("Sending request for runID: \(routeID)")

        // Try to convert routeID to an integer
        if let routeIDInt = Int(routeID) {
            // If conversion is successful, construct the URL with the number
            let urlString = "https://TrailBlazer33:5001/api/routes/runNameByID?runID=\(routeIDInt)"
            print("Fetching route with URL: \(urlString)")  // Check if URL is correct

            guard let url = URL(string: urlString) else {
                print("Invalid URL")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"

            // Add the token (replace `yourTokenHere` with the actual token)
            if let token = UserDefaults.standard.string(forKey: "authToken") {
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }

            // Debug: Print the request being sent
            print("Request being sent to API:", request)

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("API Request Error: \(error.localizedDescription)") // Error on request
                } else {
                    if let data = data {
                        do {
                            // Debug: Log the response data for analysis
                            let jsonString = String(data: data, encoding: .utf8) ?? "Invalid JSON"
                            print("Response data received: \(jsonString)")

                            // Decode the JSON response
                            let responseJson = try JSONDecoder().decode([String: String].self, from: data)
                            if let fetchedRunName = responseJson["runName"] {
                                DispatchQueue.main.async {
                                    print("Fetched run name: \(fetchedRunName)") // Debug: Fetched run name
                                    self.routeName = fetchedRunName
                                }
                            } else {
                                print("No runName field in response JSON.")
                            }
                        } catch {
                            print("Error decoding run name:", error) // Error during JSON decoding
                        }
                    } else {
                        print("No data received from API.") // No data received from the API
                    }
                }
            }.resume()
        } else {
            print("Invalid routeID, could not convert to number.") // routeID conversion failed
        }
    }



    
    // Fetch session details for performance posts
    func fetchSessionDetails(sessionID: String) {
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
                    let jsonString = String(data: data, encoding: .utf8) ?? "Invalid JSON"
                    print("API Response: \(jsonString)")
                    
                    let decoded = try JSONDecoder().decode(SessionData.self, from: data)
                    DispatchQueue.main.async {
                        self.sessionDetails = decoded
                    }
                } catch {
                    print("Error fetching session details:", error)
                }
            }
        }.resume()
    }
    
    func toggleLike() {
        guard let url = URL(string: "https://TrailBlazer33:5001/api/posts/\(post.id)/like") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Add the token (replace `yourTokenHere` with the actual token)
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        print("Sending like request for post ID: \(post.id) with user token")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let responseJson = try JSONDecoder().decode([String: String].self, from: data)
                    DispatchQueue.main.async {
                        if responseJson["message"] == "Post liked" {
                            print("Post liked successfully. Updating UI.")
                            isLiked = true
                            likeCount += 1
                        } else if responseJson["message"] == "Already liked this post" {
                            print("Post already liked. Unliking the post.")
                            // 🚀 Call the UNLIKE function if already liked
                            unlikePost()
                        } else {
                            print("Unexpected response:", responseJson)
                        }
                    }
                } catch {
                    print("Error decoding response:", error)
                }
            } else if let error = error {
                print("Error making request:", error)
            }
        }.resume()
    }

    
    // New function to unlike a post
    func unlikePost() {
        guard let url = URL(string: "https://TrailBlazer33:5001/api/posts/\(post.id)/unlike") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let responseJson = try JSONDecoder().decode([String: String].self, from: data)
                    DispatchQueue.main.async {
                        if responseJson["message"] == "Post unliked" {
                            isLiked = false
                            likeCount -= 1
                        }
                    }
                } catch {
                    print("Error unliking post:", error)
                }
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
