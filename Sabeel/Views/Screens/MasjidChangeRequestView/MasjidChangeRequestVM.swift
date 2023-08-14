//
//  MasjidChangeRequestVM.swift
//  Sabeel
//
//  Created by Owais on 2023-08-10.
//

import SwiftUI
import CloudKit

final class MasjidChangeRequestVM: ObservableObject {
    
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
    
    
    func dismiss() {
        withAnimation(.easeInOut) {
            isShowingThisView = false
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
        let newPrayerTimes = PrayerTimes(fajr: prayerTimes.fajr, dhuhr: prayerTimes.dhuhr, asr: prayerTimes.asr, maghrib: prayerTimes.maghrib, isha: prayerTimes.isha, juma: prayerTimes.juma)
        let newChangeRequest = MasjidChangeRequest(name: name, email: email, address: address, phoneNumber: phoneNumber, website: website, prayerTimes: newPrayerTimes, location: masjid.location )
        // upload both to cloudkit
        masjid.record[Masjid.kChangeRequest] = newChangeRequest.record.reference()
        
        CloudKitManager.shared.batchSave(records: [newPrayerTimes.record, newChangeRequest.record, masjid.record]) { res in
            onMainThread { [self] in
                switch res {
                    case .success(_):
                        alertItem = AlertContext.changeRequestCreationSuccess
                    case .failure(_):
                        alertItem = AlertContext.changeRequestCreationFailure
                }
            }
        }
    }
    
    
    func getChangeRequest(for masjidManager: MasjidManager) {
        populateBasedOn(masjidManager)
        
    }
    
    
    func populateBasedOn(_ masjidManager: MasjidManager) {
        guard let masjid = masjidManager.selectedMasjid else {
            // show alert
            return
        }
        if let changeRequestID = masjid.changeRequest?.recordID {
            CloudKitManager.shared.read(recordType: .changeRequest, predicate: .equalToRecordId(of: changeRequestID), resultsLimit: 1) { [self] (changeRequests: [MasjidChangeRequest]) in
                if changeRequests.count != 1 {
                    alertItem = AlertContext.genericErrorAlert
                    return
                }
                // populate using changeRequest
                let changeRequest = changeRequests[0]
                print(changeRequest)
                onMainThread { [self] in
                    name        = changeRequest.name
                    address     = changeRequest.address
                    email       = changeRequest.email!
                    phoneNumber = changeRequest.phoneNumber!
                    website     = changeRequest.website!
                }
                // get prayertimes from changereq
                CloudKitManager.shared.read(recordType: .prayerTimes, predicate: .equalToRecordId(of: changeRequest.prayerTimes.recordID)) { [self] (prayerTimess: [PrayerTimes]) in
                    guard prayerTimess.count > 0 else {
                        alertItem = AlertContext.genericErrorAlert
                        return
                    }
                    let prayerTimesFromCurrentMasjid = prayerTimess[0]
                    onMainThread { [self] in
                        prayerTimes = prayerTimesFromCurrentMasjid
                    }
                }
            }
            
            
        } else {
            name        = masjid.name
            address     = masjid.address
            email       = masjid.email
            phoneNumber = masjid.phoneNumber
            website     = masjid.website
            
            // get prayertimes
            
            CloudKitManager.shared.read(recordType: .prayerTimes, predicate: .equalToRecordId(of: masjid.prayerTimes.recordID)) { [self] (prayerTimess: [PrayerTimes]) in
                guard prayerTimess.count > 0 else {
                    alertItem = AlertContext.genericErrorAlert
                    return
                }
                let prayerTimesFromCurrentMasjid = prayerTimess[0]
                onMainThread { [self] in
                    prayerTimes = prayerTimesFromCurrentMasjid
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
        // get user ID
        CloudKitManager.shared.getUserRecord()
        guard let userRecord = CloudKitManager.shared.userRecord else {
            alertItem = AlertContext.noUserRecord
            return
        }
        // get change requests
        CloudKitManager.shared.read(recordType: .changeRequest, predicate: NSPredicate(format: "recordID = %@", changeRequestReference.recordID), resultsLimit: 1) { [self] (changeRequests: [MasjidChangeRequest]) in
            if changeRequests.count != 1 {
                alertItem = AlertContext.genericErrorAlert
                return
            }
            // use changeRequests[0]
            let changeRequestObject = changeRequests[0]
            
            if changeRequestObject.userRecordIdVotedYes.contains(userRecord.reference()) {
                alertItem = AlertContext.votedAlready
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
                // then, delete the changerequest and put the reference to it in masjid.record to nil
                CloudKitManager.shared.delete(changeRequestObject) { [self] res in
                    switch res {
                        case .success(let success):
                            //deleted
                            print(success)
                        case .failure(_):
                            alertItem = AlertContext.genericUnableToVote
                    }
                }
                masjid.record[Masjid.kChangeRequest]   = nil
                CloudKitManager.shared.batchSave(records: [masjid.record]) { res in
                    onMainThread { [self] in
                        switch res {
                            case .success(let saved):
                                print(saved)
                                alertItem = AlertContext.votedSuccess
                            case .failure(_):
                                alertItem = AlertContext.genericUnableToVote
                        }
                    }
                }
            } else {
                // save masjid record and changerequest record if not deleted
                CloudKitManager.shared.batchSave(records: [changeRequestObject.record]) {[self] res in
                    switch res {
                        case .success(_):
                            alertItem = AlertContext.votedSuccess
                        case .failure(_):
                            alertItem = AlertContext.genericUnableToVote
                    }
                }
            }
        }
    }
    
    
    func denyChangeRequest(with masjidManager: MasjidManager) {
        guard
            let masjid = masjidManager.selectedMasjid,
            let changeRequestReference = masjid.changeRequest
        else {
            alertItem = AlertContext.masjidDNE
            return
        }
        // get user ID
        CloudKitManager.shared.getUserRecord()
        guard let userRecord = CloudKitManager.shared.userRecord else {
            alertItem = AlertContext.noUserRecord
            return
        }
        // get change requests
        CloudKitManager.shared.read(recordType: .changeRequest, predicate: NSPredicate(format: "recordID = %@", changeRequestReference.recordID), resultsLimit: 1) { [self] (changeRequests: [MasjidChangeRequest]) in
            if changeRequests.count != 1 {
                alertItem = AlertContext.genericErrorAlert
                return
            }
            // use changeRequests[0]
            let changeRequestObject = changeRequests[0]
            
            if changeRequestObject.userRecordIdVotedNo.contains(userRecord.reference()) {
                alertItem = AlertContext.votedAlready
                return
            }
            // add user to list
            let userVotesList = (changeRequestObject.userRecordIdVotedNo + [userRecord.reference()])
            changeRequestObject.record[MasjidChangeRequest.kuserRecordsThatVotedNo] = userVotesList
            
            if userVotesList.count >= changeRequestObject.votesToPass {
                // if there are, delete the changerequest and put the reference to it in masjid.record to nil
                
                CloudKitManager.shared.delete(changeRequestObject) { [self] res in
                    switch res {
                        case .success(let success):
                            //deleted
                            print(success)
                        case .failure(_):
                            alertItem = AlertContext.genericUnableToVote
                    }
                }
                masjid.record[Masjid.kChangeRequest] = nil
                CloudKitManager.shared.batchSave(records: [masjid.record]) { [self] res in
                    onMainThread { [self] in
                        switch res {
                            case .success(let saved):
                                print(saved)
                                alertItem = AlertContext.votedSuccess
                            case .failure(_):
                                alertItem = AlertContext.genericUnableToVote
                                break
                        }
                    }
                }
            }
            else {
                // save masjid record and changerequest record if not deleted
                CloudKitManager.shared.batchSave(records: [changeRequestObject.record]) { [self] res in
                    switch res {
                        case .success(_):
                            alertItem = AlertContext.votedSuccess
                        case .failure(_):
                            alertItem = AlertContext.genericUnableToVote
                    }
                }
            }
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

