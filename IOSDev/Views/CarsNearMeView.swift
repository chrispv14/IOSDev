import SwiftUI

struct CarsNearMeView: View {
    @EnvironmentObject var bookingStore: BookingStore
    @State private var showMap = false
    @State private var selectedVehicle: Vehicle?
    
    let vehicles = [
        Vehicle(brand: "Toyota", model: "Corolla", latitude: -33.88331, longitude: 151.19951, fuelPercentage: 85),
        Vehicle(brand: "Ford", model: "Focus", latitude: -33.88295, longitude: 151.20464, fuelPercentage: 60),
        Vehicle(brand: "Tesla", model: "Model 3", latitude: -33.88549, longitude: 151.20289, fuelPercentage: 95),
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
                .padding()
                
                if showMap {
                    MapView()
                } else {
                    List(vehicles) { vehicle in
                        Button {
                            selectedVehicle = vehicle
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
        }
    }
}
