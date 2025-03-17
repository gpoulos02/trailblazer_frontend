import SwiftUI
import UniformTypeIdentifiers

struct MountainOwnerView: View {
    var userName: String

    @State private var trailsFile: Data? = nil
    @State private var pointsOfInterestFile: Data? = nil
    @State private var chairliftsFile: Data? = nil
    @State private var name: String = ""
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    @State private var description: String = ""
    
    @State private var successMessage: String? = nil
    @State private var errorMessage: String? = nil
    @State private var isSubmitting = false
    @State private var showingFileImporter = false
    @State private var selectedFileType: FileType?

    var body: some View {
        NavigationStack {
            VStack {
                Text("As a Mountain Owner, you can send a request to the admin.")
                    .padding()

                TextField("Mountain Name", text: $name)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Latitude", text: $latitude)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)

                TextField("Longitude", text: $longitude)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)

                TextField("Description", text: $description)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button("Choose Trails File") {
                    selectedFileType = .trails
                    showingFileImporter = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)

                Button("Choose Points of Interest File") {
                    selectedFileType = .pointsOfInterest
                    showingFileImporter = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)

                Button("Choose Chairlifts File") {
                    selectedFileType = .chairlifts
                    showingFileImporter = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)

                Button(action: {
                    submitRequest()
                }) {
                    Text("Submit Request")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(isSubmitting ? Color.gray : Color.green)
                        .cornerRadius(8)
                }
                .disabled(isSubmitting || trailsFile == nil || pointsOfInterestFile == nil || chairliftsFile == nil)

                if let successMessage = successMessage {
                    Text(successMessage)
                        .foregroundColor(.green)
                        .padding()
                }

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Mountain Owner")
            .fileImporter(isPresented: $showingFileImporter, allowedContentTypes: [.json]) { result in
                switch result {
                case .success(let url):
                    do {
                        let fileData = try Data(contentsOf: url)
                        handleFileSelection(fileData)
                    } catch {
                        errorMessage = "Error loading file: \(error.localizedDescription)"
                    }
                case .failure(let error):
                    errorMessage = "Failed to pick file: \(error.localizedDescription)"
                }
            }
        }
    }

    private func handleFileSelection(_ fileData: Data) {
        guard let selectedFileType = selectedFileType else { return }
        switch selectedFileType {
        case .trails:
            trailsFile = fileData
        case .pointsOfInterest:
            pointsOfInterestFile = fileData
        case .chairlifts:
            chairliftsFile = fileData
        }
    }

    private func submitRequest() {
        guard let trailsFile = trailsFile,
              let pointsOfInterestFile = pointsOfInterestFile,
              let chairliftsFile = chairliftsFile,
              !name.isEmpty, !latitude.isEmpty, !longitude.isEmpty, !description.isEmpty else {
            errorMessage = "Please fill in all fields and select all files."
            return
        }

        guard let lat = Double(latitude), let lon = Double(longitude) else {
            errorMessage = "Please enter valid latitude and longitude values."
            return
        }

        isSubmitting = true
        errorMessage = nil
        successMessage = nil

        let formData = [
            "name": name,
            "latitude": latitude,
            "longitude": longitude,
            "description": description
        ]
        
        let files: [String: Data] = [
            "trailsFile": trailsFile,
            "pointsOfInterestFile": pointsOfInterestFile,
            "chairliftsFile": chairliftsFile
        ]

        sendRequestToAdmin(formData: formData, files: files) { result in
            isSubmitting = false
            switch result {
            case .success:
                successMessage = "Request submitted successfully!"
            case .failure(let error):
                errorMessage = "Failed to submit request: \(error.localizedDescription)"
            }
        }
    }
    
    private func sendRequestToAdmin(formData: [String: String], files: [String: Data], completion: @escaping (Result<Void, Error>) -> Void) {
        let url = URL(string: "https://TrailBlazer33:5001/api/mountain-owner/request")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Add JWT token from UserDefaults
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            print("Token found: \(token)") // Log token
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("No Auth Token Found") // Log missing token
            errorMessage = "Authentication token missing."
            completion(.failure(NSError(domain: "com.yourapp", code: 401, userInfo: [NSLocalizedDescriptionKey: "Authentication token missing"])))
            return
        }

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Log form data
        print("Form Data: \(formData)")
        for (key, value) in formData {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        // Log file data sizes
        print("Files being sent:")
        for (key, fileData) in files {
            print("\(key): \(fileData.count) bytes")
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(key).json\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: application/json\r\n\r\n".data(using: .utf8)!)
            body.append(fileData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        // Log the full request
        print("Sending request to: \(url)")
        print("HTTP Method: \(request.httpMethod ?? "N/A")")
        print("Headers: \(request.allHTTPHeaderFields ?? [:])")
        print("Body size: \(body.count) bytes")

        URLSession.shared.dataTask(with: request) { data, response, error in
            // Log response details
            if let error = error {
                print("Request failed with error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code: \(httpResponse.statusCode)")
                if let responseData = data, let responseString = String(data: responseData, encoding: .utf8) {
                    print("Response body: \(responseString)")
                }
                
                if httpResponse.statusCode == 201 {
                    print("Request succeeded")
                    completion(.success(()))
                } else {
                    let error = NSError(domain: "com.yourapp", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error with status code \(httpResponse.statusCode)"])
                    print("Request failed with status code: \(httpResponse.statusCode)")
                    completion(.failure(error))
                }
            } else {
                let error = NSError(domain: "com.yourapp", code: 500, userInfo: [NSLocalizedDescriptionKey: "Unknown server response"])
                print("Unknown server response")
                completion(.failure(error))
            }
        }.resume()
    }
}

enum FileType {
    case trails
    case pointsOfInterest
    case chairlifts
}

struct MountainOwnerView_Previews: PreviewProvider {
    static var previews: some View {
        MountainOwnerView(userName: "Sadie Smyth")
    }
}
