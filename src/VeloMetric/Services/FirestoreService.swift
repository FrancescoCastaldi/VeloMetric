import Foundation
import FirebaseFirestore
import Combine

class FirestoreService: ObservableObject {
    private let db = Firestore.firestore()
    
    func listenBikes(userId: String, completion: @escaping (Result<[Bike], Error>) -> Void) -> ListenerRegistration {
        return db.collection("users").document(userId).collection("bikes")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }
                let bikes = documents.compactMap { try? $0.data(as: Bike.self) }
                completion(.success(bikes))
            }
    }
    
    func listenComponents(userId: String, completion: @escaping (Result<[Component], Error>) -> Void) -> ListenerRegistration {
        return db.collection("users").document(userId).collection("components")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }
                let components = documents.compactMap { try? $0.data(as: Component.self) }
                completion(.success(components))
            }
    }
    
    func saveBike(_ bike: Bike, userId: String) async throws {
        try db.collection("users").document(userId).collection("bikes").document(bike.id).setData(from: bike)
    }
    
    func deleteBike(bikeId: String, userId: String) async throws {
        try await db.collection("users").document(userId).collection("bikes").document(bikeId).delete()
    }
    
    func saveComponent(_ component: Component, userId: String) async throws {
        try db.collection("users").document(userId).collection("components").document(component.id).setData(from: component)
    }
    
    func deleteComponent(componentId: String, userId: String) async throws {
        try await db.collection("users").document(userId).collection("components").document(componentId).delete()
    }
}
