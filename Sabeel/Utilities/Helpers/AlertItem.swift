//
//  AlertItem.swift
//  Sabeel
//
//  Created by Owais on 2023-08-10.
//
// PROJECT REUSABLE

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
    // MARK: - Generics
    
    static let genericSuccess = AlertItem(
        "Success!",
        "Intended Behaviour Executed Successfully!",
        "OK"
    )
    
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
    
    // MARK: - Masjid Change Request Alerts
    
    static let promptToVoteCreate = AlertItem(
        "Alert",
        "A request exists to create this masjid. Could you please verify and vote on whether the information is accurate? ",
        "OK"
    )
    
    static let promptToVoteUpdate = AlertItem(
        "Alert",
        "A request exists to update this existing masjid. Could you please verify and vote on whether the information is accurate? ",
        "OK"
    )

    static let changeRequestCreationSuccess = AlertItem(
        "Success",
        "Masjid change request created. Your request will be voted on by the community and the Masjid will be updated accordingly.",
        "OK"
    )

    static let changeRequestCreationFailure = AlertItem(
        "Error",
        "Masjid change request failed to initialize. Please try again later.",
        "Dismiss"
    )

    static let votedAlready = AlertItem(
        "Unable to vote",
        "You've voted already!",
        "Dismiss"
    )

    static let genericUnableToVote = AlertItem(
        "Unable to vote",
        "We were unable to process your vote. Please try again later.",
        "Dismiss"
    )

    static let votedSuccess = AlertItem(
        "Success",
        "Thanks, your vote was processed. The Masjid will be updated once all votes are processed",
        "Dismiss"
    )

    // MARK: - Masjid Detail Alerts
    
    static let masjidDNE = AlertItem(
        "Error",
        "There is no masjid selected. Select a masjid and try again.",
        "Dismiss"
    )

    static let unableToSendEmail = AlertItem(
        "Error",
        "There was an issue onpening your preferred email application. Check the email format and try again later.",
        "Dismiss"
    )
    
    static let unableToMakePhoneCall = AlertItem(
        "Error",
        "There was an issue onpening your Phone application. Check the format and try again later.",
        "Dismiss"
    )
    
    static let unableToOpenWebsiteURL = AlertItem(
        "Error",
        "There was an issue onpening your preferred web browsing application. Check the website format and try again later.",
        "Dismiss"
    )


    // MARK: - Profile Alerts
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

}
