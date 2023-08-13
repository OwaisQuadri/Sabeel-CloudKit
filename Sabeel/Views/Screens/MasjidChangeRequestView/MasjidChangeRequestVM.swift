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
    @Binding var alertItem: AlertItem?
    
    
    func dismiss() {
        withAnimation(.easeInOut) {
            isShowingThisView = false
        }
    }
    
    init(showChangeTimingsView: Binding<Bool>, _ alertItem: Binding<AlertItem?>) {
        self._alertItem = alertItem
        self._isShowingThisView = showChangeTimingsView
    }
    
    
    func onAppear(with masjidManager: MasjidManager) {
        getChangeRequest(for: masjidManager)
    }
    
    
    func createNewChangeRequest(using masjidManager: MasjidManager) {
        // create changeRequest
        guard let masjid = masjidManager.selectedMasjid else {
            // alert : no masjid : generic : edge case
            return
        }
        let newPrayerTimes = PrayerTimes(fajr: prayerTimes.fajr, dhuhr: prayerTimes.dhuhr, asr: prayerTimes.asr, maghrib: prayerTimes.maghrib, isha: prayerTimes.isha, juma: prayerTimes.juma)
        let newChangeRequest = MasjidChangeRequest(name: name, email: email, address: address, phoneNumber: phoneNumber, website: website, prayerTimes: newPrayerTimes, location: masjid.location )
        // upload both to cloudkit
        masjid.record[Masjid.kChangeRequest] = newChangeRequest.record.reference()
        
        CloudKitManager.shared.batchSave(records: [newPrayerTimes.record, newChangeRequest.record, masjid.record]) { res in
            DispatchQueue.main.async { [self] in
                switch res {
                    case .success(_):
                        alertItem = AlertItem("Success", "some success", "OK")
                    case .failure(let e):
                        alertItem = AlertContext.genericErrorAlert(for: e)
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
            CloudKitManager.shared.read(recordType: .changeRequest, predicate: .equalToRecordId(of: changeRequestID), resultsLimit: 1) { (changeRequests: [MasjidChangeRequest]) in
                if changeRequests.count != 1 {
                    // something went terribly wrong
                    return
                }
                // populate using changeRequest
                let changeRequest = changeRequests[0]
                print(changeRequest)
                DispatchQueue.main.async { [self] in
                    name        = changeRequest.name
                    address     = changeRequest.address
                    email       = changeRequest.email!
                    phoneNumber = changeRequest.phoneNumber!
                    website     = changeRequest.website!
                }
                // get prayertimes from changereq
                CloudKitManager.shared.read(recordType: .prayerTimes, predicate: .equalToRecordId(of: changeRequest.prayerTimes.recordID)) { (prayerTimess: [PrayerTimes]) in
                    guard prayerTimess.count > 0 else {
                        // something went terribly wrong
                        return
                    }
                    let prayerTimesFromCurrentMasjid = prayerTimess[0]
                    DispatchQueue.main.async { [self] in
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
            
            CloudKitManager.shared.read(recordType: .prayerTimes, predicate: .equalToRecordId(of: masjid.prayerTimes.recordID)) { (prayerTimess: [PrayerTimes]) in
                guard prayerTimess.count > 0 else {
                    // something went terribly wrong
                    return
                }
                let prayerTimesFromCurrentMasjid = prayerTimess[0]
                DispatchQueue.main.async { [self] in
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
            // alert : no masjid : generic : edge case
            return
        }
        // get user ID
        CloudKitManager.shared.getUserRecord()
        guard let userRecord = CloudKitManager.shared.userRecord else {
            // show alert
            return
        }
        // get change requests
        CloudKitManager.shared.read(recordType: .changeRequest, predicate: NSPredicate(format: "recordID = %@", changeRequestReference.recordID), resultsLimit: 1) { (changeRequests: [MasjidChangeRequest]) in
            if changeRequests.count != 1 {
                // something went terribly wrong
                return
            }
            // use changeRequests[0]
            let changeRequestObject = changeRequests[0]
            
            if changeRequestObject.userRecordIdVotedYes.contains(userRecord.reference()) {
                // you have already voted
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
                CloudKitManager.shared.delete(changeRequestObject) { res in
                    switch res {
                        case .success(let success):
                            //deleted
                            print(success)
                            break
                        case .failure(let fail):
                            // unable to delete
                            print(fail)
                            break
                    }
                }
                masjid.record[Masjid.kChangeRequest]   = nil
                CloudKitManager.shared.batchSave(records: [masjid.record]) { res in
                    DispatchQueue.main.async { [self] in
                        switch res {
                            case .success(let saved):
                                print(saved)
                                alertItem = AlertContext.genericErrorAlert
                                break
                            case .failure(_):
                                // unable to save
                                break
                        }
                    }
                }
            } else {
                // save masjid record and changerequest record if not deleted
                CloudKitManager.shared.batchSave(records: [changeRequestObject.record]) { res in
                    switch res {
                        case .success(let saved):
                            print(saved)
                            break
                        case .failure(let err):
                            print(err)
                            break
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
            // alert : no masjid : generic : edge case
            return
        }
        // get user ID
        CloudKitManager.shared.getUserRecord()
        guard let userRecord = CloudKitManager.shared.userRecord else {
            // show alert
            return
        }
        // get change requests
        CloudKitManager.shared.read(recordType: .changeRequest, predicate: NSPredicate(format: "recordID = %@", changeRequestReference.recordID), resultsLimit: 1) { (changeRequests: [MasjidChangeRequest]) in
            if changeRequests.count != 1 {
                // something went terribly wrong
                return
            }
            // use changeRequests[0]
            let changeRequestObject = changeRequests[0]
            
            if changeRequestObject.userRecordIdVotedNo.contains(userRecord.reference()) {
                // you have already voted
                return
            }
            // add user to list
            let userVotesList = (changeRequestObject.userRecordIdVotedNo + [userRecord.reference()])
            changeRequestObject.record[MasjidChangeRequest.kuserRecordsThatVotedNo] = userVotesList
            
            if userVotesList.count >= changeRequestObject.votesToPass {
                // if there are, delete the changerequest and put the reference to it in masjid.record to nil
                
                CloudKitManager.shared.delete(changeRequestObject) { res in
                    switch res {
                        case .success(let success):
                            //deleted
                            print(success)
                            break
                        case .failure(let fail):
                            // unable to delete
                            print(fail)
                            break
                    }
                }
                masjid.record[Masjid.kChangeRequest] = nil
                CloudKitManager.shared.batchSave(records: [masjid.record]) { res in
                    switch res {
                        case .success(let saved):
                            print(saved)
                            break
                        case .failure(_):
                            // unable to save
                            break
                    }
                }
            }
            else {
                // save masjid record and changerequest record if not deleted
                CloudKitManager.shared.batchSave(records: [changeRequestObject.record]) { res in
                    switch res {
                        case .success(let saved):
                            print(saved)
                            break
                        case .failure(let err):
                            print(err)
                            break
                    }
                }
            }
        }
    }
    
}

