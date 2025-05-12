import SwiftUI

struct CarsNearMeView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @EnvironmentObject var bookingStore: BookingStore

    @State private var selectedVehicle: Vehicle?
    @State private var showLoginPrompt = false
    @State private var showMap = false
    @State private var selectedType = "All"

    private let vehicleTypes = ["All", "Car", "Bike", "Scooter"]

    private let vehicles: [Vehicle] = [
        Vehicle(id: "TOYOTA_COROLLA_1", brand: "Toyota", model: "Corolla", latitude: -33.88331, longitude: 151.19951, fuelPercentage: 85, type: "Car"),
        Vehicle(id: "FORD_FOCUS_1", brand: "Ford", model: "Focus", latitude: -33.88295, longitude: 151.20464, fuelPercentage: 60, type: "Car"),
        Vehicle(id: "TESLA_MODEL3_1", brand: "Tesla", model: "Model 3", latitude: -33.88477, longitude: 151.20222, fuelPercentage: 90, type: "Car"),
        Vehicle(id: "BMW_X1_1", brand: "BMW", model: "X1", latitude: -33.88510, longitude: 151.20075, fuelPercentage: 55, type: "Car"),
        Vehicle(id: "MAZDA_3_1", brand: "Mazda", model: "Mazda3", latitude: -33.88188, longitude: 151.19777, fuelPercentage: 70, type: "Car"),
        Vehicle(id: "YAMAHA_EBIKE_1", brand: "Yamaha", model: "E-Bike X", latitude: -33.88120, longitude: 151.19800, fuelPercentage: 90, type: "Bike"),
        Vehicle(id: "GIANT_EBIKE_1", brand: "Giant", model: "Explore E+", latitude: -33.88230, longitude: 151.20310, fuelPercentage: 80, type: "Bike"),
        Vehicle(id: "SEGWAY_SCOOTER_1", brand: "Segway", model: "Ninebot", latitude: -33.88450, longitude: 151.20110, fuelPercentage: 65, type: "Scooter"),
        Vehicle(id: "XIAOMI_SCOOTER_1", brand: "Xiaomi", model: "Mi Scooter Pro", latitude: -33.88310, longitude: 151.19820, fuelPercentage: 50, type: "Scooter"),
        Vehicle(id: "APOLLO_GHOST_1", brand: "Apollo", model: "Ghost", latitude: -33.88600, longitude: 151.19660, fuelPercentage: 75, type: "Scooter")
    ]

    private var filteredVehicles: [Vehicle] {
        selectedType == "All" ? vehicles : vehicles.filter { $0.type == selectedType }
    }

    var body: some View {
        NavigationView {
            VStack {
                Picker("View Mode", selection: $showMap) {
                    Text("List").tag(false)
                    Text("Map").tag(true)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                Picker("Vehicle Type", selection: $selectedType) {
                    ForEach(vehicleTypes, id: \.self) { Text($0) }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                if showMap {
                    MapView(
                        vehicles: filteredVehicles,
                        selectedVehicle: $selectedVehicle,
                        showLoginPrompt: $showLoginPrompt
                    )
                } else {
                    VehicleListView(
                        vehicles: filteredVehicles,
                        isLoggedIn: isLoggedIn,
                        bookingStore: bookingStore,
                        selectedVehicle: $selectedVehicle,
                        showLoginPrompt: $showLoginPrompt
                    )
                }
            }
            .navigationTitle("Nearby Vehicles")
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
