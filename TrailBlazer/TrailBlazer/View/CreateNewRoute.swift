import SwiftUI

struct CreateNewRouteView: View {
    @State private var selectedLift: String = ""
    @State private var selectedDestination: String = ""
    @State private var maxDifficulty: String = ""
    @State private var availableRoutes: [String] = []
    @State private var isLoading: Bool = false
    @State private var showError: Bool = false
    @State private var navigateToRoutes: Bool = false // Controls navigation

    @State private var liftOptions: [String] = []
    @State private var destinationOptions: [String] = []
    @State private var difficultyLevels: [String] = []

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Title
                Text("Set Your Route")
                    .font(Font.custom("Inter", size: 20).weight(.bold))
                    .foregroundColor(.black)
                
                // Lift Taken (required)
                VStack(alignment: .leading, spacing: 8) {
                    Text("What lift did you take?")
                        .font(Font.custom("Inter", size: 16).weight(.bold))
                        .foregroundColor(.black)
                    
                    Picker("Select a lift", selection: $selectedLift) {
                        Text("Select a lift").tag("")
                        ForEach(liftOptions, id: \.self) { lift in
                            Text(lift).tag(lift)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .frame(maxWidth: 300)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    
                    // Error message
                    if showError && selectedLift.isEmpty {
                        Text("Please make a selection")
                            .font(Font.custom("Inter", size: 14))
                            .foregroundColor(.red)
                    }
                }
                
                // Destination (not required)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Where do you want to go?")
                        .font(Font.custom("Inter", size: 16).weight(.bold))
                        .foregroundColor(.black)
                    
                    Picker("Select a destination", selection: $selectedDestination) {
                        Text("Any Destination").tag("")
                        ForEach(destinationOptions, id: \.self) { destination in
                            Text(destination).tag(destination)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .frame(maxWidth: 300)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
                
                // Max Difficulty (not required)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Max Difficulty")
                        .font(Font.custom("Inter", size: 16).weight(.bold))
                        .foregroundColor(.black)
                    
                    Picker("Select difficulty", selection: $maxDifficulty) {
                        Text("No Limit").tag("")
                        ForEach(difficultyLevels, id: \.self) { difficulty in
                            Text(difficulty).tag(difficulty)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .frame(maxWidth: 300)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
                
                // Apply Button
                Button(action: fetchRoutes) {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Apply")
                            .font(Font.custom("Inter", size: 16).weight(.bold))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
                .padding(.vertical)
            }
            .padding()
            .onAppear(perform: fetchDropdownData)
            .navigationDestination(isPresented: $navigateToRoutes) {
                AvailableRoutesView(availableRoutes: availableRoutes)
            }
        }
    }

    // Function to fetch routes from backend
    private func fetchRoutes() {
        guard !selectedLift.isEmpty else {
            showError = true
            return
        }

        showError = false
        isLoading = true

        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            availableRoutes = ["Route 1", "Route 2", "Route 3"] // Mocked response
            isLoading = false
            navigateToRoutes = true // Trigger navigation
        }
    }

    // Function to fetch dropdown options from backend
    private func fetchDropdownData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            liftOptions = ["Lift A", "Lift B", "Lift C"]
            destinationOptions = ["South Base Lodge", "Activity Central"]
            difficultyLevels = ["Green", "Blue", "Black Diamond", "Double Black Diamond"]
        }
    }
}

struct CreateNewRouteView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewRouteView()
    }
}
