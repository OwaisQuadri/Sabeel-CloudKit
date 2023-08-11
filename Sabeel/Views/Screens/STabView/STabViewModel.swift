//
//  STabViewModel.swift
//  Sabeel
//
//  Created by Owais on 2023-08-10.
//

import Foundation

final class STabViewModel: ObservableObject {
    @Published var isShowingOnboarding: Bool = false
    
    var hasSeenOnboardView: Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultsKey.kHasSeenOnboardingView)
    }
    func startUpChecks() {
        if !hasSeenOnboardView {
            isShowingOnboarding = true
            UserDefaults.standard.set(true, forKey: UserDefaultsKey.kHasSeenOnboardingView)
        }
        CloudKitManager.shared.getUserRecord()
    }
}
