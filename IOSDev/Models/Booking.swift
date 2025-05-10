import Foundation
struct Booking: Identifiable, Codable {
    var id = UUID()
    let userEmail: String
    let vehicle: Vehicle
    let pickupDate: Date
    let returnDate: Date
}
