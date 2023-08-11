//
//  PersonalInfoViewModel.swift
//  Sabeel
//
//  Created by Owais on 2023-08-10.
//

import SwiftUI
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
                    break
                case .failure(let err):
                    DispatchQueue.main.async {
                        self.alertItem = AlertContext.genericErrorAlert(for: err)
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
            self.alertItem = AlertContext.unableToCreateProfile
            return
        }
        let profileRecord = createdProfile.record
        
        guard let userRecord = CloudKitManager.shared.userRecord else {
            self.alertItem = AlertContext.noUserRecord
            return
        }
        // create reference on UserRecord to the SabeelProfile we created
        userRecord["userProfile"] = CKRecord.Reference(recordID: profileRecord.recordID, action: .none)
        showLoadingView()
        CloudKitManager.shared.createProfile(records: [userRecord,profileRecord]) { res in
            DispatchQueue.main.async { [self] in
                hideLoadingView()
                switch res {
                    case .success(_):
                        alertItem = AlertContext.accountCreatedSuccessfully
                    case .failure(let err):
                        alertItem = AlertContext.genericErrorAlert(for: err)
                }
            }
        }
    }
    
    func getProfile() {
        guard let userRecord = CloudKitManager.shared.userRecord else {
            self.alertItem = AlertContext.noUserRecord
            return
        }
        // grab reference from that
        guard let profileReference = userRecord["userProfile"] as? CKRecord.Reference else { return }
        let profileRecordID = profileReference.recordID
        showLoadingView()
        CloudKitManager.shared.fetchRecord(with: profileRecordID) { res in
            DispatchQueue.main.async { [self] in
                hideLoadingView()
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
                        self.alertItem = AlertContext.genericErrorAlert(for: err)
                }
            }
        }
    }
    
    @Published var isLoading: Bool = false
    private func showLoadingView() { isLoading = true }
    private func hideLoadingView() { isLoading = false }
}
