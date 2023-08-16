//
//  MasjidChangeRequestVM.swift
//  Sabeel
//
//  Created by Owais on 2023-08-10.
//

import SwiftUI
import CloudKit

@MainActor final class MasjidChangeRequestVM: ObservableObject {
    
    @Published var showNotEditedAlert                           = false
    @Published var selectedChangeRequest: MasjidChangeRequest?  = nil
    @Published var name                 : String                = ""
    @Published var address              : String                = ""
    @Published var email                : String                = ""
    @Published var phoneNumber          : String                = ""
    @Published var website              : String                = ""
    @Published var prayerTimes          : PrayerTimes           = PrayerTimes(fajr: "", dhuhr: "", asr: "", maghrib: "", isha: "", juma: [])
    @Published var isFromChangeRequest  : Bool                  = false
    
    @Binding var isShowingThisView: Bool
    
    
    func dismiss(for masjidManager: MasjidManager) {
        withAnimation(.easeInOut) {
            isShowingThisView = false
            emptySelectionsIfNotConfirmed(for: masjidManager)
        }
    }
    
    
    func onAppear(with masjidManager: MasjidManager) {
        getChangeRequest(for: masjidManager)
    }
    
    
    func createNewChangeRequest(using masjidManager: MasjidManager) {
        // create changeRequest
        guard let masjid = masjidManager.selectedMasjid else {
            alertItem = AlertContext.masjidDNE
            return
        }
        guard CloudKitManager.shared.isSignedIntoiCloud else {
            alertItem = AlertContext.noUserRecord
            return
        }
        let newPrayerTimes = PrayerTimes(fajr: prayerTimes.fajr, dhuhr: prayerTimes.dhuhr, asr: prayerTimes.asr, maghrib: prayerTimes.maghrib, isha: prayerTimes.isha, juma: prayerTimes.juma)
        let newChangeRequest = MasjidChangeRequest(name: name, email: email, address: address, phoneNumber: phoneNumber, website: website, prayerTimes: newPrayerTimes, location: masjid.location )
        // upload both to cloudkit
        masjid.record[Masjid.kChangeRequest] = newChangeRequest.record.reference()
        Task {
            do {
                _ = try await CloudKitManager.shared.batchSave(records: [newPrayerTimes.record, newChangeRequest.record, masjid.record])
                alertItem = AlertContext.changeRequestCreationSuccess
            }
            catch {
                alertItem = AlertContext.changeRequestCreationFailure
            }
        }
    }
    
    
    func getChangeRequest(for masjidManager: MasjidManager) {
        populateBasedOn(masjidManager)
        
    }
    
    
    func populateBasedOn(_ masjidManager: MasjidManager) {
        guard let masjid = masjidManager.selectedMasjid else {
            alertItem = AlertContext.masjidDNE
            return
        }
        if let changeRequestID = masjid.changeRequest?.recordID {
            Task {
                do {
                    // populate using changeRequest
                    let changeRequests = try await CloudKitManager.shared.get(object: .changeRequest, from: changeRequestID) as [MasjidChangeRequest]
                    if !changeRequests.isEmpty {
                        let changeRequest = changeRequests[0]
                        alertItem = AlertContext.promptToVoteUpdate
                        name        = changeRequest.name
                        address     = changeRequest.address
                        email       = changeRequest.email!
                        phoneNumber = changeRequest.phoneNumber!
                        website     = changeRequest.website!
                        
                        // get prayertimes too
                        prayerTimes = try await CloudKitManager.shared.get(object: .prayerTimes, from: changeRequest.prayerTimes.recordID)[0] as PrayerTimes
                    }
                    
                } catch {
                    alertItem = AlertContext.genericErrorAlert
                }
            }
        } else {
            name        = masjid.name
            address     = masjid.address
            email       = masjid.email
            phoneNumber = masjid.phoneNumber
            website     = masjid.website
            
            // get prayertimes
            Task {
                do {
                    prayerTimes = try await CloudKitManager.shared.get(object: .prayerTimes, from: masjid.prayerTimes.recordID)[0] as PrayerTimes
                } catch {
                    alertItem = AlertContext.genericErrorAlert
                }
            }
        }
        
        
    }
    
    // MARK: - Accept / Deny Change Request
    func acceptChangeRequest(with masjidManager: MasjidManager) {
        
        guard
            let masjid = masjidManager.selectedMasjid,
            let changeRequestReference = masjid.changeRequest
        else {
            alertItem = AlertContext.masjidDNE
            return
        }
        Task {
            do {
                // get user ID
                guard let userRecord = CloudKitManager.shared.userRecord else {
                    alertItem = AlertContext.noUserRecord
                    emptySelectionsIfNotConfirmed(for: masjidManager)
                    return
                }
                // get change request from reference
                let changeRequestObjects = try await CloudKitManager.shared.get(object: .changeRequest, from: changeRequestReference.recordID) as [MasjidChangeRequest]
                if !changeRequestObjects.isEmpty {
                    let changeRequestObject = changeRequestObjects[0]
                    
                    if changeRequestObject.userRecordIdVotedYes.contains(userRecord.reference()) {
                        alertItem = AlertContext.votedAlready
                        emptySelectionsIfNotConfirmed(for: masjidManager)
                        return
                    }
                    // add user to list
                    let userVotesList = (changeRequestObject.userRecordIdVotedYes + [userRecord.reference()])
                    changeRequestObject.record[MasjidChangeRequest.kuserRecordsThatVotedYes] = userVotesList
                    if userVotesList.count >= changeRequestObject.votesToPass {
                        // if there are, update masjid with changerequest values and CKM update
                        masjid.record[Masjid.kName]            = changeRequestObject.name
                        masjid.record[Masjid.kEmail]           = changeRequestObject.email
                        masjid.record[Masjid.kAddress]         = changeRequestObject.address
                        masjid.record[Masjid.kPhoneNumber]     = changeRequestObject.phoneNumber
                        masjid.record[Masjid.kWebsite]         = changeRequestObject.website
                        masjid.record[Masjid.kPrayerTimes]     = changeRequestObject.prayerTimes
                        masjid.record[Masjid.kIsConfirmed]     = true
                        _ = try await CloudKitManager.shared.batchDel([changeRequestObject])
                        masjid.record[Masjid.kChangeRequest]   = nil
                        _ = try await CloudKitManager.shared.save([masjid])
                    } else {
                        _ = try await CloudKitManager.shared.save([changeRequestObject])
                    }}
                else {
                    alertItem = AlertContext.genericUnableToVote
                    emptySelectionsIfNotConfirmed(for: masjidManager)
                    return
                }
                alertItem = AlertContext.votedSuccess
                emptySelectionsIfNotConfirmed(for: masjidManager)
            }
            catch {
                alertItem = AlertContext.genericUnableToVote
                emptySelectionsIfNotConfirmed(for: masjidManager)
            }
            
        }
    }
    
    
    func denyChangeRequest(with masjidManager: MasjidManager) {
        guard
            var masjid = masjidManager.selectedMasjid,
            let changeRequestReference = masjid.changeRequest
        else {
            alertItem = AlertContext.masjidDNE
            emptySelectionsIfNotConfirmed(for: masjidManager)
            return
        }
        Task {
            do {
                // get user ID
                guard let userRecord = CloudKitManager.shared.userRecord else {
                    alertItem = AlertContext.noUserRecord
                    emptySelectionsIfNotConfirmed(for: masjidManager)
                    return
                }
                // get request from ref
                let changeRequestObjects = try await CloudKitManager.shared.get(object: .changeRequest, from: changeRequestReference.recordID) as [MasjidChangeRequest]
                if !changeRequestObjects.isEmpty {
                    let changeRequestObject = changeRequestObjects[0]
                    if changeRequestObject.userRecordIdVotedYes.contains(userRecord.reference()) {
                        alertItem = AlertContext.votedAlready
                        emptySelectionsIfNotConfirmed(for: masjidManager)
                        return
                    }
                    // add user to list
                    let userVotesList = (changeRequestObject.userRecordIdVotedNo + [userRecord.reference()])
                    changeRequestObject.record[MasjidChangeRequest.kuserRecordsThatVotedNo] = userVotesList
                    if userVotesList.count >= changeRequestObject.votesToPass {
                        // if there are, delete the changerequest and put the reference to it in masjid.record to nil
                        _ = try await CloudKitManager.shared.batchDel([changeRequestObject])
                        masjid.record[Masjid.kChangeRequest] = nil
                        if masjid.isConfirmed {
                            _ = try await CloudKitManager.shared.save([masjid])
                        } else {
                            _ = try await CloudKitManager.shared.batchDel([masjid])
                        }
                    }
                    else {
                        _ = try await CloudKitManager.shared.save([changeRequestObject])
                    }
                }
                emptySelectionsIfNotConfirmed(for: masjidManager)
            }
            catch {
                alertItem = AlertContext.genericUnableToVote
                emptySelectionsIfNotConfirmed(for: masjidManager)
            }
        }
    }
    
    private func emptySelectionsIfNotConfirmed(for masjidManager: MasjidManager){
        if let masjid = masjidManager.selectedMasjid , !masjid.isConfirmed {
            masjidManager.selectedMasjid = nil
            selectedChangeRequest = nil
        }
    }
    
    
    @Published var isLoading: Bool = false
    @Binding var alertItem: AlertItem?
    private func showLoadingView() { isLoading = true }
    private func hideLoadingView() { isLoading = false }
    
    func load(completion: () -> Void) {
        showLoadingView()
        completion()
        hideLoadingView()
    }
    
    init(showChangeTimingsView: Binding<Bool>, _ alertItem: Binding<AlertItem?>) {
        self._alertItem = alertItem
        self._isShowingThisView = showChangeTimingsView
    }
}

