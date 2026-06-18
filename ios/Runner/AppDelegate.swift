import UIKit
import Flutter
import GoogleMaps
import FirebaseCore
import FirebaseMessaging

@main
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let firebaseOptions = FirebaseOptions(
      googleAppID: "1:105361803513:ios:28a518665ecc0de1e73a28",
      gcmSenderID: "105361803513"
    )
    firebaseOptions.apiKey = "AIzaSyAr8a9Gtm_2wQaTXZvE-oODUVumMIJBQyk"
    firebaseOptions.projectID = "gosharpsharp-2b165"
    firebaseOptions.storageBucket = "gosharpsharp-2b165.firebasestorage.app"
    firebaseOptions.bundleID = "com.gosharpsharp.rider"
    FirebaseApp.configure(options: firebaseOptions)

    // Required when FirebaseAppDelegateProxyEnabled = false
    Messaging.messaging().delegate = self

    // Load Google Maps API key from bundled .env file
    let envFileName: String
    #if DEBUG
    envFileName = ".env.dev"
    #else
    envFileName = ".env.prod"
    #endif

    var apiKeyProvided = false
    if let path = Bundle.main.path(forResource: envFileName, ofType: nil, inDirectory: "flutter_assets"),
       let content = try? String(contentsOfFile: path, encoding: .utf8) {
      for line in content.components(separatedBy: .newlines) {
        let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.hasPrefix("GOOGLE_MAPS_API_KEY=") {
          let apiKey = trimmed.replacingOccurrences(of: "GOOGLE_MAPS_API_KEY=", with: "")
            .trimmingCharacters(in: .whitespaces)
          if !apiKey.isEmpty {
            GMSServices.provideAPIKey(apiKey)
            apiKeyProvided = true
          }
          break
        }
      }
    }
    if !apiKeyProvided,
       let apiKey = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_MAPS_API_KEY") as? String,
       !apiKey.isEmpty {
      GMSServices.provideAPIKey(apiKey)
    }

    GeneratedPluginRegistrant.register(with: self)

    UNUserNotificationCenter.current().delegate = self
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in }
    application.registerForRemoteNotifications()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // MARK: - APNs token → Firebase
  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    Messaging.messaging().apnsToken = deviceToken
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }

  override func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    print("❌ APNs registration failed: \(error.localizedDescription)")
  }

  // MARK: - MessagingDelegate
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("✅ FCM token: \(fcmToken ?? "nil")")
  }

  // MARK: - UNUserNotificationCenterDelegate
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    if #available(iOS 14.0, *) {
      completionHandler([.banner, .badge, .sound])
    } else {
      completionHandler([.alert, .badge, .sound])
    }
  }

  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    super.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
  }
}
