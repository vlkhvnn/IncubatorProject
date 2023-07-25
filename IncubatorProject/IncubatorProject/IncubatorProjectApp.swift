//
//  IncubatorProjectApp.swift
//  IncubatorProject
//
//  Created by Alikhan Tangirbergen on 03.07.2023.
//
import SwiftUI
import Firebase

enum AppScreenState {
    case onboarding
    case main
}

@main
struct IncubatorProject: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var screenstate: AppScreenState = {
        let isOnboardingSeen = UserDefaults.standard.bool(forKey: "isOnboardingSeen")
        if isOnboardingSeen {
            return .main
        } else {
            return .onboarding
        }
    }()
    private let app = MainViewModel()
    
    var body: some Scene {
        WindowGroup {
            switch screenstate {
            case .onboarding:
                OnBoardingScreen(screenState: $screenstate)
            case .main:
                WelcomeScreen(ViewModel: app)
            }
        }
    }
}

//MARK: Firebase Initialization
class AppDelegate : NSObject, UIApplicationDelegate {
    var isOnboardingSeen : Bool = false
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        return .noData
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Pass device token to auth.
        Auth.auth().setAPNSToken(deviceToken, type: AuthAPNSTokenType.sandbox)
    }
}
