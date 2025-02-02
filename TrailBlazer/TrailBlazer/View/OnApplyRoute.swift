import SwiftUI

struct OnApplyRouteView: View {
    var userName: String
    
    @State private var isRouteActive: Bool = false
    @State private var speed: Int = 0
    @State private var timeElapsed: Int = 0 // Time in seconds
    @State private var elevation: Int = 0
    @State private var timer: Timer? = nil

    var body: some View {
        VStack(spacing: 20) {
            // Logo at the top
            Image("TextLogo")
                .resizable()
                .scaledToFit()
                .frame(height: 40)
                .padding(.top, 20)

            // Main Image
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 343, height: 362)
                .background(
                    AsyncImage(url: URL(string: "https://via.placeholder.com/343x362"))
                )
                .cornerRadius(5)

            // Stats (Speed, Time Elapsed, Elevation)
            VStack(spacing: 0) {
                // First Row: Speed and Time Elapsed Side by Side
                HStack(spacing: 16) {
                    // Speed
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Speed")
                            .font(Font.custom("Roboto", size: 16))
                            .tracking(0.50)
                            .lineSpacing(24)
                            .foregroundColor(Color(red: 0.11, green: 0.11, blue: 0.13))
                        Text("\(speed)")
                            .font(Font.custom("Inter", size: 40).weight(.bold))
                            .lineSpacing(40)
                            .foregroundColor(.black)
                        Text("km/hr")
                            .font(Font.custom("Inter", size: 16))
                            .lineSpacing(16)
                            .foregroundColor(.black)
                    }
                    .padding(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                    .frame(width: 152, height: 112)
                    .background(Color.white)

                    // Time Elapsed
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Time Elapsed")
                            .font(Font.custom("Roboto", size: 16))
                            .tracking(0.50)
                            .lineSpacing(24)
                            .foregroundColor(Color(red: 0.11, green: 0.11, blue: 0.13))
                        Text("\(formattedTime(timeElapsed))")
                            .font(Font.custom("Inter", size: 40).weight(.bold))
                            .lineSpacing(40)
                            .foregroundColor(.black)
                        Text("minutes")
                            .font(Font.custom("Inter", size: 16))
                            .lineSpacing(16)
                            .foregroundColor(.black)
                    }
                    .padding(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                    .frame(width: 167, height: 112)
                    .background(Color.white)
                }

                // Second Row: Elevation and Start/End Route Button
                HStack(spacing: 16) {
                    // Elevation
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Elevation")
                            .font(Font.custom("Roboto", size: 16))
                            .tracking(0.50)
                            .lineSpacing(24)
                            .foregroundColor(Color(red: 0.11, green: 0.11, blue: 0.13))
                        Text("\(elevation)")
                            .font(Font.custom("Inter", size: 40).weight(.bold))
                            .lineSpacing(40)
                            .foregroundColor(.black)
                        Text("meters")
                            .font(Font.custom("Inter", size: 16))
                            .lineSpacing(16)
                            .foregroundColor(.black)
                    }
                    .padding(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                    .frame(width: 152, height: 112)
                    .background(Color.white)

                    // Start/End Route Button
                    VStack {
                        Button(action: {
                            if isRouteActive {
                                stopRoute()
                            } else {
                                startRoute()
                            }
                        }) {
                            Text(isRouteActive ? "End Route" : "Start Route")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(isRouteActive ? Color.red : Color.blue)
                                .cornerRadius(8)
                        }
                    }
                    .frame(width: 125, height: 38)
                }
                HStack {
                    NavigationLink(destination: HomeView(userName: userName)) {
                        VStack {
                            Image(systemName: "house.fill")
                                .foregroundColor(.black)
                            Text("Home")
                                .foregroundColor(.black)
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                    }

                    NavigationLink(destination: FriendView(userName: userName)) {
                        VStack {
                            Image(systemName: "person.2.fill")
                                .foregroundColor(.black)
                            Text("Friends")
                                .foregroundColor(.black)
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                    }

                    NavigationLink(destination: RouteLandingView(userName: userName)) {
                        VStack {
                            Image(systemName: "map.fill")
                                .foregroundColor(.black)
                            Text("Map")
                                .foregroundColor(.black)
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                    }

                    NavigationLink(destination: PerformanceMetricsView(userName: userName)) {
                        VStack {
                            Image(systemName: "chart.bar.fill")
                                .foregroundColor(.black)
                            Text("Metrics")
                                .foregroundColor(.black)
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                    }

                    NavigationLink(destination: ProfileView(userName: userName)) {
                        VStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.black)
                            Text("Profile")
                                .foregroundColor(.black)
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding()
                .background(Color.white)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
//}
//            }
//        }
//        .padding(.horizontal)
//    }

    // Start Route: Initialize metrics and start a timer
    private func startRoute() {
        isRouteActive = true
        speed = Int.random(in: 20...30) // Simulated speed
        elevation = Int.random(in: 250...300) // Simulated elevation
        timeElapsed = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            timeElapsed += 1
        }
    }

    // End Route: Stop the timer and reset metrics
    private func stopRoute() {
        isRouteActive = false
        timer?.invalidate()
        timer = nil
        speed = 0
        elevation = 0
    }

    // Format time from seconds to mm:ss
    private func formattedTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

struct OnApplyRouteView_Previews: PreviewProvider {
    static var previews: some View {
        OnApplyRouteView(userName: "John Doe")
    }
}
