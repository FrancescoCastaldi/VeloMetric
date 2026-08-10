# src/VeloMetric/ViewModels/

## Responsibility
Acts as the central state management and business logic layer for the application. It bridges the gap between the static data `Models` and the reactive `Views`.

## Design Patterns
- **MVVM (Model-View-ViewModel)**: Decouples UI from data processing.
- **ObservableObject**: Leverages Swift's Combine framework (`@Published`) to automatically trigger UI updates when data changes.
- **Dependency Injection (Future)**: Currently uses hardcoded mock data, but is structured to accept Firebase services in the future.

## Data & Control Flow
1. `GarageViewModel` initializes with mock data.
2. SwiftUI views observe `@Published` properties (e.g., `bikes`).
3. When a user logs a ride (future feature), the ViewModel updates the mileage of the specific bike's components.
4. The `@Published` wrapper triggers a view re-render.

## Integration Points
- **Consumes**: `Bike`, `Component`, `Ride` (from `Models/`).
- **Consumed by**: `DashboardView`, `BikeGarageView` (injected via `@StateObject` or `@ObservedObject`).
