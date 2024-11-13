import SwiftUI

struct OnApplyRouteView: View {
    var body: some View {
        VStack(spacing: 20) {
            
            // Header Image
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 256, height: 36)
                .background(
                    AsyncImage(url: URL(string: "https://via.placeholder.com/256x36"))
                )
                .padding()

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
                        // Stats Values
                        Text("24")
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
                        Text("10:04")
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

                // Second Row: Elevation and End Route Button Side by Side
                HStack(spacing: 16) {
                    // Elevation
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Elevation")
                            .font(Font.custom("Roboto", size: 16))
                            .tracking(0.50)
                            .lineSpacing(24)
                            .foregroundColor(Color(red: 0.11, green: 0.11, blue: 0.13))
                        Text("273")
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

                    // End Route Button
                    VStack {
                        Text("End Route")
                            .font(Font.custom("Inter", size: 16))
                            .lineSpacing(16)
                            .foregroundColor(Color.white)
                    }
                    .padding(12)
                    .frame(width: 125, height: 38)
                    .background(Color.blue)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .inset(by: 0.50)
                            .stroke(Color.blue, lineWidth: 0.50)
                    )
                }
            }

            

            // Unit Labels





        }
        .padding(.horizontal)
    }
}

struct OnApplyRoute_Previews: PreviewProvider {
    static var previews: some View {
        OnApplyRouteView()
    }
}
