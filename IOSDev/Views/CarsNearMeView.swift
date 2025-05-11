// CarsNearMeView.swift
import SwiftUI

struct CarsNearMeView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @EnvironmentObject var bookingStore: BookingStore
    @State private var selectedVehicle: Vehicle?
    @State private var showLoginPrompt = false
    @State private var showMap = false

    let vehicles: [Vehicle] = [
        Vehicle(id: "TOYOTA_COROLLA_1", brand: "Toyota", model: "Corolla", latitude: -33.88331, longitude: 151.19951, fuelPercentage: 85),
        Vehicle(id: "FORD_FOCUS_1", brand: "Ford", model: "Focus", latitude: -33.88295, longitude: 151.20464, fuelPercentage: 60),
        Vehicle(id: "TESLA_MODEL3_1", brand: "Tesla", model: "Model 3", latitude: -33.88549, longitude: 151.20289, fuelPercentage: 95),
        Vehicle(id: "MAZDA_CX5_1", brand: "Mazda", model: "CX-5", latitude: -33.88271, longitude: 151.19665, fuelPercentage: 50),
        Vehicle(id: "HYUNDAI_I30_1", brand: "Hyundai", model: "i30", latitude: -33.88033, longitude: 151.19781, fuelPercentage: 70),
        Vehicle(id: "BMW_X3_1", brand: "BMW", model: "X3", latitude: -33.88242, longitude: 151.20090, fuelPercentage: 40)
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
                    VehicleListView(
                        vehicles: vehicles,
                        isLoggedIn: isLoggedIn,
                        bookingStore: bookingStore,
                        selectedVehicle: $selectedVehicle,
                        showLoginPrompt: $showLoginPrompt
                    )
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
