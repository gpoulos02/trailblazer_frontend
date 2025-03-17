import SwiftUI
import UniformTypeIdentifiers

struct MountainOwnerView: View {
    var userName: String

    @State private var trailsFile: Data? = nil
    @State private var pointsOfInterestFile: Data? = nil
    @State private var chairliftsFile: Data? = nil
    @State private var trailsFileName: String? = nil // Store file name
    @State private var pointsOfInterestFileName: String? = nil
    @State private var chairliftsFileName: String? = nil
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
            ScrollView {
                VStack(spacing: 20) {
                    Text("As a Mountain Owner, you can send a request to the admin.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.top)

                    // Text Fields
                    CustomTextField(placeholder: "Mountain Name", text: $name)
                    CustomTextField(placeholder: "Latitude", text: $latitude, keyboardType: .decimalPad)
                    CustomTextField(placeholder: "Longitude", text: $longitude, keyboardType: .decimalPad)
                    CustomTextField(placeholder: "Description", text: $description)

                    // File Upload Buttons
                    FileUploadButton(
                        title: "Upload Trails File",
                        fileData: $trailsFile,
                        fileName: $trailsFileName,
                        fileType: .trails,
                        showingFileImporter: $showingFileImporter,
                        selectedFileType: $selectedFileType
                    )
                    
                    FileUploadButton(
                        title: "Upload Points of Interest File",
                        fileData: $pointsOfInterestFile,
                        fileName: $pointsOfInterestFileName,
                        fileType: .pointsOfInterest,
                        showingFileImporter: $showingFileImporter,
                        selectedFileType: $selectedFileType
                    )
                    
                    FileUploadButton(
                        title: "Upload Chairlifts File",
                        fileData: $chairliftsFile,
                        fileName: $chairliftsFileName,
                        fileType: .chairlifts,
                        showingFileImporter: $showingFileImporter,
                        selectedFileType: $selectedFileType
                    )

                    // Submit Button
                    Button(action: {
                        submitRequest()
                    }) {
                        Text("Submit Request")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isSubmitting ? Color.gray : Color.green)
                            .cornerRadius(12)
                            .shadow(radius: 3)
                    }
                    .disabled(isSubmitting || trailsFile == nil || pointsOfInterestFile == nil || chairliftsFile == nil)

                    // Messages
                    if let successMessage = successMessage {
                        Text(successMessage)
                            .foregroundColor(.green)
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(8)
                            .transition(.opacity)
                    }

                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                            .transition(.opacity)
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Mountain Owner")
            .fileImporter(isPresented: $showingFileImporter, allowedContentTypes: [.json]) { result in
                switch result {
                case .success(let url):
                    do {
                        let fileData = try Data(contentsOf: url)
                        let fileName = url.lastPathComponent
                        handleFileSelection(fileData, fileName: fileName)
                    } catch {
                        errorMessage = "Error loading file: \(error.localizedDescription)"
                    }
                case .failure(let error):
                    errorMessage = "Failed to pick file: \(error.localizedDescription)"
                }
            }
        }
    }

    // MARK: - Custom Components
    struct CustomTextField: View {
        let placeholder: String
        @Binding var text: String
        var keyboardType: UIKeyboardType = .default

        var body: some View {
            TextField(placeholder, text: $text)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .keyboardType(keyboardType)
        }
    }

    struct FileUploadButton: View {
        let title: String
        @Binding var fileData: Data?
        @Binding var fileName: String?
        let fileType: FileType
        @Binding var showingFileImporter: Bool
        @Binding var selectedFileType: FileType?

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Button(action: {
                    selectedFileType = fileType
                    showingFileImporter = true
                }) {
                    HStack {
                        Image(systemName: "folder.fill")
                            .foregroundColor(.white)
                        Text(title)
                            .foregroundColor(.white)
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                    .shadow(radius: 3)
                }
                
                if let fileName = fileName {
                    Text("Selected: \(fileName)")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                }
            }
        }
    }

    // MARK: - File Handling
    private func handleFileSelection(_ fileData: Data, fileName: String) {
        guard let selectedFileType = selectedFileType else { return }
        switch selectedFileType {
        case .trails:
            trailsFile = fileData
            trailsFileName = fileName
        case .pointsOfInterest:
            pointsOfInterestFile = fileData
            pointsOfInterestFileName = fileName
        case .chairlifts:
            chairliftsFile = fileData
            chairliftsFileName = fileName
        }
    }

    // MARK: - Clear Fields
    private func clearFields() {
        name = ""
        latitude = ""
        longitude = ""
        description = ""
        trailsFile = nil
        pointsOfInterestFile = nil
        chairliftsFile = nil
        trailsFileName = nil
        pointsOfInterestFileName = nil
        chairliftsFileName = nil
    }

    // MARK: - Submit Request
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
            DispatchQueue.main.async {
                isSubmitting = false
                switch result {
                case .success:
                    successMessage = "Request submitted successfully!"
                    clearFields() // Clear fields on success
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        successMessage = nil // Clear success message after 3 seconds
                    }
                case .failure(let error):
                    errorMessage = "Failed to submit request: \(error.localizedDescription)"
                }
            }
        }
    }
    
    // MARK: - Send Request
    private func sendRequestToAdmin(formData: [String: String], files: [String: Data], completion: @escaping (Result<Void, Error>) -> Void) {
        let url = URL(string: "https://TrailBlazer33:5001/api/mountain-owner/request")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            print("Token found: \(token)")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("No Auth Token Found")
            errorMessage = "Authentication token missing."
            completion(.failure(NSError(domain: "com.yourapp", code: 401, userInfo: [NSLocalizedDescriptionKey: "Authentication token missing"])))
            return
        }

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        for (key, value) in formData {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        for (key, fileData) in files {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(key).json\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: application/json\r\n\r\n".data(using: .utf8)!)
            body.append(fileData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 201 {
                    completion(.success(()))
                } else {
                    let error = NSError(domain: "com.yourapp", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error with status code \(httpResponse.statusCode)"])
                    completion(.failure(error))
                }
            } else {
                let error = NSError(domain: "com.yourapp", code: 500, userInfo: [NSLocalizedDescriptionKey: "Unknown server response"])
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
