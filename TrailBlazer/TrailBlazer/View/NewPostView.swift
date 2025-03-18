import SwiftUI

struct NewPostView: View {
    @Environment(\.dismiss) var dismiss
    @State private var postTitle: String = ""
    @State private var postBody: String = ""
    @State private var isSubmitting = false

    var body: some View {
        VStack {
            Spacer() // Push content to the center vertically

            // Post Title Field
            TextField("Post Title", text: $postTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.title3)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .frame(width: 350)
            

            // Post Body TextEditor
            ZStack(alignment: .topLeading) {
                TextEditor(text: $postBody)
                    .frame(height: 180)
                    .padding(10) // Padding to match TextField padding
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .font(.body)
                    .frame(width: 350)

                // Text in textbox
                if postBody.isEmpty {
                    Text("What's on your mind?")
                        .foregroundColor(.gray)
                        .padding(.top, 12)
                        .padding(.leading, 15)
                        .font(.body)
                }
            }
            .padding(.horizontal) // Same horizontal padding as TextField

            Spacer() // Push content to the center vertically

            // Buttons at the bottom
            HStack {
                // Cancel Button
                Button(action: {
                    dismiss()
                }) {
                    Text("Cancel")
                                            .font(.body)
                                            .padding(.vertical, 10) // Reduce the height of the button
                                            .frame(maxWidth: .infinity)
                                            .background(Color.red)
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                }
                
                // Post Button
                Button(action: {
                    submitPost()
                }) {
                    Text(isSubmitting ? "Posting..." : "Post")
                        .font(.body)
                        .padding(.vertical, 10) // Reduce the height of the button
                        .frame(maxWidth: .infinity) 
                        .background(isSubmitting ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(isSubmitting || postBody.isEmpty || postTitle.isEmpty)
            }
            .padding(.horizontal)
            .padding(.bottom, 20) // Space from the bottom
        }
        .padding()
        .navigationTitle("Create Post")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func submitPost() {
        guard !postBody.isEmpty else {
            print("Attempted to submit an empty post")
            return
        }

        isSubmitting = true

        let requestBody: [String: Any] = ["title": postTitle, "textContent": postBody]
        guard let url = URL(string: "https://TrailBlazer33:5001/api/posts/text") else {
            print("Invalid URL")
            isSubmitting = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = UserDefaults.standard.string(forKey: "authToken") {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("No auth token found, request will fail")
            isSubmitting = false
            return
        }

        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isSubmitting = false

                if let error = error {
                    print("Network request failed with error: \(error.localizedDescription)")
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    print("Server responded with status code: \(httpResponse.statusCode)")
                }

                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("Response Data: \(responseString)")
                }

                dismiss()
            }
        }.resume()
    }
}

struct NewPostView_Previews: PreviewProvider {
    static var previews: some View {
        NewPostView()
    }
}
