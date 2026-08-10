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
                
                AnalyticsView()
                    .tabItem {
                        Label("Analytics", systemImage: "chart.bar.fill")
                    }
            }
            .environmentObject(garageViewModel)
            .environmentObject(authViewModel)
            .tint(.green)
            .onAppear {
                NotificationService.shared.requestPermission()
                if !authViewModel.isAuthenticated {
                    authViewModel.signInAnonymously()
                } else if let user = authViewModel.user {
                    garageViewModel.setupCloudSync(userId: user.uid)
                }
            }
            .onChange(of: authViewModel.isAuthenticated) { _, isAuth in
                if isAuth, let user = authViewModel.user {
                    garageViewModel.setupCloudSync(userId: user.uid)
                }
            }
        }
    }
}


