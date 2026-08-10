import Foundation

struct Component: Identifiable, Codable, Hashable {
    var id: String = UUID().uuidString
    var bikeId: String
    var name: String
    var type: ComponentType
    var currentMileage: Double
    var maxLifespanMileage: Double
    var dateInstalled: Date
    
    enum ComponentType: String, Codable, CaseIterable {
        case chain = "Chain"
        case cassette = "Cassette"
        case frontTire = "Front Tire"
        case rearTire = "Rear Tire"
        case brakePads = "Brake Pads"
        case bottomBracket = "Bottom Bracket"
    }
    
    var wearPercentage: Double {
        return min((currentMileage / maxLifespanMileage), 1.0)
    }
    
    var needsReplacement: Bool {
        return wearPercentage >= 0.9
    }
}
