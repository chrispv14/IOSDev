import SwiftUI

struct MyBookingsView: View {
    @EnvironmentObject var bookingStore: BookingStore
    @AppStorage("currentUserEmail") private var currentUserEmail = ""
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    var body: some View {
        NavigationView {
            if !isLoggedIn || currentUserEmail.isEmpty {
                VStack(spacing: 20) {
                    Text("You must be logged in to view your bookings.")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()

                    Image(systemName: "lock.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                }
                .navigationTitle("My Bookings")
            } else {
                List {
                    ForEach(bookingStore.bookings.filter { $0.userEmail == currentUserEmail }) { booking in
                        HStack(spacing: 16) {
                            Image(booking.vehicle.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 50)
                                .cornerRadius(8)
                                .shadow(radius: 2)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(booking.vehicle.brand) \(booking.vehicle.model)")
                                    .font(.headline)
                                Text("Pickup: \(booking.pickupDate.formatted(date: .abbreviated, time: .shortened))")


                                Text("Return: \(booking.returnDate.formatted(date: .abbreviated, time: .shortened))")

                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete { offsets in
                        bookingStore.deleteBooking(at: offsets, for: currentUserEmail)
                    }
                }
                .navigationTitle("My Bookings")
            }
        }
    }
}
