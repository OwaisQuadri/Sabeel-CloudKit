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
    
    private let kIsCreatingNewProfile = "isCreatingNewProfile"
    
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
        
        CKContainer.default().fetchUserRecordID { recordId, err in
            guard let recordId = recordId, err == nil else {
                self.alertItem = AlertItem("recordId", err?.localizedDescription ?? "error" , "ok")
                return
            }
            // get userrecord from pub db
            CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordId) { userRecord, err in
                guard let userRecord = userRecord, err == nil else {
                    self.alertItem = AlertItem("userRecord", err?.localizedDescription ?? "error" , "ok")
                    return
                }
                // create reference on UserRecord to the SabeelProfile we created
                userRecord["userProfile"] = CKRecord.Reference(recordID: profileRecord.recordID, action: .none)
                // honestly dont ever do .deleteself
                
                // create operation to save user and profile
                let operation = CKModifyRecordsOperation(recordsToSave: [userRecord,profileRecord])
                operation.modifyRecordsCompletionBlock = {recordsToSave, _, err in // _=deletedRecordIds
                    guard let savedRecords = recordsToSave, err == nil else {
                        self.alertItem = AlertItem("savedRecords", err?.localizedDescription ?? "error" , "ok")
                        return
                    }
                    // print the saved records
                    print(savedRecords)
                    self.alertItem = AlertItem("Success", "\(savedRecords)" , "sick!!")
                }
                // add operation to db
                CKContainer.default().publicCloudDatabase.add(operation) // its like task.resume() to fire off operation
                
            }
        }
    }
    
    func getProfile() {
        // need user id to
        CKContainer.default().fetchUserRecordID { recordId, err in
            guard let recordId = recordId, err == nil else {
                self.alertItem = AlertItem("recordId", err?.localizedDescription ?? "error" , "ok")
                return
            }
            // get user record to
            CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordId) { userRecord, err in
                guard let userRecord = userRecord, err == nil else {
                    self.alertItem = AlertItem("userRecord", err?.localizedDescription ?? "error" , "ok")
                    return
                }
                // grab reference from that
                let profileReference = userRecord["userProfile"] as! CKRecord.Reference
                let profileRecordID = profileReference.recordID
                
                CKContainer.default().publicCloudDatabase.fetch(withRecordID: profileRecordID) { profileRecord, err in
                    guard let profileRecord = profileRecord, err == nil else {
                        self.alertItem = AlertItem("profileRecord", err?.localizedDescription ?? "error" , "ok")
                        return
                    }
                    // now i have my profile record
                    DispatchQueue.main.async { [self] in
                        // update UI on main thread
                        // we can set the "isCreatingNewProfile" UserDefaults key to false
                        UserDefaults.standard.set(false, forKey: kIsCreatingNewProfile)
                        isCreatingNewProfile = false
                        let profile                         = SabeelProfile(record: profileRecord)
                        name                                = profile.name
                        handle                              = profile.username
                        CloudKitManager.shared.userProfile  = profile
                        
                    }
                }
            }
        }
    }
}
