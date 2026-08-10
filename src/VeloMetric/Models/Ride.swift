import Foundation

struct Ride: Identifiable, Codable, Hashable {
    var id: String = UUID().uuidString
    var bikeId: String
    var date: Date
    var distance: Double // distance in kilometers
    var title: String
    var source: String // e.g., "Manual", "Strava"
}
