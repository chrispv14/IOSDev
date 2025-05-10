import SwiftUI
import MapKit

struct MapView: View {
    let vehicles: [Vehicle]
    @Binding var selectedVehicle: Vehicle?
    @Binding var showLoginPrompt: Bool
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -33.88331, longitude: 151.19951),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )

    var body: some View {
        Map(initialPosition: .region(region)) {
            ForEach(vehicles) { vehicle in
                Annotation(vehicle.model, coordinate: vehicle.coordinate) {
                    Button {
                        if isLoggedIn {
                            selectedVehicle = vehicle
                        } else {
                            showLoginPrompt = true
                        }
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: "car.fill")
                                .foregroundColor(.blue)
                                .font(.title2)
                        }
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            if let first = vehicles.first {
                region.center = first.coordinate
            }
        }
    }
}
