import SwiftUI

// Define the Post struct to represent each post
struct Post: Identifiable, Codable {
    var id: String // _id field from API
    var userID: String
    var type: String
    var title: String
    var textContent: String? // Only exists for text posts
    var performance: String? // Only exists for performance posts
    var route: Int? // Only exists for route posts
    var createdAt: String // ISO date string for creation time
    var likes: [String] // Assuming likes are stored as an array of user IDs
    var comments: [String] // Assuming comments are stored as an array of comment IDs
    
    // Coding keys to map API response keys to struct properties
    enum CodingKeys: String, CodingKey {
        case id = "_id"
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
}

struct FriendView: View {
    var userName: String
    
    @State private var navigateToFriendRequests = false
    @State private var currentTab: Tab = .friends
    @State private var showNewPostSheet = false
    @State private var posts: [Post] = [] // Now we use Post objects
    
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
                .padding(.horizontal, 20)
                
                // Posts Section (Below Location Section)
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(posts) { post in
                            VStack(spacing: 10) {
                                // Display title and content of each post
                                Text(post.title)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                
                                if post.type == "text" {
                                    Text(post.textContent ?? "No content available")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                } else if post.type == "performance" {
                                    Text("Performance Post: \(post.performance ?? "No performance data")")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                } else if post.type == "route" {
                                    Text("Route Post: \(String(post.route ?? 0))")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                
                                Divider()
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .border(Color.black, width: 1) // Visual distinction between posts
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
            }
            
            // Floating Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        showNewPostSheet = true
                    }) {
                        Image("newPost")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .padding()
                            .background(Color.indigo)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding()
                }
            }
        }
    }
    
    // Fetch posts from the API
    func fetchPosts() {
         guard let url = URL(string: "https://TrailBlazer33:5001/api/posts/my-posts") else { return }
         
         URLSession.shared.dataTask(with: url) { data, response, error in
             if let data = data {
                 do {
                     // Decode the JSON directly into an array of Post objects
                     let decodedPosts = try JSONDecoder().decode([Post].self, from: data)
                     DispatchQueue.main.async {
                         self.posts = decodedPosts
                     }
                 } catch {
                     print("Error decoding posts:", error)
                 }
             }
         }.resume()
     }
}

struct FriendView_Previews: PreviewProvider {
    static var previews: some View {
        FriendView(userName: "John Doe")
    }
}
