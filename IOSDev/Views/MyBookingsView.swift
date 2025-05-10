//
//  MyBookingsView.swift
//  IOSDev
//
//  Created by Chris Patrik Balquiedra Veneracion on 10/5/2025.
//


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
                .onDelete(perform: deleteBooking)
            }
            .navigationTitle("My Bookings")
        }
    }
    
    private func deleteBooking(at offsets: IndexSet) {
        bookingStore.bookings.remove(atOffsets: offsets)
    }
}
