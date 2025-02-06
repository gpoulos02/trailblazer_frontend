import SwiftUI

struct NewPostView: View {
    @Environment(\.dismiss) var dismiss
    @State private var postTitle: String = ""
    @State private var postBody: String = ""
    @State private var isSubmitting = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Post Title", text: $postTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onChange(of: postTitle) { newValue in
                        print("DEBUG: Post title changed to \(newValue)")
                    }
                
                TextEditor(text: $postBody)
                    .frame(height: 150)
                    .border(Color.gray, width: 1)
                    .padding()
                    .overlay(
                        VStack {
                            if postBody.isEmpty {
                                Text("What's on your mind?")
                                    .foregroundColor(.gray)
                                    .padding(.top, 8)
                            }
                            Spacer()
                        }
                            .padding(.leading, 5),
                        alignment: .topLeading
                    )
                    .onChange(of: postBody) { newValue in
                        print("DEBUG: Post body changed to \(newValue)")
                    }
                
                Button(action: submitPost) {
                    Text(isSubmitting ? "Posting..." : "Post")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isSubmitting ? Color.gray : Color.indigo)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                .disabled(isSubmitting)
                .onAppear {
                    print("DEBUG: NewPostView appeared")
                }
                .onDisappear {
                    print("DEBUG: NewPostView disappeared")
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Create Post")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        print("DEBUG: User tapped Cancel")
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func submitPost() {
        guard !postBody.isEmpty else {
            print("DEBUG: Attempted to submit an empty post")
            return
        }
        
        isSubmitting = true
        print("DEBUG: Submitting post with title: \(postTitle) and body: \(postBody)")
        
        let requestBody: [String: Any] = ["title": postTitle, "textContent": postBody]
        guard let url = URL(string: "https://TrailBlazer33:5001/api/posts/text") else {
            print("DEBUG: Invalid URL")
            isSubmitting = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Retrieve token (this should be stored securely in UserDefaults or Keychain)
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print("DEBUG: Authorization token added to request")
        } else {
            print("DEBUG: No auth token found, request will fail")
            isSubmitting = false
            return
        }
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
        
        print("DEBUG: Sending network request to \(url)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isSubmitting = false
                
                if let error = error {
                    print("DEBUG: Network request failed with error: \(error.localizedDescription)")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("DEBUG: Server responded with status code: \(httpResponse.statusCode)")
                }
                
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("DEBUG: Response Data: \(responseString)")
                }
                
                print("DEBUG: Post submitted successfully")
                dismiss()
            }
        }.resume()
    }
}
