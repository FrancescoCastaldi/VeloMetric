import SwiftUI
import FirebaseCore

@main
struct VeloMetricApp: App {
    @StateObject private var garageViewModel = GarageViewModel()
    @StateObject private var authViewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
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
            .environmentObject(authViewModel)
            .tint(.green)
            .onAppear {
                if !authViewModel.isAuthenticated {
                    authViewModel.signInAnonymously()
                }
            }
        }
    }
}

