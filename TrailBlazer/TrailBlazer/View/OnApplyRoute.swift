import SwiftUI

struct OnApplyRouteView: View {
    var userName: String
    
    @State private var isRouteActive: Bool = false
    @State private var speed: Int = 0
    @State private var timeElapsed: Int = 0 // Time in seconds
    @State private var elevation: Int = 0
    @State private var timer: Timer? = nil
    @State private var currentTab: Tab = .map

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
            }
            .padding(.bottom, 100) // Prevents overlap with nav bar

            Spacer()

            // Fixed Bottom Navigation Bar with Shadow
            VStack {
                Divider()
                HStack {
                    TabBarItem(
                        tab: .home,
                        currentTab: $currentTab,
                        destination: { HomeView(userName: userName) },
                        imageName: "house.fill",
                        label: "Home"
                    )
                    TabBarItem(
                        tab: .friends,
                        currentTab: $currentTab,
                        destination: { FriendView(userName: userName) },
                        imageName: "person.2.fill",
                        label: "Friends"
                    )
                    TabBarItem(
                        tab: .map,
                        currentTab: $currentTab,
                        destination: { RouteLandingView(userName: userName) },
                        imageName: "map.fill",
                        label: "Map"
                    )
                    TabBarItem(
                        tab: .metrics,
                        currentTab: $currentTab,
                        destination: { PerformanceMetricsView(userName: userName) },
                        imageName: "chart.bar.fill",
                        label: "Metrics"
                    )
                    TabBarItem(
                        tab: .profile,
                        currentTab: $currentTab,
                        destination: { ProfileView(userName: userName) },
                        imageName: "person.fill",
                        label: "Profile"
                    )
                }
                .padding()
                .background(Color.white)
                .shadow(radius: 5) // ✅ Adds shadow effect
            }
            .frame(maxWidth: .infinity)
        }
        .navigationBarBackButtonHidden(true)
    }

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
