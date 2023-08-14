//
//  STabViewModel.swift
//  Sabeel
//
//  Created by Owais on 2023-08-10.
//

import SwiftUI

extension STabView {
    final class STabViewModel: ObservableObject {
        @AppStorage(UserDefaultsKey.kHasSeenOnboardingView) var hasSeenOnboardView = false { didSet { isShowingOnboarding = hasSeenOnboardView } }
        
        @Published var tab = Tab.mapView
        @Published var isShowingOnboarding: Bool = false
        
        func startUpChecks() async {
            if !hasSeenOnboardView {
                hasSeenOnboardView = true
            }
            try? await CloudKitManager.shared.getUserRecord()
        }
    }
    
    enum Tab: String, CaseIterable, Identifiable {
        case feedView, mapView, profileView
        
        var id: Self { self }
    }
}
