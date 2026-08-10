# Repository Atlas: VeloMetric

## Project Responsibility
VeloMetric is an iOS MVP application built with SwiftUI, designed to track road bike component wear and tear. It uses an MVVM (Model-View-ViewModel) architecture and is configured to integrate with Firebase for backend services (Auth, Firestore, Crashlytics).

## System Entry Points
- `Package.swift`: The Swift Package Manager manifest that defines the project structure and dependencies for Xcode.
- `src/VeloMetric/Views/DashboardView.swift`: The main UI entry point containing the primary navigation and overview.
- `docs/index.html`: The promotional landing page deployed on GitHub Pages.

## Directory Map (Aggregated)
| Directory | Responsibility Summary | Detailed Map |
|-----------|------------------------|--------------|
| `src/` | Core application source code containing the SwiftUI app. | [View Map](src/codemap.md) |
| `src/VeloMetric/Models/` | Defines the core data structures (Bike, Component, Ride). | [View Map](src/VeloMetric/Models/codemap.md) |
| `src/VeloMetric/ViewModels/` | Manages state, business logic, and mock data injection. | [View Map](src/VeloMetric/ViewModels/codemap.md) |
| `src/VeloMetric/Views/` | Contains the SwiftUI visual components and layouts. | [View Map](src/VeloMetric/Views/codemap.md) |
| `docs/` | Project documentation, GitHub Pages landing page, and architectural guidelines. | N/A |
| `.github/` | CI/CD pipelines (Swift builds, Pages deploy) and issue/PR templates. | N/A |
