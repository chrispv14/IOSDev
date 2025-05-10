import SwiftUI

struct CarsNearMeView: View {
    @EnvironmentObject var bookingStore: BookingStore
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @State private var selectedVehicle: Vehicle?
    @State private var showLoginPrompt = false
    @State private var showMap = false  // <- Add this toggle state

    let vehicles = [
        Vehicle(brand: "Toyota", model: "Corolla", latitude: -33.88331, longitude: 151.19951, fuelPercentage: 85),
        Vehicle(brand: "Ford", model: "Focus", latitude: -33.88295, longitude: 151.20464, fuelPercentage: 60),
        Vehicle(brand: "Tesla", model: "Tesla", latitude: -33.88549, longitude: 151.20289, fuelPercentage: 95),
        Vehicle(brand: "Mazda", model: "CX-5", latitude: -33.88271, longitude: 151.19665, fuelPercentage: 50),
        Vehicle(brand: "Hyundai", model: "i30", latitude: -33.88033, longitude: 151.19781, fuelPercentage: 70),
        Vehicle(brand: "BMW", model: "X3", latitude: -33.88242, longitude: 151.20090, fuelPercentage: 40)
    ]

    var body: some View {
        NavigationView {
            VStack {
                Picker("View Mode", selection: $showMap) {
                    Text("List").tag(false)
                    Text("Map").tag(true)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                if showMap {
                    MapView(
                        vehicles: vehicles,
                        selectedVehicle: $selectedVehicle,
                        showLoginPrompt: $showLoginPrompt
                    )
                } else {
                    List(vehicles) { vehicle in
                        Button {
                            if isLoggedIn {
                                selectedVehicle = vehicle
                            } else {
                                showLoginPrompt = true
                            }
                        } label: {
                            VStack(alignment: .leading) {
                                Text("\(vehicle.brand) \(vehicle.model)")
                                    .font(.headline)
                                Text("Fuel: \(vehicle.fuelPercentage)%")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Nearby Cars")
            .sheet(item: $selectedVehicle) { vehicle in
                NewBookingView(vehicle: vehicle) { booking in
                    bookingStore.addBooking(booking)
                }
            }
            .sheet(isPresented: $showLoginPrompt) {
                AuthModalView(onLoginSuccess: {
                    showLoginPrompt = false
                })
            }
        }
    }
}
