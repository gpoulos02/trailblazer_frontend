import SwiftUI

struct PostView: View {
    var post: [String: Any]  // Raw post data as a dictionary
    
    @State private var isLiked: Bool = false
    @State private var commentText: String = ""
    @State private var showComments: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Title of the Post
            Text(post["title"] as? String ?? "No Title")
                .font(.headline)
                .padding(.bottom, 5)
            
            // Conditional rendering based on the post type
            if let type = post["type"] as? String {
                switch type {
                case "text":
                    Text(post["textContent"] as? String ?? "No content")
                        .font(.body)
                        .foregroundColor(.black)
                case "route":
                    if let routeID = post["route"] as? String {
                        RoutePostView(routeID: routeID)
                    }
                case "performance":
                    if let performanceID = post["performance"] as? String {
                        PerformancePostView(performanceID: performanceID)
                    }
                default:
                    EmptyView()
                }
            }
            
            // Likes and Comments
            if let likes = post["likes"] as? [String] {
                HStack {
                    Text("\(likes.count) Likes")
                    Spacer()
                    if let comments = post["comments"] as? [[String: Any]] {
                        Text("\(comments.count) Comments")
                    }
                }
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.top, 5)
            }
            
            Divider()
        }
        .padding()
    }
}

struct RoutePostView: View {
    var routeID: String
    
    var body: some View {
        Text("Route Post - Route ID: \(routeID)") // You can replace with route details from the backend
            .font(.subheadline)
            .foregroundColor(.blue)
    }
}

struct PerformancePostView: View {
    var performanceID: String
    
    var body: some View {
        Text("Performance Post - Performance ID: \(performanceID)") // Replace with performance data
            .font(.subheadline)
            .foregroundColor(.green)
    }
}

//struct PostView: View {
//    let post: Post
//    @State private var isLiked: Bool = false
//    @State private var commentText: String = ""
//    @State private var showComments: Bool = false
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            HStack {
//                Text(post.user.username).font(.headline)
//                Spacer()
//                Text(post.createdAt.formatted())
//                    .font(.caption)
//                    .foregroundColor(.gray)
//            }
//            Text(post.title)
//                .font(.title2)
//
//            if post.type == "text" {
//                Text(post.textContent ?? "")
//            } else if post.type == "route" {
//                Text("Route: \(post.route ?? 0)")
//            } else if post.type == "performance" {
//                Text("Performance: \(post.performance ?? "N/A")")
//            }
//
//            HStack {
//                Button(action: {
//                    toggleLike()
//                }) {
//                    Image(systemName: isLiked ? "heart.fill" : "heart")
//                        .foregroundColor(isLiked ? .red : .gray)
//                }
//                Text("\(post.likes.count) likes")
//
//                Button(action: {
//                    showComments.toggle()
//                }) {
//                    Image(systemName: "bubble.right")
//                }
//                Text("\(post.comments.count) comments")
//            }
//
//            if showComments {
//                VStack(alignment: .leading) {
//                    ForEach(post.comments) { comment in
//                        Text("\(comment.user): \(comment.content)")
//                            .font(.caption)
//                    }
//                    HStack {
//                        TextField("Add a comment...", text: $commentText)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                        Button(action: {
//                            addComment()
//                        }) {
//                            Image(systemName: "paperplane.fill")
//                        }
//                    }
//                }
//            }
//
//        }
//        .padding()
//        .onAppear {
//            isLiked = post.likes.contains("YOUR_USER_ID_HERE") // Replace with actual user ID
//        }
//    }
//
//    func toggleLike() {
//        // Implement like/unlike logic here with API call
//        isLiked.toggle()
//    }
//
//    func addComment() {
//        // Implement add comment logic here with API call
//        if !commentText.isEmpty {
//            // Send comment to backend
//            commentText = "" // Clear text field
//        }
//    }
//}
//
//// Helper function to parse Date from ISO 8601 string
//extension Date {
//    func formatted() -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .short
//        formatter.timeStyle = .short
//        return formatter.string(from: self)
//    }
//}
