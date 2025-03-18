import SwiftUI

// Enum to define the different tabs
enum Tab {
    case home, friends, map, metrics, profile
}

// TabBarItem: Custom view for each tab
struct TabBarItem<Destination: View>: View {
    var tab: Tab                   // The tab type (home, friends, etc.)
    @Binding var currentTab: Tab    // The current tab (so you can update the state)
    var destination: () -> Destination  // Closure for creating the destination view
    var imageName: String          // Name of the system icon
    var label: String              // Label text for the tab

    var body: some View {
        NavigationLink(destination: destination()) {
            VStack {
                Image(systemName: imageName)
                    .foregroundColor(currentTab == tab ? .blue : .black)
                
                Text(label)
                    .foregroundColor(currentTab == tab ? .blue : .black)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .simultaneousGesture(TapGesture().onEnded {
                currentTab = tab
            })
        }
    }
}


