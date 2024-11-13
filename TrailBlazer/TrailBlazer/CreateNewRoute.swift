import SwiftUI

struct CreateNewRouteView: View {
    @State private var fontSize: CGFloat = 12
    let routeOptions = ["Blue", "Black Diamond", "Double Black Diamond", "South Base Lodge"]
    
    var body: some View {
        VStack(spacing: 20) {
            // Title Bar
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 256, height: 36)
                .background(
                    AsyncImage(url: URL(string: "https://via.placeholder.com/256x36"))
                )
                .padding()
            
            
            // Route Selection Text
            
            // Difficulty Section
            Text("Difficulty")
                .font(Font.custom("Inter", size: 16).weight(.bold))
                .foregroundColor(.black)
            
            VStack(spacing: 0) {
                difficultyRow(title: "Green")
                difficultyRow(title: "Blue")
                difficultyRow(title: "Black Diamond")
                difficultyRow(title: "Double Black Diamond")
            }
            
            // Destination Section
            Text("Destination")
                .font(Font.custom("Inter", size: 16).weight(.bold))
                .foregroundColor(.black)
            
            VStack(spacing: 0) {
                destinationRow(title: "South Base Lodge")
                destinationRow(title: "Activity Central")
            }
            // Filter button at the bottom
            Button(action: {
                print("Filter button tapped")
            }) {
                Text("Filter")
                    .font(Font.custom("Inter", size: fontSize))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            //.padding([.top, .bottom])
            
            
            Spacer()
            
            // Navigation Bar at the Bottom
            HStack {
                // Home Button
                Button(action: {
                    // Action for Home tab
                }) {
                    VStack {
                        Image(systemName: "house.fill")
                            .foregroundColor(.black)
                        Text("Home")
                            .foregroundColor(.black)
                            .font(.caption)
                    }
                }
                .frame(maxWidth: .infinity)
                
                // Friends Button
                Button(action: {
                    // Action for Friends tab
                }) {
                    VStack {
                        Image(systemName: "person.2.fill") // Represents friends
                            .foregroundColor(.black)
                        Text("Friends")
                            .foregroundColor(.black)
                            .font(.caption)
                    }
                }
                .frame(maxWidth: .infinity)
                
                // Map Button
                Button(action: {
                    // Action for Map tab
                }) {
                    VStack {
                        Image(systemName: "map.fill") // Represents Map
                            .foregroundColor(.black)
                        Text("Map")
                            .foregroundColor(.black)
                            .font(.caption)
                    }
                }
                .frame(maxWidth: .infinity)
                
                // Weather Button
                Button(action: {
                    // Action for Weather tab
                }) {
                    VStack {
                        Image(systemName: "cloud.sun.fill") // Represents Weather
                            .foregroundColor(.black)
                        Text("Weather")
                            .foregroundColor(.black)
                            .font(.caption)
                    }
                }
                .frame(maxWidth: .infinity)
                
                // Profile Button
                Button(action: {
                    // Action for Profile tab
                }) {
                    VStack {
                        Image(systemName: "person.fill") // Represents Profile
                            .foregroundColor(.black)
                        Text("Profile")
                            .foregroundColor(.black)
                            .font(.caption)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .background(Color.white)
            .shadow(radius: 5)
        
        }
       
        
        
    }
    
    private func difficultyRow(title: String) -> some View {
        SwiftUICore.HStack(spacing: 20) {
            Text(title)
                .font(Font.custom("Inter", size: 17))
                .lineSpacing(22)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 44)
            
            applyButton
        }
        .frame(width: 402, height: 44)
        .overlay(
            Rectangle()
                .inset(by: -0.17)
                .stroke(Color(red: 0.33, green: 0.33, blue: 0.34).opacity(0.34), lineWidth: 0.17)
        )
    }
    
    private func destinationRow(title: String) -> some View {
        SwiftUICore.HStack(spacing: 0) {
            Text(title)
                .font(Font.custom("Inter", size: 17))
                .lineSpacing(22)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 44)
            
            applyButton
        }
        .frame(width: 402, height: 44)
        .overlay(
            Rectangle()
                .inset(by: -0.17)
                .stroke(Color(red: 0.33, green: 0.33, blue: 0.34).opacity(0.34), lineWidth: 0.17)
        )
    }
    
    private var applyButton: some View {
        SwiftUICore.HStack(spacing: 16) {
            Text("Apply")
                .font(Font.custom("Inter", size: 17))
                .lineSpacing(22)
                .foregroundColor(Color(red: 0.24, green: 0.24, blue: 0.26).opacity(0.60))
                .padding(EdgeInsets(top: 8, leading: 2, bottom: 8, trailing: 0))
                .frame(width: 45)
            
            
        }
        .frame(minWidth: 85, maxWidth: 85, maxHeight: .infinity)
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
    }
    
    
    //Spacer()
    
    
    struct CreateNewRouteView_Previews: PreviewProvider {
        static var previews: some View {
            CreateNewRouteView()
            // Adds padding around the preview
        }
    }
    
}
