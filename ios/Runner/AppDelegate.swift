import UIKit
import Flutter
import GoogleMaps
import FirebaseCore
import FirebaseMessaging

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Configure Firebase manually with options
    let firebaseOptions = FirebaseOptions(
      googleAppID: "1:105361803513:ios:28a518665ecc0de1e73a28",
      gcmSenderID: "105361803513"
    )
    firebaseOptions.apiKey = "AIzaSyAr8a9Gtm_2wQaTXZvE-oODUVumMIJBQyk"
    firebaseOptions.projectID = "gosharpsharp-2b165"
    firebaseOptions.storageBucket = "gosharpsharp-2b165.firebasestorage.app"
    firebaseOptions.bundleID = "com.gosharpsharp.rider"
    
    FirebaseApp.configure(options: firebaseOptions)
    
    // Search for the asset in the main bundle and its subdirectories
    var envContent: String? = nil
    let envFileName = {
        #if DEBUG
        return ".env.dev"
        #else
        return ".env.prod"
        #endif
    }()

    let searchPaths = [
        "flutter_assets/\(envFileName)",
        "App.framework/flutter_assets/\(envFileName)",
        "Frameworks/App.framework/flutter_assets/\(envFileName)",
        envFileName
    ]

    for relPath in searchPaths {
        if let path = Bundle.main.path(forResource: relPath, ofType: nil) {
            envContent = try? String(contentsOfFile: path, encoding: .utf8)
            if envContent != nil { break }
        }
    }

    var apiKeyProvided = false
    if let content = envContent {
        let lines = content.components(separatedBy: .newlines)
        for line in lines {
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

    // Fallback to Info.plist if asset loading fails or key is missing in .env
    if !apiKeyProvided, let apiKey = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_MAPS_API_KEY") as? String {
        GMSServices.provideAPIKey(apiKey)
    }

    GeneratedPluginRegistrant.register(with: self)

    // Register for push notifications
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: { _, _ in }
      )
    } else {
      let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }
    application.registerForRemoteNotifications()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}