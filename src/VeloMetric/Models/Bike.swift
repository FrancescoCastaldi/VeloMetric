import Foundation

struct Bike: Identifiable, Codable, Hashable {
    var id: String = UUID().uuidString
    var name: String
    var brand: String
    var type: BikeType
    var totalMileage: Double
    
    enum BikeType: String, Codable, CaseIterable {
        case road = "Road"
        case gravel = "Gravel"
        case mtb = "MTB"
        case commute = "Commute"
    }
}
