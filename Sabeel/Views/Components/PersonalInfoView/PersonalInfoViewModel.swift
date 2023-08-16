//
//  PersonalInfoViewModel.swift
//  Sabeel
//
//  Created by Owais on 2023-08-10.
//

import SwiftUI
import CloudKit

@MainActor final class PersonalInfoViewModel: ObservableObject {
    
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
        getProfile()
    }
    
    func saveProfile() {
        guard isValidProfile() else {
            // show alert
            alertItem = AlertContext.invalidProfile
            return
        }
        
        showLoadingView()
        Task {
            do {
                guard let profileRecord = existingProfileRecord else {
                    alertItem = AlertContext.unableToGetProfile
                    return
                }
                // update fields
                profileRecord[SabeelProfile.kName] = name
                profileRecord[SabeelProfile.kUsername] = handle
                
                _ = try await CloudKitManager.shared.batchSave(records: [profileRecord])
                alertItem = AlertContext.updateProfileSuccess
                hideLoadingView()
                
            }
            catch {
                hideLoadingView()
                alertItem = AlertContext.updateProfileFailure
                
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
        guard let createdProfile else {
            self.alertItem = AlertContext.unableToCreateProfile
            return
        }
        
        showLoadingView()
        Task {
            do {
                let profileRecord = createdProfile.record
                
                guard let userRecord = CloudKitManager.shared.userRecord else {
                    self.alertItem = AlertContext.noUserRecord
                    return
                }
                // create reference on UserRecord to the SabeelProfile we created
                userRecord["userProfile"] = CKRecord.Reference(recordID: profileRecord.recordID, action: .none)
                let isSaved = try await CloudKitManager.shared.batchSave(records: [userRecord,profileRecord])
                if isSaved {
                    existingProfileRecord = profileRecord
                    alertItem = AlertContext.accountCreatedSuccessfully
                }
                hideLoadingView()
            }
            catch {
                hideLoadingView()
                alertItem = AlertContext.genericErrorAlert(for: error)
            }
        }
    }
    
    func getProfile() {
        // grab reference from that
        guard let profileRecordID = CloudKitManager.shared.profileRecordID else {
            self.alertItem = AlertContext.noUserRecord
            return
        }
        showLoadingView()
        Task {
            do {
                let profile = try await CloudKitManager.shared.get(object: .profile, from: profileRecordID)[0] as SabeelProfile
                existingProfileRecord = profile.record
                name = profile.name
                handle = profile.username
                CloudKitManager.shared.userProfile  = profile
                profileContext = .update
                hideLoadingView()
            } catch {
                hideLoadingView()
                alertItem = AlertContext.genericErrorAlert(for: error)
            }
        }
    }
    
    @Published var isLoading: Bool = false
    private func showLoadingView() { isLoading = true }
    private func hideLoadingView() { isLoading = false }
}

enum ProfileContext { case create, update }
