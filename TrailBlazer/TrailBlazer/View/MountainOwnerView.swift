import SwiftUI
import UniformTypeIdentifiers

struct MountainOwnerView: View {
    var userName: String

    @State private var geoJsonFile: Data? = nil
    @State private var trailsFile: Data? = nil
    @State private var pointsOfInterestFile: Data? = nil
    @State private var chairliftsFile: Data? = nil
    @State private var name: String = ""
    @State private var location: String = ""
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

                // Mountain Name Field
                TextField("Mountain Name", text: $name)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                // Location Field
                TextField("Location (JSON)", text: $location)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                // Description Field
                TextField("Description", text: $description)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                // File Picker for JSON files
                Button("Choose GeoJSON File") {
                    selectedFileType = .geoJson
                    showingFileImporter = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                
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

                // Submit Button
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
                .disabled(isSubmitting || geoJsonFile == nil || trailsFile == nil || pointsOfInterestFile == nil || chairliftsFile == nil)

                // Success/Error Messages
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
        // Assign the selected file data to the correct file based on type
        guard let selectedFileType = selectedFileType else { return }

        switch selectedFileType {
        case .geoJson:
            geoJsonFile = fileData
        case .trails:
            trailsFile = fileData
        case .pointsOfInterest:
            pointsOfInterestFile = fileData
        case .chairlifts:
            chairliftsFile = fileData
        }
    }

    private func submitRequest() {
        guard let geoJsonFile = geoJsonFile,
              let trailsFile = trailsFile,
              let pointsOfInterestFile = pointsOfInterestFile,
              let chairliftsFile = chairliftsFile,
              !name.isEmpty, !location.isEmpty, !description.isEmpty else {
            errorMessage = "Please fill in all fields and select all files."
            return
        }

        isSubmitting = true
        errorMessage = nil
        successMessage = nil

        // Prepare the form data for the API request
        let formData = [
            "name": name,
            "location": location,
            "description": description
        ]
        
        let files: [String: Data] = [
            "geoJsonFile": geoJsonFile,
            "trailsFile": trailsFile,
            "pointsOfInterestFile": pointsOfInterestFile,
            "chairliftsFile": chairliftsFile
        ]

        // Send the API request
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
        // Prepare the multipart/form-data request
        let url = URL(string: "https://TrailBlazer33:5001/api/mountain-owner/request")! // Replace with your actual endpoint
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Create the boundary string
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // Add form fields
        for (key, value) in formData {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        // Add files
        for (key, fileData) in files {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(key).json\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: application/json\r\n\r\n".data(using: .utf8)!)
            body.append(fileData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        // End the body
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        // Perform the network request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 201 {
                completion(.success(()))
            } else {
                completion(.failure(NSError(domain: "com.yourapp", code: 500, userInfo: [NSLocalizedDescriptionKey: "Server error"])))
            }
        }.resume()
    }
    
}

enum FileType {
    case geoJson
    case trails
    case pointsOfInterest
    case chairlifts
}

struct MountainOwnerView_Previews: PreviewProvider {
    static var previews: some View {
        MountainOwnerView(userName: "Sadie Smyth")
    }
}
