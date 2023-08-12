//
//  MasjidChangeRequestVM.swift
//  Sabeel
//
//  Created by Owais on 2023-08-10.
//

import SwiftUI
import CloudKit

final class MasjidChangeRequestVM: ObservableObject {
    
    @Published var showNotEditedAlert = false
    @Published var selectedChangeRequest: MasjidChangeRequest? = nil
    @Published var name                 : String = ""
    @Published var address              : String = ""
    @Published var email                : String = ""
    @Published var phoneNumber          : String = ""
    @Published var website              : String = ""
    @Published var prayerTimes          : PrayerTimes = PrayerTimes(fajr: "", dhuhr: "", asr: "", maghrib: "", isha: "", juma: [])
    @Published var isFromChangeRequest  : Bool = false
    
    func onAppear(with masjidManager: MasjidManager) {
        getChangeRequest(for: masjidManager)
    }
    
    func checkMarkButtonAction(using masjidManager: MasjidManager) {
        // create changeRequest
        guard let masjid = masjidManager.selectedMasjid else {
            // alert : no masjid : generic : edge case
            return
        }
        let newPrayerTimes = PrayerTimes(fajr: prayerTimes.fajr, dhuhr: prayerTimes.dhuhr, asr: prayerTimes.asr, maghrib: prayerTimes.maghrib, isha: prayerTimes.isha, juma: prayerTimes.juma)
        let newChangeRequest = MasjidChangeRequest(name: name, email: email, address: address, phoneNumber: phoneNumber, website: website, prayerTimes: newPrayerTimes, location: masjid.location )
        // upload both to cloudkit
        masjid.record[Masjid.kChangeRequest] = newChangeRequest.record.reference()
        
        CloudKitManager.shared.batchSave(records: [newPrayerTimes.record,newChangeRequest.record, masjid.record]) { res in
            switch res {
                case .success(let saved):
                    DispatchQueue.main.async { //[self] in // TODO: we will use it dont worry
                        
                        // alert successful submission
                        print(saved)
                        masjidManager.selectedMasjid = nil
                    }
                    break
                case .failure(_):
                    // alert fail
                    break
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
    
    func denyChangeRequest(with masjidManager: MasjidManager) {
        guard
            let masjid = masjidManager.selectedMasjid,
            let changeRequest = masjid.changeRequest
        else {
            // alert : no masjid : generic : edge case
            return
        }
        // get change requests
        
        // check if there are votesToPass-1 votes already
            // if there are, delete the changerequest and put the reference to it in masjid.record to nil
        
        // fetch URID
            // if there is no URID, send alert saying to go sign in
        
        // check if user is one of them
        
            // if they are send an alert (u cant vote twice!)
        
            // if they arent add them to list
        
        // save masjid record and changerequest record if not deleted
        
    }
    
    func acceptChangeRequest(with masjidManager: MasjidManager) {
        guard
            let masjid = masjidManager.selectedMasjid,
            let changeRequest = masjid.changeRequest
        else {
            // alert : no masjid : generic : edge case
            return
        }
        // get change requests
        
        // fetch URID
            // if there is no URID, send alert saying to go sign in
        
        // check if user is one of them
        
            // if they are send an alert (u cant vote twice!)
            
            // if they arent
                // check if there are votesToPass-1 votes already
                    // if there are, update masjid with changerequest values and CKM update
                    // then, delete the changerequest and put the reference to it in masjid.record to nil
                // add them to list
        
        // save masjid record and changerequest record if not deleted
    }
}
