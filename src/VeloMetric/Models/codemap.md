# src/VeloMetric/Models/

## Responsibility
Defines the core domain entities and data structures for the VeloMetric application. These models represent the physical objects being tracked (bikes, components) and the events affecting them (rides).

## Design Patterns
- **Value Types (Structs)**: Utilizes Swift structs for immutability and thread safety.
- **Identifiable & Codable**: Models conform to `Identifiable` for SwiftUI list rendering and `Codable` for future Firebase Firestore serialization.

## Data & Control Flow
Models are passive data containers. They are instantiated by the `GarageViewModel` (currently via mock data) and passed down to the `Views` for rendering.

## Integration Points
- **Consumed by**: `GarageViewModel` (State management), `DashboardView`, `BikeGarageView` (UI).
- **Entities**: 
  - `Bike.swift`: Represents a user's bicycle.
  - `Component.swift`: Represents a part (Chain, Tires, Cassette) with wear tracking.
  - `Ride.swift`: Represents an activity that adds mileage to components.
