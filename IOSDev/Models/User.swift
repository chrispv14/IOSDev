import Foundation

struct User: Identifiable, Codable, Equatable {
    var id = UUID()
    let email: String
    let username: String
    var password: String
    let licenseNumber: String
    let dateOfBirth: Date
}
