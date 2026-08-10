# Firebase Integration for VeloMetric MVP

To connect the VeloMetric Xcode project to Firebase, follow these steps:

1. **Create Firebase Project**:
   - Go to [Firebase Console](https://console.firebase.google.com).
   - Create a new project: `VeloMetric`.
   - Enable **Firestore Database** (Start in Test Mode for development).
   - Enable **Authentication** (Email/Password).

2. **Register iOS App**:
   - Add an iOS app to the Firebase project.
   - Enter your iOS Bundle ID (e.g., `com.yourdomain.VeloMetric`).
   - Download the `GoogleService-Info.plist` file.

3. **Add to Xcode**:
   - Drag `GoogleService-Info.plist` into your Xcode project (inside the `VeloMetric` folder).
   - Use Swift Package Manager (File > Add Packages...) and search for `https://github.com/firebase/firebase-ios-sdk`.
   - Add `FirebaseFirestore`, `FirebaseAuth`, and `FirebaseCrashlytics`.

4. **Initialize Firebase in App**:
   ```swift
   import SwiftUI
   import FirebaseCore

   class AppDelegate: NSObject, UIApplicationDelegate {
     func application(_ application: UIApplication,
                      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
       FirebaseApp.configure()
       return true
     }
   }

   @main
   struct VeloMetricApp: App {
     @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

     var body: some Scene {
       WindowGroup {
         DashboardView()
       }
     }
   }
   ```
