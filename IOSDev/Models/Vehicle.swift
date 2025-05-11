import Foundation
import MapKit

struct Vehicle: Identifiable, Codable, Equatable {
    var id: String
    let brand: String
    let model: String
    let latitude: Double
    let longitude: Double
    let fuelPercentage: Int

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var imageName: String {
        switch model {
        case "Corolla": return "Corolla"
        case "Focus": return "Focus"
        case "Tesla": return "Tesla"
        case "CX-5": return "CX-5"
        case "i30": return "Hyundai"
        case "X3": return "BMW"
        default: return "CarDefault"
        }
    }
}
