<p align="center">
  <img src="https://img.shields.io/badge/iOS-16.0+-blue?style=for-the-badge&logo=apple" alt="iOS 16+">
  <img src="https://img.shields.io/badge/Swift-5.9-orange?style=for-the-badge&logo=swift" alt="Swift 5.9">
  <img src="https://img.shields.io/badge/Firebase-Supported-FFCA28?style=for-the-badge&logo=firebase" alt="Firebase">
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" alt="MIT License">
</p>

# VeloMetric 🚴‍♂️

> *Precision tracking for your road bike's wear and tear.*

VeloMetric is a premium iOS application designed to help cyclists maintain their bikes optimally by tracking the mileage and health of critical components like chains, tires, brake pads, and cassettes. 

---

## 📑 Table of Contents
- [🚀 Features](#-features)
- [🏗️ Architecture & File Structure](#️-architecture--file-structure)
- [💻 Core Components](#-core-components)
- [⚙️ Quickstart / Usage](#️-quickstart--usage)
- [🔗 Dependencies & Data Flow](#-dependencies--data-flow)
- [⚠️ Gotchas & Developer Notes](#️-gotchas--developer-notes)

---

## 🚀 Features
- **🚴 Bike Garage**: Manage multiple setups (Road, Gravel, Commute).
- **⚙️ Component Tracking**: Monitor individual parts with max lifespan thresholds.
- **📊 Wear Dashboard**: Beautiful glassmorphic UI with circular progress rings.
- **☁️ Firebase Sync**: Cross-device sync via Cloud Firestore.
- **🌙 Premium Dark Mode**: OLED-optimized aesthetics with neon accents.

---

## 🏗️ Architecture & File Structure

```text
AppIphone/
├── .github/          # GitHub Actions, Issue Templates, Dependabot
├── docs/             # Technical specs, API docs, Web Landing Page
├── data/             # Mock datasets and component specs
├── src/VeloMetric/   # iOS App Source Code (MVVM)
│   ├── Models/       # Data structures (Bike, Component, Ride)
│   ├── ViewModels/   # State management (GarageViewModel)
│   └── Views/        # SwiftUI Interfaces (DashboardView)
├── Package.swift     # Swift Package Manager manifest
└── README.md
```

VeloMetric follows a strict **MVVM (Model-View-ViewModel)** architectural pattern native to SwiftUI. The `GarageViewModel` acts as the single source of truth, observing data from Firebase and publishing it to reactive SwiftUI Views.

---

## 💻 Core Components

The core logic revolves around calculating wear. Here is how `Component.swift` handles it:

```swift
var wearPercentage: Double {
    return min((currentMileage / maxLifespanMileage), 1.0)
}

var needsReplacement: Bool {
    return wearPercentage >= 0.9
}
```

---

## ⚙️ Quickstart / Usage

To run VeloMetric locally:

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/VeloMetric.git
   ```
2. Open the directory in **Xcode** (thanks to `Package.swift`, Xcode will resolve everything automatically).
3. Select an iOS Simulator (iOS 16.0+) and hit `Cmd + R` to build and run.

---

## 🔗 Dependencies & Data Flow

- **Frontend**: SwiftUI (Apple).
- **Backend**: Firebase iOS SDK (Firestore, Auth, Crashlytics).
- **Data Flow**: `Firebase Firestore -> GarageViewModel (@Published) -> DashboardView (@StateObject)`.

---

## ⚠️ Gotchas & Developer Notes

> [!WARNING]
> You must supply your own `GoogleService-Info.plist` to compile the app with real Firebase integration. See [docs/Firebase/FirebaseIntegration.md](docs/Firebase/FirebaseIntegration.md).

> [!NOTE]
> The current MVP uses a simulated network delay and mock data inside `GarageViewModel.swift` for rapid UI prototyping.
