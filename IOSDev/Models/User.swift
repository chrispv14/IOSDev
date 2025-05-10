import Foundation

struct User: Identifiable, Codable, Equatable {
    var id = UUID()
    let email: String
    let username: String
    let password: String
    let licenseNumber: String
    let dateOfBirth: Date
}
