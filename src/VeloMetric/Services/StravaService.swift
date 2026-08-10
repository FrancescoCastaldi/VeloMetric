import Foundation
import Combine

class StravaService: ObservableObject {
    @Published var isConnected = false
    @Published var athleteName: String? = nil
    @Published var isSyncing = false
    
    func connectAccount() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isConnected = true
            self.athleteName = "Francesco Castaldi"
        }
    }
    
    func disconnectAccount() {
        self.isConnected = false
        self.athleteName = nil
    }
    
    func fetchLatestActivities(completion: @escaping ([Ride]) -> Void) {
        guard isConnected else {
            completion([])
            return
        }
        
        isSyncing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isSyncing = false
            
            let stravaRides = [
                Ride(bikeId: "", date: Date().addingTimeInterval(-86400 * 2), distance: 68.5, title: "Strava: Gran Fondo Alpine Loop", source: "Strava"),
                Ride(bikeId: "", date: Date().addingTimeInterval(-86400 * 5), distance: 42.0, title: "Strava: Midweek Speed Workout", source: "Strava")
            ]
            completion(stravaRides)
        }
    }
}
