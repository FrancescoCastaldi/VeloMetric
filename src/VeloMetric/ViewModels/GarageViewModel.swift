import Foundation
import Combine

@MainActor
class GarageViewModel: ObservableObject {
    @Published var bikes: [Bike] = []
    @Published var components: [Component] = []
    @Published var isLoading = false
    
    init() {
        loadMockData()
    }
    
    func loadMockData() {
        isLoading = true
        // Mock a network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let mockBike = Bike(name: "Trek Madone SLR 9", brand: "Trek", type: .road, totalMileage: 4500)
            self.bikes = [mockBike]
            
            self.components = [
                Component(bikeId: mockBike.id, name: "Dura-Ace 12v", type: .chain, currentMileage: 2800, maxLifespanMileage: 3000, dateInstalled: Date().addingTimeInterval(-86400 * 90)),
                Component(bikeId: mockBike.id, name: "GP5000 S TR", type: .rearTire, currentMileage: 4000, maxLifespanMileage: 4500, dateInstalled: Date().addingTimeInterval(-86400 * 120)),
                Component(bikeId: mockBike.id, name: "Dura-Ace Pads", type: .brakePads, currentMileage: 1500, maxLifespanMileage: 5000, dateInstalled: Date().addingTimeInterval(-86400 * 40)),
                Component(bikeId: mockBike.id, name: "Dura-Ace Cassette", type: .cassette, currentMileage: 6000, maxLifespanMileage: 15000, dateInstalled: Date().addingTimeInterval(-86400 * 200))
            ]
            self.isLoading = false
        }
    }
    
    func components(for bike: Bike) -> [Component] {
        return components.filter { $0.bikeId == bike.id }
    }
    
    // In the future: Add methods to addRide, addComponent, updating Firebase.
}
