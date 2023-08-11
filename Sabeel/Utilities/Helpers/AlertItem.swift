//
//  AlertItem.swift
//  Sabeel
//
//  Created by Owais on 2023-08-10.
//

import SwiftUI
struct AlertItem: Identifiable {
    let id = UUID ()
    var title: Text
    var message: Text
    var dismissButton: Alert.Button
}
extension AlertItem {
    init(_ titleString: String, _ messageString: String, _ dismissBtnString: String) {
        self.title = Text(titleString)
        self.message = Text(messageString)
        self.dismissButton = .default(Text(dismissBtnString))
    }
}

struct AlertContext {
    // MARK - Profile Alerts
    static let invalidProfile = AlertItem(title: Text("Unable to save"), message: Text("Please ensure that the fields are not blank,\nthe username should not be more than 20 characters,\nand the username should only include letters and numbers").foregroundColor(.red), dismissButton: .default(Text("OK")))
}
