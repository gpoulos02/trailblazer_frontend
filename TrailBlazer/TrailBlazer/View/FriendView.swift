import SwiftUI

// Define the Post struct to represent each post
struct Post: Identifiable, Codable {
    var id: String { postID ?? "" }
    var postID: String?
    var userID: String
    var type: String
    var routeID: String?
    var title: String
    var textContent: String?
    var performance: String?
    var route: String?
    var createdAt: String
    var likes: [String]


    
    struct Comment: Codable {
        var user: String
        var content: String
        var createdAt: String
    }
    
    var comments: [Comment] = []
    
    // Flattened session data
    var sessionID: String?
    var topSpeed: Double?
    var distance: Double?
    var elevationGain: Double?
    var duration: Double?
    
    enum CodingKeys: String, CodingKey {
        case postID
        case userID
        case type
        case routeID
        case title
        case textContent
        case performance
        case route
        case createdAt
        case likes
        case comments
        case sessionID
        case topSpeed
        case distance
        case elevationGain
        case duration
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        postID = try container.decodeIfPresent(String.self, forKey: .postID)
        userID = try container.decode(String.self, forKey: .userID)
        type = try container.decode(String.self, forKey: .type)
        title = try container.decode(String.self, forKey: .title)
        textContent = try container.decodeIfPresent(String.self, forKey: .textContent)
        performance = try container.decodeIfPresent(String.self, forKey: .performance)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        likes = try container.decode([String].self, forKey: .likes)
        if let decodedComments = try? container.decode([Comment].self, forKey: .comments) {
            comments = decodedComments
        } else {
            comments = []  // Default to an empty array if comments are not available
        }
        
        // Decode sessionMetrics if it exists
        sessionID = try container.decodeIfPresent(String.self, forKey: .sessionID)
        topSpeed = try container.decodeIfPresent(Double.self, forKey: .topSpeed)
        distance = try container.decodeIfPresent(Double.self, forKey: .distance)
        elevationGain = try container.decodeIfPresent(Double.self, forKey: .elevationGain)
        duration = try container.decodeIfPresent(Double.self, forKey: .duration)
        // Decode routeID and route
        routeID = try container.decodeIfPresent(String.self, forKey: .routeID)
        if let routeString = try? container.decode(String.self, forKey: .route) {
            route = routeString
        } else if let routeInt = try? container.decode(Int.self, forKey: .route) {
            route = String(routeInt)
        } else {
            route = nil
        }
    }
}

struct NotificationItem: Identifiable, Codable {
    let id: String
    let user: String
    let type: String
    let message: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case user
        case type
        case message
        case createdAt
    }
}




struct FriendView: View {
    var userName: String
    
    @State private var navigateToFriendRequests = false
    @State private var currentTab: Tab = .friends
    @State private var showNewPostSheet = false
    @State private var posts: [Post] = [] // Post objects
    @State private var newPostTitle: String = ""
    @State private var newPostContent: String = ""
    @State private var hasPendingRequests = false
    @State private var pendingRequestsCount: Int = 0
    @State private var notifications: [NotificationItem] = []
    
    @State private var showInactivityAlert = false
    
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                // Top bar with logo and add friend button
                HStack {
                    Image("TextLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                        .padding(.leading, 20)
                    
                    Spacer()
                    
                    Button(action: {
                        navigateToFriendRequests = true
                    }) {
                        ZStack {
                            Image("AddFriend")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 40)
                                .padding(.trailing, 20)
                            
                            if hasPendingRequests {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 12, height: 12)
                                    .overlay(
                                        Text(pendingRequestsCount > 9 ? "9+" : "\(pendingRequestsCount)")
                                            .font(.system(size: 12))
                                            .foregroundColor(.white)
                                    )
                                    .offset(x: 12, y: -12) // Position the dot at the top-right corner
                            }
                        }
                    }
                }
                .padding(.top, 20)
                .background(
                    NavigationLink("", destination: FriendRequestsView(userName: userName), isActive: $navigateToFriendRequests)
                )
                                
                // Scrollable Friends Section
                HStack(spacing: 10) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            Text("Your Feed")
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                        .padding(.leading, 10)
                    }
                }
                .padding(.horizontal, 20)
                
                // Posts Section (Below Location Section)
                ScrollView {
                    VStack(spacing: 10) {
                        // Show Inactivity Alerts First
                        if let firstNotification = notifications.first {
                            ZStack(alignment: .topLeading) {
                                // Notification Background
                                VStack(alignment: .leading) {
                                    Text(firstNotification.message)
                                        .font(.body)
                                        .padding(.top, 10) // Creates space for the close button inside
                                        .padding(.horizontal, 20)
                                        .padding(.bottom, 10)
                                }
                                .frame(maxWidth: .infinity) // Ensures same width as post section
                                .background(Color.yellow.opacity(0.3))
                                .cornerRadius(8)
                                .padding(.horizontal) // Matches post section padding

                                // Close Button
                                Button(action: {
                                    removeNotification()
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .resizable()
                                        .frame(width: 18, height: 18)
                                        .foregroundColor(.gray)
                                        .background(Color.white)
                                        .clipShape(Circle())
                                        .shadow(radius: 1)
                                }
                                .offset(x: 20, y: 13) // Moves it fully inside the box
                            }
                            .padding(.horizontal) // Matches post section
                            .transition(.opacity) // Fade-out effect when removed
                        }

                        ForEach(posts) { post in
                            PostView(post: post, posts: $posts)
                        }
                    }
                    .padding(.horizontal)
                }

                
                // Bottom Navigation Bar
                HStack {
                    TabBarItem(
                        tab: .home,
                        currentTab: $currentTab,
                        destination: { HomeView(userName: userName) },
                        imageName: "house.fill",
                        label: "Home"
                    )
                    
                    TabBarItem(
                        tab: .friends,
                        currentTab: $currentTab,
                        destination: { FriendView(userName: userName) },
                        imageName: "person.2.fill",
                        label: "Friends"
                    )
                    
                    TabBarItem(
                        tab: .map,
                        currentTab: $currentTab,
                        destination: { RouteLandingView(userName: userName) },
                        imageName: "map.fill",
                        label: "Map"
                    )
                    
                    TabBarItem(
                        tab: .metrics,
                        currentTab: $currentTab,
                        destination: { PerformanceMetricsView(userName: userName) },
                        imageName: "chart.bar.fill",
                        label: "Metrics"
                    )
                    
                    TabBarItem(
                        tab: .profile,
                        currentTab: $currentTab,
                        destination: { ProfileView(userName: userName) },
                        imageName: "person.fill",
                        label: "Profile"
                    )
                }
                .padding()
                .background(Color.white)
                .shadow(radius: 5)
            }
            
            // Floating Button at Bottom Right Corner
            NavigationLink(destination: NewPostView(), isActive: $showNewPostSheet) {
                Button(action: {
                    showNewPostSheet = true
                }) {
                    Image("newPost")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                .frame(width: 40, height: 40)
                .padding(.bottom, 40)
                .padding(.trailing, 25)
            }
            .zIndex(1) // Appears above other elements
//            .padding(.bottom, 40) // Add padding to avoid overlap with the bottom navigation bar
//            .padding(.trailing, 20) // Controls distance from the right side
            .position(x: UIScreen.main.bounds.width - 40, y: UIScreen.main.bounds.height - 230) // Position the button at the bottom-right
        }
        .onAppear {
            fetchInactivityAlerts()
            fetchAllPosts()
            fetchFriendsPosts()
            checkPendingRequests()
            fetchAllPostsIfAdmin()
            scheduleNotificationRemoval()
        }
    }
    
    private func markNotificationAsDeleted(notificationID: String) {
        var dismissedNotifications = UserDefaults.standard.array(forKey: "dismissedNotifications") as? [String] ?? []
        dismissedNotifications.append(notificationID)
        UserDefaults.standard.set(dismissedNotifications, forKey: "dismissedNotifications")
    }

    // Remove notification after 20 seconds
    private func scheduleNotificationRemoval() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
            removeNotification()
        }
    }
    
    private func removeNotification() {
        guard let firstNotification = notifications.first else { return }
        
        withAnimation {
            markNotificationAsDeleted(notificationID: firstNotification.id) // Store in UserDefaults
            notifications = Array(notifications.dropFirst()) // Remove from UI
        }
    }

    func fetchInactivityAlerts() {
        guard let token = UserDefaults.standard.string(forKey: "authToken"),
              let url = URL(string: "https://TrailBlazer33:5001/api/notifications/inactivity-alerts") else {
            print("Invalid URL or missing token")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching inactivity alerts:", error.localizedDescription)
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let fetchedNotifications = try JSONDecoder().decode([NotificationItem].self, from: data)
                let dismissedNotifications = UserDefaults.standard.array(forKey: "dismissedNotifications") as? [String] ?? []

                DispatchQueue.main.async {
                    // Filter out notifications that have been dismissed
                    self.notifications = fetchedNotifications.filter { !dismissedNotifications.contains($0.id) }
                    
                    // Schedule auto-removal for non-dismissed notifications
                    if !self.notifications.isEmpty {
                        self.scheduleNotificationRemoval()
                    }
                }
            } catch {
                print("Failed to decode inactivity alerts:", error.localizedDescription)
            }
        }.resume()
    }

    struct FriendsPostsResponse: Codable {
        var posts: [Post] // Array of Post objects
    }
    
    func fetchFriendsPosts() {
        guard let url = URL(string: "https://TrailBlazer33:5001/api/posts/friends") else {
            print("Invalid URL for fetching friends' posts")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("No token found for friends' posts")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching friends' posts:", error)
                return
            }
            
            guard let data = data else {
                //print("No data received for friends' posts")
                return
            }
            
            
            do {
                let decodedResponse = try JSONDecoder().decode([Post].self, from: data)
                
                DispatchQueue.main.async {
                    self.posts.append(contentsOf: decodedResponse) // Append instead of replacing
                    self.posts.sort { $0.createdAt > $1.createdAt } // Sort posts by newest first
                }
            } catch {
                print("Error decoding friends' posts:", error)
            }
        }.resume()
    }
        
    // This function is responsible for submitting the post
    func submitPost() {
        guard !newPostContent.isEmpty else {
            print("Post content is required.")
            return
        }
        
        guard let url = URL(string: "https://TrailBlazer33:5001/api/posts/text") else {
            print("DEBUG: Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Create the post data
        let postData = [
            "title": newPostTitle,
            "textContent": newPostContent
        ]
        
        // Add the authorization token if available
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Set the request body
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: postData, options: [])
            request.httpBody = jsonData
        } catch {
            print("DEBUG: Failed to create new post JSON:", error)
            return
        }
        
        // Send the request to create the post
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("DEBUG: Error posting new post:", error)
                    return
                }
                
                if let data = data {
                    // Print the raw JSON for debugging
                    if let jsonString = String(data: data, encoding: .utf8) {
                        
                    }
                }
                
                
                fetchAllPosts()
            }
        }.resume()
    }
    
    func fetchAllPosts() {
        guard let url = URL(string: "https://TrailBlazer33:5001/api/posts/posts") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        print("Requesting URL: \(url)")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Failed to fetch posts: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Response Status Code: \(httpResponse.statusCode)")
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decodedPosts = try JSONDecoder().decode([Post].self, from: data)
                
                DispatchQueue.main.async {
                    self.posts.append(contentsOf: decodedPosts) // Append instead of replacing
                    self.posts.sort { $0.createdAt > $1.createdAt } // Sort posts by newest first
                    print("Merged user's posts:", self.posts)
                }
            } catch {
                print("Failed to decode posts: \(error)")
            }
        }.resume()
    }
    
    func fetchAllPostsIfAdmin() {
        // Fetch user role and check if the user is an admin
        fetchUserRole { role in
            if role == "admin" {
                // Proceed with the API call to fetch all posts
                guard let url = URL(string: "https://TrailBlazer33:5001/api/posts/getEveryPost") else {
                    print("Invalid URL")
                    return
                }

                var request = URLRequest(url: url)
                request.httpMethod = "GET"

                // Add the authorization token
                if let token = UserDefaults.standard.string(forKey: "authToken") {
                    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                }

                print("Requesting URL: \(url)")
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("Failed to fetch all posts: \(error)")
                        return
                    }

                    if let httpResponse = response as? HTTPURLResponse {
                        print("Response Status Code: \(httpResponse.statusCode)")
                    }

                    guard let data = data else {
                        print("No data received")
                        return
                    }
                    

                    do {
                        let decodedPosts = try JSONDecoder().decode([Post].self, from: data)

                        DispatchQueue.main.async {
                            self.posts.append(contentsOf: decodedPosts) // Append instead of replacing
                            self.posts.sort { $0.createdAt > $1.createdAt } // Sort posts by newest first
                            print("Merged posts from admin fetch:", self.posts)
                        }
                    } catch {
                        print("Failed to decode posts:", error)
                    }
                }.resume()
            } else {
                print("User is not an admin, skipping fetch for all posts.")
            }
        }
    }

    // Get role type of the user
    func fetchUserRole(completion: @escaping (String) -> Void) {
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
                    completion(roleResponse.role)
                    print("User role fetched successfully:", roleResponse.role)
                }
            } catch {
                print("Failed to decode user role:", error.localizedDescription)
                if let dataString = String(data: data, encoding: .utf8) {
                    print("Received response:", dataString)
                }
            }
        }.resume()
    }


    
    struct PendingRequest: Codable {
        var userID: String
        var username: String
        var firstName: String
        var lastName: String
    }
    
    struct PendingRequestsResponse: Codable {
        var pendingRequests: [PendingRequest]
    }
    
    // Fetch any pending requests 
    func checkPendingRequests() {
        guard let url = URL(string: "https://TrailBlazer33:5001/api/friends/pending-requests") else {
            print("Invalid URL for checking pending requests")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("No token found")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error checking pending requests:", error)
                return
            }
            
            if let data = data {
                do {
                    // Decode the response into PendingRequestsResponse
                    let decodedResponse = try JSONDecoder().decode(PendingRequestsResponse.self, from: data)
                    
                    // Check if there are any pending requests
                    let pendingRequestsCount = decodedResponse.pendingRequests.count
                    DispatchQueue.main.async {
                        if pendingRequestsCount > 0 {
                            self.hasPendingRequests = true // Set the red dot to show
                            self.pendingRequestsCount = pendingRequestsCount > 9 ? 9 : pendingRequestsCount // Show "9+" if over 9
                        } else {
                            self.hasPendingRequests = false // No pending requests
                            self.pendingRequestsCount = 0 // No number to show
                        }
                    }
                } catch {
                    print("Error decoding pending requests:", error)
                }
            }
        }.resume()
    }
    
    
    
    
    
    struct FriendView_Previews: PreviewProvider {
        static var previews: some View {
            FriendView(userName: "John Doe")
            
        }
        
    }
}
