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
    
    
    var alert: Alert { Alert(title: title, message: message, dismissButton: dismissButton) }
    
}

extension AlertItem {
    
    init(_ titleString: String, _ messageString: String, _ dismissBtnString: String) {
        self.title          =          Text(titleString)
        self.message        =          Text(messageString)
        self.dismissButton  = .default(Text(dismissBtnString))
    }
    
}

struct AlertContext {
    // MARK - Profile Alerts
    static let invalidProfile = AlertItem("Unable to save", "Please ensure that the fields are not blank,\nthe username should not be more than 20 characters,\nand the username should only include letters and numbers", "Dismiss")
    
    static let noUserRecord = AlertItem(
        "No User Record",
        "You must log into iCloud on your phone in order to utilize your Sabeel Profile. Please log in on your iCloud Settings.",
        "Dismiss"
    )
    
    static let accountCreatedSuccessfully = AlertItem(
        "Success",
        "Account Created Successfully!",
        "OK"
    )
    
    static let unableToCreateProfile = AlertItem(
        "Error",
        "Unable to Create Profile",
        "Dismiss"
    )
    
    static let unableToGetProfile = AlertItem(
        "Error",
        "Unable to Get Profile",
        "Dismiss"
    )
    
    static let updateProfileSuccess = AlertItem(
        "Profile Update Success!",
        "Your Sabeel Profile was saved successfully",
        "Nice!"
    )
    
    static let updateProfileFailure = AlertItem(
        "Unable to Save Profile",
        "We were unable to save your profile at this time, Please try again later",
        "Okay"
    )
    
    // MARK: - Generic Errors
    static let genericErrorAlert = AlertItem(
        "Error",
        "Something went wrong",
        "Dismiss"
    )
    
    static func genericErrorAlert(for err: Error) -> AlertItem {
        AlertItem(
            "Error",
            err.localizedDescription,
            "Dismiss"
        )
    }
    
    // MARK: - AlertContext Template
    static let name = AlertItem(
        "",
        "",
        ""
    )
}
