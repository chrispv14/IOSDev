import Foundation

struct Booking: Identifiable, Codable {
    var id = UUID()
    let vehicle: Vehicle
    let pickupDate: Date
    let returnDate: Date
}
