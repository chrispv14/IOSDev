//
//  BookingStore.swift
//  IOSDev
//
//  Created by Chris Patrik Balquiedra Veneracion on 10/5/2025.
//


import Foundation

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
