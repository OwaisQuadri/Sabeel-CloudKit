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
    
    private var existingProfileRecord: CKRecord? {
        didSet {
            profileContext = .update
        }
    }
    var profileContext: ProfileContext = .create
    
    func startUpChecks() {
        CloudKitManager.shared.getiCloudStatus { status in
            switch status {
                case .success(_):
                    break
                case .failure(let err):
                    onMainThread {
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
        guard let profileRecord = existingProfileRecord else {
            alertItem = AlertContext.unableToGetProfile
            return
        }
        // update fields
        profileRecord[SabeelProfile.kName] = name
        profileRecord[SabeelProfile.kUsername] = handle
        showLoadingView()
        CloudKitManager.shared.save(record: profileRecord) { res in
            onMainThread { [self] in
                hideLoadingView()
                switch res {
                    case .success(_):
                        alertItem = AlertContext.updateProfileSuccess
                    case .failure(_):
                        alertItem = AlertContext.updateProfileFailure
                }
            }
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
        CloudKitManager.shared.batchSave(records: [userRecord,profileRecord]) { res in
            onMainThread { [self] in
                hideLoadingView()
                switch res {
                    case .success(let records):
                        for record in records where record.recordType == SabeelRecordType.profile.rawValue {
                            existingProfileRecord = record
                        }
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
            onMainThread { [self] in
                hideLoadingView()
                switch res {
                    case .success(let record):
                        existingProfileRecord = record
                        // update UI on main thread
                        let profile                         = SabeelProfile(record: record)
                        name                                = profile.name
                        handle                              = profile.username
                        CloudKitManager.shared.userProfile  = profile
                        profileContext = .update
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

enum ProfileContext { case create, update }
