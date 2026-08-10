# 📱 VeloMetric Source Code (src)

> *The core MVVM engine powering the iOS application.*

This directory contains the entire Swift codebase. We leverage SwiftUI and modern Swift concurrency to deliver a fluid, 60fps experience.

## 📑 Table of Contents
- [🚀 Features](#-features)
- [🏗️ Architecture](#️-architecture)
- [💻 Core Components](#-core-components)

## 🚀 Features
- **Declarative UI**: Built 100% in SwiftUI.
- **Reactive State**: Powered by Combine and `@StateObject`.
- **Mockable Data**: Easy to switch between Mock and Firebase services.

## 🏗️ Architecture
```text
src/VeloMetric/
├── App/          # Entry point (VeloMetricApp.swift)
├── Models/       # Swift structs (Codable, Hashable)
├── ViewModels/   # ObservableObjects bridging UI and Data
└── Views/        # SwiftUI components
```

## 💻 Core Components
The UI is modular. `ComponentCard` inside `DashboardView.swift` handles the complex circular progress ring drawing:

```swift
Circle()
    .trim(from: 0, to: component.wearPercentage)
    .stroke(
        component.needsReplacement ? Color.red : Color.green,
        style: StrokeStyle(lineWidth: 8, lineCap: .round)
    )
```

> [!IMPORTANT]
> When adding new views, ensure they support `.preferredColorScheme(.dark)` as VeloMetric is a dark-mode first application.
