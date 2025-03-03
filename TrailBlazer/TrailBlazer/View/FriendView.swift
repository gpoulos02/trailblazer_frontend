import SwiftUI


// Define the Post struct to represent each post
struct Post: Identifiable, Codable {
    var id: String { postID ?? "" }
    var postID: String?
    var userID: String
    var type: String
    var title: String
    var textContent: String?
    var performance: String?
    var route: String? // Change this to String? to handle both types (String or Int)
    var createdAt: String
    var likes: [String]
    //var comments: [String]
    
    struct Comment: Codable {
            var user: String
            var content: String
            var createdAt: String
        }
    
    var comments: [Comment]
    
    enum CodingKeys: String, CodingKey {
        //case id = "_id"
        case postID
        case userID
        case type
        case title
        case textContent
        case performance
        case route
        case createdAt
        case likes
        case comments
    }
    
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            postID = try container.decodeIfPresent(String.self, forKey: .postID)
            userID = try container.decode(String.self, forKey: .userID)
            type = try container.decode(String.self, forKey: .type)
            title = try container.decode(String.self, forKey: .title)
            textContent = try container.decodeIfPresent(String.self, forKey: .textContent)
            performance = try container.decodeIfPresent(String.self, forKey: .performance)

            // Decode route which can be a String or a Number
            if let routeString = try? container.decode(String.self, forKey: .route) {
                route = routeString
            } else if let routeInt = try? container.decode(Int.self, forKey: .route) {
                route = String(routeInt) // Convert integer to string
            } else {
                route = nil
            }

            createdAt = try container.decode(String.self, forKey: .createdAt)
            likes = try container.decode([String].self, forKey: .likes)
            comments = try container.decode([Comment].self, forKey: .comments) // Decode as [Comment]
        }
    }


struct FriendView: View {
    var userName: String
    
    @State private var navigateToFriendRequests = false
    @State private var currentTab: Tab = .friends
    @State private var showNewPostSheet = false
    @State private var posts: [Post] = [] // Now we use Post objects
    @State private var newPostTitle: String = ""
    @State private var newPostContent: String = ""

    var body: some View {
        NavigationView {
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
                            Image("AddFriend")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 40)
                                .padding(.trailing, 20)
                        }
                    }
                    .padding(.top, 20)
                    .background(
                        NavigationLink("", destination: FriendRequestsView(userName: userName), isActive: $navigateToFriendRequests)
                    )
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color.gray.opacity(0.5))
                        .padding(.horizontal, 20)
                    
                    // Scrollable Friends Section
                    HStack(spacing: 10) {
                        Image("Location")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        
                        Rectangle()
                            .frame(width: 1, height: 30)
                            .foregroundColor(.black)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                Text("Add friends to see their location!")
                                    .font(.body)
                                    .foregroundColor(.black)
                            }
                            .padding(.leading, 10)
                        }
                    }

                }
                .padding(.horizontal, 20)
                
                // Posts Section (Below Location Section)
                ScrollView {


                        VStack(spacing: 10) {
                            ForEach(posts) { post in
                                PostView(post: post)
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
                .onAppear {
                    fetchPosts()
                    fetchFriendsPosts()
                }
                
                // Floating Button - This will navigate to the NewPostView
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
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
                            .padding(.bottom, 80)
                            .padding(.trailing, 15)
                        }
                    }
                }
            }
        }
    }

    func fetchPosts() {
        guard let url = URL(string: "https://TrailBlazer33:5001/api/posts/my-posts") else {
            print("Invalid URL for fetching posts")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print("Token added to request header")
        } else {
            print("No token found")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching posts:", error)
                return
            }
            
            if let data = data {
                print("Received data for posts:", data)
                
                do {
                    let decodedPosts = try JSONDecoder().decode([Post].self, from: data)
                    DispatchQueue.main.async {
                        self.posts = decodedPosts
                        print("Decoded posts:", decodedPosts) // Logs the decoded posts
                    }
                } catch {
                    print("Error decoding posts:", error)
                }
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
            print("Token added to request header for friends' posts")
        } else {
            print("No token found for friends' posts")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching friends' posts:", error)
                return
            }
            
            if let data = data {
                print("Received data for friends' posts:", data)
                
                do {
                    let decodedResponse = try JSONDecoder().decode([Post].self, from: data)
                    DispatchQueue.main.async {
                        self.posts.append(contentsOf: decodedResponse)
                        print("Decoded friends' posts:", decodedResponse) // Logs the decoded posts
                    }
                } catch {
                    print("Error decoding friends' posts:", error)
                }
            } else if let error = error {
                print("Error fetching friends' posts:", error)
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
                        print("DEBUG: Post creation response: \(jsonString)")
                    }
                }

                // Optionally, fetch the updated posts after creating the new post
                fetchPosts()
            }
        }.resume()
    }
}

struct FriendView_Previews: PreviewProvider {
    static var previews: some View {
        FriendView(userName: "ryan12") // Provide a mock userName for preview
    }
}
