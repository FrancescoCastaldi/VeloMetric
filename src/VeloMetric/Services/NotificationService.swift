import Foundation
import UserNotifications

class NotificationService: ObservableObject {
    static let shared = NotificationService()
    
    @Published var isPermissionGranted = false
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                self.isPermissionGranted = granted
            }
        }
    }
    
    func checkAndNotifyComponentWear(components: [Component]) {
        for component in components where component.needsReplacement {
            scheduleWearNotification(for: component)
        }
    }
    
    private func scheduleWearNotification(for component: Component) {
        let content = UNMutableNotificationContent()
        content.title = "⚠️ Component Maintenance Required"
        content.body = "\(component.name) (\(component.type.rawValue)) has reached \(Int(component.wearPercentage * 100))% wear! Consider replacing it soon."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "wear_\(component.id)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
