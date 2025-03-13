import SwiftUI

struct AdminView: View {
    
    var userName: String
    @State private var searchText = ""
    @State private var searchResults: [[String: Any]] = []
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            // Search Bar
            HStack {
                TextField("Search for usernames...", text: $searchText)
                    .padding(.leading, 30)
                    .frame(height: 45)
                    .padding(.horizontal, 15)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .padding(.leading, 8)
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
            
            // Search Results
            if !searchResults.isEmpty {
                Text("Search Results")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                List(searchResults, id: \.userID) { user in
                    if let username = user["username"] as? String, let userId = user["_id"] as? String {
                        HStack {
                            Text(username)
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            // Make Mountain Owner Button
                            Button(action: {
                                makeMountainOwner(userId: userId)
                            }) {
                                Image(systemName: "mountain.2.fill")
                                    .foregroundColor(.green)
                                    .font(.title2)
                            }
                            
                            // Suspend/Unsuspend Button
                            Button(action: {
                                toggleSuspension(userId: userId)
                            }) {
                                Image(systemName: user["isSuspended"] as? Bool == true ? "pause.circle" : "play.circle")
                                    .foregroundColor(user["isSuspended"] as? Bool == true ? .red : .orange)
                                    .font(.title2)
                            }
                            
                            // Delete Button
                            Button(action: {
                                deleteUser(userId: userId)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                                    .font(.title2)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationTitle("Admin")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Search Users
    func searchUsers() {
        guard !searchText.isEmpty else { return }
        isLoading = true
        
        guard let encodedQuery = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://TrailBlazer33:5001/api/friends/search?query=\(encodedQuery)") else {
            print("Invalid URL")
            isLoading = false
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

        print("Sending search request with query: \(encodedQuery)")
        
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
                        searchResults = array
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
    
    // MARK: - Make Mountain Owner
    func makeMountainOwner(userId: String) {
        guard let url = URL(string: "https://TrailBlazer33:5001/api/admin/approve-mountain-owner/\(userId)") else { return }
        performAdminAction(url: url, method: "POST")
    }
    
    // MARK: - Toggle Suspension
    func toggleSuspension(userId: String) {
        guard let url = URL(string: "https://TrailBlazer33:5001/api/users/\(userId)/toggle-suspension") else { return }
        performAdminAction(url: url, method: "POST")
    }
    
    // MARK: - Delete User
    func deleteUser(userId: String) {
        guard let url = URL(string: "https://TrailBlazer33:5001/api/users/\(userId)") else { return }
        performAdminAction(url: url, method: "DELETE")
    }
    
    // MARK: - Admin Action Helper
    private func performAdminAction(url: URL, method: String) {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            print("No token found")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("\(method) action error: \(error.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async {
                searchUsers() // Refresh results after action
            }
        }.resume()
    }
}
