import SwiftUI

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
                    DatePicker("Pickup Date", selection: $pickupDate, displayedComponents: .date)
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
