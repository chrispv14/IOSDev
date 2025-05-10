import SwiftUI

struct MyBookingsView: View {
    @EnvironmentObject var bookingStore: BookingStore

    var body: some View {
        NavigationView {
            List {
                ForEach(bookingStore.bookings) { booking in
                    VStack(alignment: .leading) {
                        Text("\(booking.vehicle.brand) \(booking.vehicle.model)")
                            .font(.headline)
                        Text("Pickup: \(booking.pickupDate, style: .date)")
                        Text("Return: \(booking.returnDate, style: .date)")
                    }
                }
                .onDelete(perform: bookingStore.deleteBooking)
            }
            .navigationTitle(Text("My Bookings"))
        }
    }
}
