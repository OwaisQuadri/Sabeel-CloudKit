//
//  View+Ext.swift
//  Sabeel
//
//  Created by Owais on 2023-08-10.
//
// PROJECT REUSABLE

import SwiftUI

extension View {
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
     
    
    func playHaptic(_ type: UINotificationFeedbackGenerator.FeedbackType) {
            let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
}

