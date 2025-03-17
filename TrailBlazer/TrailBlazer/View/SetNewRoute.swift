import SwiftUI

struct SetNewRouteView: View {
    var userName: String // Accept the user's name as a parameter
    
    @State private var currentTab: Tab = .map
    

    var body: some View {
        VStack(spacing: 20) {
            // Logo at the top
            Image("TextLogo")
                .resizable()
                .scaledToFit()
                .frame(height: 40)
                .padding(.top, 20)

            // Placeholder for map or saved routes section
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 343, height: 362)
                .background(
                    AsyncImage(url: URL(string: "https://via.placeholder.com/343x362"))
                )
                .cornerRadius(5)

            // "Set New Route" Button
            HStack(spacing: 8) {
                Text("Set New Route")
                    .font(Font.custom("Inter", size: 16))
                    .lineSpacing(16)
                    .foregroundColor(Color(red: 0.96, green: 0.96, blue: 0.96))
            }
            .padding(12)
            .frame(width: 144, height: 42)
            .background(Color(red: 0.17, green: 0.17, blue: 0.17))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .inset(by: 0.50)
                    .stroke(Color(red: 0.17, green: 0.17, blue: 0.17), lineWidth: 0.50)
            )

            // "Saved Routes" Button
            HStack(spacing: 8) {
                Text("Saved Routes")
                    .font(Font.custom("Inter", size: 16))
                    .lineSpacing(16)
                    .foregroundColor(Color(red: 0.96, green: 0.96, blue: 0.96))
            }
            .padding(12)
            .frame(width: 144, height: 42)
            .background(Color(red: 0.25, green: 0.61, blue: 1))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .inset(by: 0.50)
                    .stroke(Color(red: 0.25, green: 0.61, blue: 1), lineWidth: 0.50)
            )

            Spacer()

            // Bottom Navigation Bar with Shadow
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
            .shadow(radius: 5) // ✅ Added shadow to match other views
        }
    }

}

struct SetNewRouteView_Previews: PreviewProvider {
    static var previews: some View {
        SetNewRouteView(userName: "John Doe") // Provide a sample `userName` for preview
    }
}
