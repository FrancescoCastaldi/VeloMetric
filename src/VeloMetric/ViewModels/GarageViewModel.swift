import Foundation
import Combine
import FirebaseFirestore

@MainActor
class GarageViewModel: ObservableObject {
    @Published var bikes: [Bike] = []
    @Published var components: [Component] = []
    @Published var rides: [Ride] = []
    @Published var isLoading = false
    @Published var isSyncedWithCloud = false
    @Published var errorMessage: String?
    
    private let firestoreService = FirestoreService()
    private var bikeListener: ListenerRegistration?
    private var componentListener: ListenerRegistration?
    private var rideListener: ListenerRegistration?
    private var currentUserId: String?
    
    init() {
        loadMockData()
    }
    
    func setupCloudSync(userId: String) {
        guard currentUserId != userId else { return }
        self.currentUserId = userId
        self.isLoading = true
        
        bikeListener?.remove()
        componentListener?.remove()
        rideListener?.remove()
        
        bikeListener = firestoreService.listenBikes(userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let cloudBikes):
                    if !cloudBikes.isEmpty {
                        self?.bikes = cloudBikes
                        self?.isSyncedWithCloud = true
                    } else if let bikes = self?.bikes, !bikes.isEmpty {
                        for bike in bikes {
                            Task {
                                try? await self?.firestoreService.saveBike(bike, userId: userId)
                            }
                        }
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
        
        componentListener = firestoreService.listenComponents(userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cloudComponents):
                    if !cloudComponents.isEmpty {
                        self?.components = cloudComponents
                        self?.isSyncedWithCloud = true
                        NotificationService.shared.checkAndNotifyComponentWear(components: cloudComponents)
                    } else if let components = self?.components, !components.isEmpty {
                        for comp in components {
                            Task {
                                try? await self?.firestoreService.saveComponent(comp, userId: userId)
                            }
                        }
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
        
        rideListener = firestoreService.listenRides(userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cloudRides):
                    self?.rides = cloudRides
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func loadMockData() {
        if bikes.isEmpty {
            let mockBike = Bike(name: "Trek Madone SLR 9", brand: "Trek", type: .road, totalMileage: 4500)
            self.bikes = [mockBike]
            
            self.components = [
                Component(bikeId: mockBike.id, name: "Dura-Ace 12v", type: .chain, currentMileage: 2800, maxLifespanMileage: 3000, dateInstalled: Date().addingTimeInterval(-86400 * 90)),
                Component(bikeId: mockBike.id, name: "GP5000 S TR", type: .rearTire, currentMileage: 4000, maxLifespanMileage: 4500, dateInstalled: Date().addingTimeInterval(-86400 * 120)),
                Component(bikeId: mockBike.id, name: "Dura-Ace Pads", type: .brakePads, currentMileage: 1500, maxLifespanMileage: 5000, dateInstalled: Date().addingTimeInterval(-86400 * 40)),
                Component(bikeId: mockBike.id, name: "Dura-Ace Cassette", type: .cassette, currentMileage: 6000, maxLifespanMileage: 15000, dateInstalled: Date().addingTimeInterval(-86400 * 200))
            ]
        }
    }
    
    func components(for bike: Bike) -> [Component] {
        return components.filter { $0.bikeId == bike.id }
    }
    
    func addBike(name: String, brand: String, type: Bike.BikeType, totalMileage: Double) {
        let newBike = Bike(name: name, brand: brand, type: type, totalMileage: totalMileage)
        bikes.append(newBike)
        
        if let userId = currentUserId {
            Task {
                try? await firestoreService.saveBike(newBike, userId: userId)
            }
        }
    }
    
    func deleteBike(at offsets: IndexSet) {
        for index in offsets {
            let bike = bikes[index]
            let bikeComponents = components(for: bike)
            
            bikes.remove(at: index)
            
            if let userId = currentUserId {
                Task {
                    try? await firestoreService.deleteBike(bikeId: bike.id, userId: userId)
                    for comp in bikeComponents {
                        try? await firestoreService.deleteComponent(componentId: comp.id, userId: userId)
                    }
                }
            }
        }
    }
    
    func addComponent(bikeId: String, name: String, type: Component.ComponentType, currentMileage: Double, maxLifespanMileage: Double) {
        let newComponent = Component(bikeId: bikeId, name: name, type: type, currentMileage: currentMileage, maxLifespanMileage: maxLifespanMileage, dateInstalled: Date())
        components.append(newComponent)
        
        if let userId = currentUserId {
            Task {
                try? await firestoreService.saveComponent(newComponent, userId: userId)
            }
        }
    }
    
    func deleteComponent(_ component: Component) {
        if let index = components.firstIndex(where: { $0.id == component.id }) {
            components.remove(at: index)
            if let userId = currentUserId {
                Task {
                    try? await firestoreService.deleteComponent(componentId: component.id, userId: userId)
                }
            }
        }
    }
    
    func replaceComponent(_ component: Component) {
        if let index = components.firstIndex(where: { $0.id == component.id }) {
            components[index].currentMileage = 0
            components[index].dateInstalled = Date()
            let updated = components[index]
            
            if let userId = currentUserId {
                Task {
                    try? await firestoreService.saveComponent(updated, userId: userId)
                }
            }
        }
    }
    
    func logRide(bikeId: String, title: String, distance: Double, date: Date = Date()) {
        let newRide = Ride(bikeId: bikeId, date: date, distance: distance, title: title, source: "Manual")
        rides.insert(newRide, at: 0)
        
        // 1. Update Bike total mileage
        if let bikeIndex = bikes.firstIndex(where: { $0.id == bikeId }) {
            bikes[bikeIndex].totalMileage += distance
            let updatedBike = bikes[bikeIndex]
            
            if let userId = currentUserId {
                Task {
                    try? await firestoreService.saveBike(updatedBike, userId: userId)
                }
            }
        }
        
        // 2. Update components mileage for this bike
        for index in components.indices {
            if components[index].bikeId == bikeId {
                components[index].currentMileage += distance
                let updatedComp = components[index]
                
                if let userId = currentUserId {
                    Task {
                        try? await firestoreService.saveComponent(updatedComp, userId: userId)
                    }
                }
            }
        }
        
        // 3. Save Ride to Cloud
        if let userId = currentUserId {
            Task {
                try? await firestoreService.saveRide(newRide, userId: userId)
            }
        }
    }
    
    deinit {
        bikeListener?.remove()
        componentListener?.remove()
        rideListener?.remove()
    }
}
