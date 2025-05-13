import SwiftUI
import MapKit
struct MapView: View {
    let vehicles: [Vehicle]
    @Binding var selectedVehicle: Vehicle?
    @Binding var showLoginPrompt: Bool
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    @StateObject private var locationManager = LocationManager()

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -33.88331, longitude: 151.19951),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )

    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: vehicles) { vehicle in
            MapAnnotation(coordinate: vehicle.coordinate) {
                Button {
                    if isLoggedIn {
                        selectedVehicle = vehicle
                    } else {
                        showLoginPrompt = true
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: iconName(for: vehicle.type))
                            .font(.title2)
                            .foregroundColor(iconColor(for: vehicle.type))
                    }
                }
            }
        }
        .ignoresSafeArea(edges: .top)
    }

    private func iconName(for type: String) -> String {
        switch type.lowercased() {
        case "car": return "car.fill"
        case "bike": return "bicycle"
        case "scooter": return "scooter"
        default: return "car"
        }
    }

    private func iconColor(for type: String) -> Color {
        switch type.lowercased() {
        case "car": return .blue
        case "bike": return .green
        case "scooter": return .orange
        default: return .gray
        }
    }
}
