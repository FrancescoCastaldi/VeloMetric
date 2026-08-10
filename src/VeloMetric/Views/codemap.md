# src/VeloMetric/Views/

## Responsibility
Contains all the SwiftUI visual components, layouts, and user interactions. This layer is strictly responsible for rendering state and capturing user input.

## Design Patterns
- **Declarative UI**: Built entirely with SwiftUI.
- **Glassmorphism Aesthetic**: Implements a dark, blurred, high-contrast aesthetic using custom modifiers and ZStacks.
- **Component-Based Architecture**: Views are broken down into reusable sub-views (e.g., a generic component card).

## Data & Control Flow
Views read state from the `GarageViewModel` via `@ObservedObject` or `@EnvironmentObject`. They do not mutate data directly; instead, they call intent functions on the ViewModel.

## Integration Points
- **Consumes**: `GarageViewModel` for state.
- **Key Files**:
  - `DashboardView.swift`: Main entry point with summary metrics.
  - `BikeGarageView.swift`: Detailed view for managing individual bikes and components.
