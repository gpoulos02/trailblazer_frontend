
import SwiftUI

struct AdminView: View {
    var userName: String
    @State private var searchText = ""
    @State private var searchResults: [[String: Any]] = []
    @State private var mountainRequests: [[String: Any]] = []
    @State private var isLoading = false
    @State private var successMessage: String? = nil
    @State private var showDeleteConfirmation = false
    @State private var deleteSuccessMessage: String? = nil
    @State private var userIdToDelete: String? = nil

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

            if let successMessage = successMessage {
                Text(successMessage)
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
                    .transition(.opacity)
                    .animation(.easeInOut, value: successMessage)
            }
            
            if let deleteSuccessMessage = deleteSuccessMessage {
                Text(deleteSuccessMessage)
                    .font(.body)
                    .foregroundColor(.green)
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(8)
                    .transition(.opacity)
                    .animation(.easeInOut, value: deleteSuccessMessage)
            }

            // Search Results
            if !searchResults.isEmpty {
                Text("Search Results")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                List(searchResults, id: \.userID) { user in
                                    if let username = user["username"] as? String, let userId = user["_id"] as? String {
                                        
                                        let role = user["role"] as? String ?? "user"
                                        
                                        HStack { // Use VStack to stack username and buttons vertically
                                            // Username should not be inside a Button
                                            HStack {
                                                Text(username)
                                                    .font(.headline)
                                                    .foregroundColor(.primary)
                                                
                                                Spacer()
                                            }
                                            .padding(.vertical, 5) // Add some padding to separate from buttons
                                            
                                            Button(action: {
                                                userIdToDelete = userId
                                                showDeleteConfirmation = true
                                                deleteUser(userId: userId)
                                            }) {
                                                HStack {
                                                    Image(systemName: "trash.fill")
                                                        .foregroundColor(.white)
                                                        .font(.title2)
                                                }
                                                .padding(8)
                                                .background(Color.red)
                                                .cornerRadius(5)
                                                .shadow(radius: 3)
                                            
                                            // Make Mountain Owner or Demote Button
                                            if role != "mountain_owner" {
                                                Button(action: {
                                                    makeMountainOwner(userId: userId)
                                                }) {
                                                    HStack {
                                                        Text("Promote")
                                                        Image(systemName: "mountain.2.fill")
                                                            .foregroundColor(.green)
                                                            .font(.title3)
                                                    }
                                                }
                                                .padding(.bottom, 5)
                                                .frame(width: 140)
                                                
                                            } else {
                                                Button(action: {
                                                    demoteMountainOwner(userId: userId)
                                                }) {
                                                    HStack {
                                                        Text("Demote")
                                                        Image(systemName: "arrow.down.circle.fill")
                                                            .foregroundColor(.red)
                                                            .font(.title3)
                                                    }
                                                }
                                                .padding(.bottom, 5)
                                                .frame(width: 140)
                                            }
                                                

                                            }
                                        }
                                    }
                                }
                .listStyle(PlainListStyle())
            }

            // Mountain Requests Section
            VStack(alignment: .leading) {
                Text("Mountain Requests")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(mountainRequests.indices, id: \.self) { index in
                            let request = mountainRequests[index]
                            if let requestId = request["_id"] as? String,
                               let name = request["name"] as? String,
                               let location = request["location"] as? [String: Any],
                               let description = request["description"] as? String,
                               let latitude = location["latitude"] as? Double,
                               let longitude = location["longitude"] as? Double {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Name: \(name)")
                                        .font(.headline)
                                    Text("Location: \(latitude), \(longitude)")
                                        .font(.subheadline)
                                    Text("Description: \(description)")
                                        .font(.body)
                                        .foregroundColor(.gray)
                                    
                                    HStack {
                                        Spacer()
                                        Button(action: {
                                            denyMountainRequest(requestId: requestId)
                                        }) {
                                            Image(systemName: "x.circle.fill")
                                                .foregroundColor(.red)
                                                .font(.title2)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        .padding(.trailing, 10)
                                        
                                        Button(action: {
                                            acceptMountainRequest(requestId: requestId)
                                        }) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.green)
                                                .font(.title2)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .onAppear {
                fetchMountainRequests()
            }

            Spacer()
        }
        .navigationTitle("Admin")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Search Users
    func searchUsers() {
        guard !searchText.isEmpty else { return }
        isLoading = true
        
        guard let encodedQuery = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://TrailBlazer33:5001/api/admin/search?query=\(encodedQuery)") else {
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
                        searchResults = array.map { result in
                            var user = result
                            if let userId = user["_id"] as? String {
                                user["userID"] = userId
                            }
                            return user
                        }
                        print("Updated searchResults: \(searchResults)")
                    }
                } else if let object = json as? [String: Any] {
                    DispatchQueue.main.async {
                        var user = object
                        if let userId = user["_id"] as? String {
                            user["userID"] = userId
                        }
                        searchResults = [user]
                        print("Updated searchResults (single): \(searchResults)")
                    }
                } else {
                    print("Unexpected JSON format: \(json)")
                }
            } catch {
                print("JSON decoding error: \(error.localizedDescription)")
            }
        }.resume()
    }

    // MARK: - Fetch Mountain Requests
    func fetchMountainRequests() {
        guard let url = URL(string: "https://TrailBlazer33:5001/api/admin/mountain-requests") else {
            print("Invalid URL")
            return
        }
        
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            print("No token found")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        print("Fetching mountain requests...")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Fetch error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received from server")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print("Mountain requests JSON: \(json)")
                
                if let array = json as? [[String: Any]] {
                    DispatchQueue.main.async {
                        mountainRequests = array
                    }
                } else {
                    print("Unexpected JSON format: \(json)")
                }
            } catch {
                print("JSON decoding error: \(error.localizedDescription)")
            }
        }.resume()
    }

    // MARK: - Accept Mountain Request
    func acceptMountainRequest(requestId: String) {
        guard let url = URL(string: "https://TrailBlazer33:5001/api/admin/mountain-requests/\(requestId)/accept") else {
            print("Invalid URL")
            return
        }
        
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            print("No token found")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        print("Accepting mountain request \(requestId)...")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Accept error: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    successMessage = "Mountain request accepted"
                    mountainRequests.removeAll { $0["_id"] as? String == requestId }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        successMessage = nil
                    }
                }
            }
        }.resume()
    }
    
    // MARK: - Deny Mountain Request
    func denyMountainRequest(requestId: String) {
        guard let url = URL(string: "https://TrailBlazer33:5001/api/admin/mountain-requests/\(requestId)/deny") else {
            print("Invalid URL")
            return
        }
        
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            print("No token found")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        print("Denying mountain request \(requestId)...")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Deny error: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    successMessage = "Mountain request denied"
                    mountainRequests.removeAll { $0["_id"] as? String == requestId }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        successMessage = nil
                    }
                }
            }
        }.resume()
    }
    
    // MARK: - Make Mountain Owner
    func makeMountainOwner(userId: String) {
        guard let url = URL(string: "https://TrailBlazer33:5001/api/admin/approve-mountain-owner/\(userId)") else {
            print("Invalid URL")
            return
        }

        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            print("No token found")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        print("Attempting to make user \(userId) a Mountain Owner...")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received from server")
                return
            }

            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                if let responseDict = jsonResponse as? [String: Any], let message = responseDict["message"] as? String {
                    DispatchQueue.main.async {
                        print(message)
                        successMessage = "User is now a Mountain Owner"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                            successMessage = nil
                        }
                    }
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    // MARK: - Demote Mountain Owner
    func demoteMountainOwner(userId: String) {
        guard let url = URL(string: "https://TrailBlazer33:5001/api/admin/demote-mountain-owner/\(userId)") else {
            print("Invalid URL")
            return
        }

        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            print("No token found")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        print("Attempting to demote user \(userId) from Mountain Owner...")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received from server")
                return
            }

            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                if let responseDict = jsonResponse as? [String: Any], let message = responseDict["message"] as? String {
                    DispatchQueue.main.async {
                        print(message)
                        successMessage = "User has been demoted from Mountain Owner"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                            successMessage = nil
                        }
                    }
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }.resume()
    }

    // MARK: - Delete User
    func deleteUser(userId: String) {
        guard let url = URL(string: "https://TrailBlazer33:5001/api/admin/delete-user/\(userId)") else {
            print("Invalid URL")
            return
        }

        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            print("No token found")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received from server")
                return
            }

            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                if let responseDict = jsonResponse as? [String: Any], let message = responseDict["message"] as? String {
                    DispatchQueue.main.async {
                        deleteSuccessMessage = "User has been deleted"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            deleteSuccessMessage = nil
                        }
                    }
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}

struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView(userName: "Admin User")
    }
}
