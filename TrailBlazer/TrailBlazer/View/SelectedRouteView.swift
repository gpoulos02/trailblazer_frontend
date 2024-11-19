import SwiftUI

struct SelectedRouteView: View {
    let routeName: String // Passed from the previous view
    @State private var timerRunning: Bool = false
    @State private var startTime: Date? = nil
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer? = nil

    @ObservedObject private var locationManager = LocationManager()

    var body: some View {
        VStack(spacing: 20) {
            // Route Name
            Text("\(routeName)")
                .font(Font.custom("Inter", size: 20).weight(.bold))
                .foregroundColor(.black)

            // Map Placeholder
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 200)
                .cornerRadius(8)
                .overlay(
                    Text("Map View (Coming Soon)")
                        .font(Font.custom("Inter", size: 16))
                        .foregroundColor(.black.opacity(0.7))
                )

            // Metrics
            HStack(spacing: 40) {
                VStack {
                    Text("Speed")
                        .font(Font.custom("Inter", size: 16))
                        .foregroundColor(.black)
                    Text("\(String(format: "%.1f", locationManager.currentSpeed)) m/s")
                        .font(Font.custom("Inter", size: 16).weight(.bold))
                        .foregroundColor(.blue)
                }

                VStack {
                    Text("Elevation")
                        .font(Font.custom("Inter", size: 16))
                        .foregroundColor(.black)
                    Text("\(String(format: "%.1f", locationManager.currentElevation)) m")
                        .font(Font.custom("Inter", size: 16).weight(.bold))
                        .foregroundColor(.blue)
                }
            }

            // Timer
            Text("Elapsed Time: \(formatTime(elapsedTime))")
                .font(Font.custom("Inter", size: 16))
                .foregroundColor(.black)

            // Start/End Button
            Button(action: toggleTimer) {
                Text(timerRunning ? "End Route" : "Start Route")
                    .font(Font.custom("Inter", size: 16).weight(.bold))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(timerRunning ? Color.red : Color.blue)
                    .cornerRadius(8)
            }
            .padding(.vertical)
        }
        .padding()
        .onDisappear {
            stopTimer()
            locationManager.stopUpdatingLocation()
        }
    }

    // Format elapsed time into hours, minutes, seconds
    private func formatTime(_ time: TimeInterval) -> String {
        let seconds = Int(time) % 60
        let minutes = (Int(time) / 60) % 60
        let hours = Int(time) / 3600
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    // Start/End Timer
    private func toggleTimer() {
        if timerRunning {
            // Stop the timer
            stopTimer()
            if let start = startTime {
                elapsedTime += Date().timeIntervalSince(start)
            }
            saveMetrics() // Save metrics to the backend
        } else {
            // Start the timer
            startTime = Date()
            timerRunning = true
            startTimer()
        }
    }

    // Start the Timer
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if let start = startTime {
                elapsedTime = Date().timeIntervalSince(start)
            }
        }
    }

    // Stop the Timer
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        timerRunning = false
    }

    // Save Metrics to Backend (Placeholder)
    private func saveMetrics() {
        // Simulate saving metrics to backend
        print("Saving metrics: \(elapsedTime) seconds, Speed: \(locationManager.currentSpeed), Elevation: \(locationManager.currentElevation)")
    }
}

struct SelectedRouteView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedRouteView(routeName: "Route 1")
    }
}
