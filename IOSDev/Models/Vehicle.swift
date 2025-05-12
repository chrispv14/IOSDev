import Foundation
import MapKit

struct Vehicle: Identifiable, Codable, Equatable {
    var id: String
    let brand: String
    let model: String
    let latitude: Double
    let longitude: Double
    let fuelPercentage: Int
    var type: String  // Car, Bike, Scooter

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var imageName: String {
        switch brand {
        case "Toyota": return "Corolla"
        case "Ford": return "Focus"
        case "Tesla": return "Tesla"
        case "Mazda": return "CX-5"
        case "Hyundai": return "Hyundai"
        case "BMW": return "BMW"
        case "Yamaha": return "Yamaha"
        case "Giant": return "Giant"
        case "Segway": return "Segway"
        case "Xiaomi": return "Xiaomi"
        case "Apollo": return "Apollo"
        default: return "CarDefault"
        }
    }
}
