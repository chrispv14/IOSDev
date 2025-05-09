//
//  ContentView.swift
//  IOSDev
//
//  Created by Chris Patrik Balquiedra Veneracion on 2/5/2025.
//

import SwiftUI
import MapKit

struct Vehicle: Identifiable, Codable, Equatable {
    var id = UUID()
    let brand: String
    let model: String
    let latitude: Double
    let longitude: Double
    let fuelPercentage: Int
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct Booking: Identifiable, Codable {
    var id = UUID()
    let vehicle: Vehicle
    let pickupDate: Date
    let returnDate: Date
}

class BookingStore: ObservableObject {
    @Published var bookings: [Booking] = [] {
        didSet {
            if let encoded = try? JSONEncoder().encode(bookings) {
                UserDefaults.standard.set(encoded, forKey: "bookings")
            }
        }
    }
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "booking"),
           let decoded = try? JSONDecoder().decode([Booking].self, from: data) {
            bookings = decoded
        }
    }
    
    func addBooking(_ booking: Booking) {
        bookings.append(booking)
    }
}

struct ContentView: View {
    @StateObject private var bookingStore = BookingStore()
    
    var body: some View {
        TabView {
            MyBookingsView()
                .environmentObject(bookingStore)
                .tabItem {
                    Label("My Bookings", systemImage: "calendar")
                }
            
            CarsNearMeView()
                .environmentObject(bookingStore)
                .tabItem {
                    Label("Cars Near Me", systemImage: "car.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}

struct MyBookingsView: View {
    @EnvironmentObject var bookingStore: BookingStore
    
    var body: some View {
        NavigationView {
            List(bookingStore.bookings) { booking in
                VStack(alignment: .leading) {
                    Text("\(booking.vehicle.brand) \(booking.vehicle.model)")
                        .font(.headline)
                    Text("Pickup: \(booking.pickupDate, style: .date)")
                    Text("Return: \(booking.returnDate, style: .date)")
                }
            }
            .navigationTitle(Text("My Bookings"))
        }
    }
}

struct CarsNearMeView: View {
    @EnvironmentObject var bookingStore: BookingStore
    @State private var showMap = false
    @State private var selectedVehicle: Vehicle?
    @State private var showBookingSheet = false
    
    // Demo vehicles for the app
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
                
                if showMap == true {
                    // Need to add code for the map view
                } else {
                    List(vehicles) { vehicle in
                        Button(action: {
                            selectedVehicle = vehicle
                            showBookingSheet.toggle()
                        }) {
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

struct MapView: View {
    // This is where we'll write the code for the map view in CarsNearby.
    var body: some View {
        
    }
}

struct NewBookingView: View {
    let vehicle: Vehicle
    let onConfirm: (Booking) -> Void
    
    @Environment(\.dismiss) var dismiss
    @State private var pickupDate = Date()
    @State private var returnDate = Date().addingTimeInterval(60 * 60 * 24)
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Vehicle")) {
                    Text("\(vehicle.brand) \(vehicle.model)")
                    Text("Fuel: \(vehicle.fuelPercentage)%")
                }
                
                Section(header: Text("Dates")) {
                    DatePicker("Pickup Data", selection: $pickupDate, displayedComponents: .date)
                    DatePicker("Return Date", selection: $returnDate, displayedComponents: .date)
                }
                
                Section {
                    Button("Confirm Booking") {
                        let booking = Booking(vehicle: vehicle, pickupDate: pickupDate, returnDate: returnDate)
                        onConfirm(booking)
                        dismiss()
                    }
                }
            }
            .navigationTitle("New Booking")
        }
    }
}

struct SettingsView: View {
    @AppStorage("username") private var username = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("User Settings")) {
                    TextField("Username", text: $username)
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    ContentView()
}
