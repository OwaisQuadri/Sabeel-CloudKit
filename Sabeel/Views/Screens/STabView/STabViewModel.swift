//
//  STabViewModel.swift
//  Sabeel
//
//  Created by Owais on 2023-08-10.
//

import Foundation

final class STabViewModel: ObservableObject {
    @Published var isShowingOnboarding: Bool = false
    let kHasSeenOnboardingView = "hasSeenOnboardingView"
    
    var hasSeenOnboardView: Bool {
        return UserDefaults.standard.bool(forKey: kHasSeenOnboardingView)
    }
    func startUpChecks() {
        if !hasSeenOnboardView {
            isShowingOnboarding = true
            UserDefaults.standard.set(true, forKey: kHasSeenOnboardingView)
        }
    }
}
