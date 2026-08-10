# VeloMetric API Reference

This document outlines the core public Swift interfaces available within the `VeloMetric` module.

## Models

### `Bike`
Represents a user's bicycle.
- `id: String`: UUID.
- `name: String`: User-defined name (e.g., "Trek Madone").
- `type: BikeType`: Enum (`.road`, `.gravel`, `.mtb`, `.commute`).
- `totalMileage: Double`: Total km ridden.

### `Component`
Represents a trackable part attached to a `Bike`.
- `currentMileage: Double`: Km ridden with this part.
- `maxLifespanMileage: Double`: Manufacturer recommended lifespan.
- `wearPercentage: Double` (Computed): Returns a value between 0.0 and 1.0.
- `needsReplacement: Bool` (Computed): Returns `true` if `wearPercentage >= 0.9`.

## ViewModels

### `GarageViewModel` (`@MainActor`)
Handles state management for the Garage and Dashboard.
- **Properties**: 
  - `@Published var bikes: [Bike]`
  - `@Published var components: [Component]`
  - `@Published var isLoading: Bool`
- **Methods**:
  - `loadMockData()`: Simulates network fetch.
  - `components(for bike: Bike) -> [Component]`: Filters components belonging to a specific bike.
