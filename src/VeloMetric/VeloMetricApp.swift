import SwiftUI

@main
struct VeloMetricApp: App {
    @StateObject private var garageViewModel = GarageViewModel()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                DashboardView()
                    .tabItem {
                        Label("Dashboard", systemImage: "gauge.with.dots.needle.33percent")
                    }
                
                BikeGarageView()
                    .tabItem {
                        Label("Garage", systemImage: "bicycle")
                    }
            }
            .environmentObject(garageViewModel)
            .tint(.green)
        }
    }
}
