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
    @State var screenstate : AppScreenState
    private let app = MainViewModel()
    var isOnboardingSeen : Bool
    init() {
        FirebaseApp.configure()
        self.isOnboardingSeen = UserDefaults.standard.bool(forKey: "isOnboardingSeen")
        switch isOnboardingSeen {
        case true:
            self.screenstate = .main
        case false:
            self.screenstate = .onboarding
        }
    }
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
