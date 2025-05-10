import Foundation
import MapKit

struct Vehicle: Identifiable, Codable, Equatable {
    var id = UUID()
    let brand: String
    let model: String
    let latitude: Double
    let longitude: Double
    let fuelPercentage: Int
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

