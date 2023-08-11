//
//  PersonalInfoViewModel.swift
//  Sabeel
//
//  Created by Owais on 2023-08-10.
//

import Foundation
import CloudKit

final class PersonalInfoViewModel: ObservableObject {
    
    @Published var alertItem: AlertItem?
    @Published var name : String = ""
    @Published var handle : String = ""
    @Published var isSaved : Bool = true
    @Published var isCreatingNewProfile: Bool = true
    
    func startUpChecks() {
        CloudKitManager.shared.getiCloudStatus { status in
            switch status {
                case .success(_):
                    DispatchQueue.main.async {
                        self.alertItem = AlertItem("iCloud logged in!", "Successfully logged in with iCloud.", "OK")
                    }
                case .failure(_):
                    DispatchQueue.main.async {
                        self.alertItem = AlertItem("iCloud Status Issue", "Please visit settings and ensure you are logged in with iCloud", "OK")
                    }
            }
        }
        getProfile()
    }
    
    func saveProfile() {
        guard isValidProfile() else {
            // show alert
            alertItem = AlertContext.invalidProfile
            return
        }
    }
    
    func isValidProfile() -> Bool {
        guard
            !name.isEmpty,
            !handle.isEmpty ,
            handle.count < 20
                //          , handle.contains("[^A-Za-z0-9]")
        else { return false }
        return true
    }
    
    func createProfile() {
        guard isValidProfile() else {
            // show alert
            alertItem = AlertContext.invalidProfile
            return
        }
        // Create CKRecord from profile view
        let createdProfile = SabeelProfile(name: name, username: handle, homeAddress: nil, homeLocation: nil, isPremium: false, prayerStats: PrayerStats())
        guard let createdProfile = createdProfile else {
            self.alertItem = AlertItem("createdProfile", "unable to create profile" , "ok")
            return
        }
        let profileRecord = createdProfile.record
        
        guard let userRecord = CloudKitManager.shared.userRecord else {
            self.alertItem = AlertItem("Error", "User is not signed into iCloud", "Dismiss")
            return
        }
        // create reference on UserRecord to the SabeelProfile we created
        userRecord["userProfile"] = CKRecord.Reference(recordID: profileRecord.recordID, action: .none)
        
        CloudKitManager.shared.createProfile(records: [userRecord,profileRecord]) { res in
            switch res {
                case .success(_):
                    self.alertItem = AlertItem("Success", "Account Created Successfully!" , "Nice")
                case .failure(let err):
                    self.alertItem = AlertItem("savedRecords", err.localizedDescription , "ok")
            }
        }
    }
    
    func getProfile() {
        guard let userRecord = CloudKitManager.shared.userRecord else {
            self.alertItem = AlertItem("Error", "User is not signed into iCloud", "Dismiss")
            return
        }
        // grab reference from that
        guard let profileReference = userRecord["userProfile"] as? CKRecord.Reference else {
            // TODO: show alert
            return
        }
        let profileRecordID = profileReference.recordID
        CloudKitManager.shared.fetchRecord(with: profileRecordID) { res in
            DispatchQueue.main.async { [self] in
                switch res {
                    case .success(let profileRecord):
                        
                        // update UI on main thread
                        // we can set the "isCreatingNewProfile" UserDefaults key to false
                        UserDefaults.standard.set(false, forKey: UserDefaultsKey.kIsCreatingNewProfile)
                        isCreatingNewProfile = false
                        let profile                         = SabeelProfile(record: profileRecord)
                        name                                = profile.name
                        handle                              = profile.username
                        CloudKitManager.shared.userProfile  = profile
                        
                        
                    case .failure(let err):
                        self.alertItem = AlertItem("profileRecord", err.localizedDescription, "Dismiss" )
                }
            }
        }
    }
}
