// BookingStore.swift
import Foundation

class BookingStore: ObservableObject {
    @Published var bookings: [Booking] = []

    private let fileName = "bookings.json"

    init() {
        loadBookings()
    }

    private func getFileURL() -> URL {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return url.appendingPathComponent(fileName)
    }

    func loadBookings() {
        let url = getFileURL()
        guard FileManager.default.fileExists(atPath: url.path) else {
            bookings = []
            return
        }

        do {
            let data = try Data(contentsOf: url)
            bookings = try JSONDecoder().decode([Booking].self, from: data)
        } catch {
            print("Failed to load bookings: \(error)")
        }
    }

    func saveBookings() {
        let url = getFileURL()
        do {
            let data = try JSONEncoder().encode(bookings)
            try data.write(to: url)
        } catch {
            print("Failed to save bookings: \(error)")
        }
    }

    func addBooking(_ booking: Booking) {
        bookings.append(booking)
        saveBookings()
    }

    func deleteBooking(at offsets: IndexSet, for userEmail: String) {
        let userBookings = bookings.enumerated().filter { $0.element.userEmail == userEmail }
        for index in offsets {
            let actualIndex = userBookings[index].offset
            bookings.remove(at: actualIndex)
        }
        saveBookings()
    }

    // Booking overlap detection, regardless of user
    func isVehicleAvailable(_ vehicle: Vehicle, from start: Date, to end: Date) -> Bool {
        for booking in bookings {
            if booking.vehicle == vehicle {
                if (start < booking.returnDate && end > booking.pickupDate) {
                    return false
                }
            }
        }
        return true
    }
}
