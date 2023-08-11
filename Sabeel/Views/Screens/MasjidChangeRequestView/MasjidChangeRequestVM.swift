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
    @Published var name: String = ""
    @Published var address: String = ""
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    @Published var website: String = ""
    @Published var prayerTimes: PrayerTimes = PrayerTimes(fajr: "?", dhuhr: "?", asr: "?", maghrib: "?", isha: "?", juma: ["?"])
    @Published var isFromChangeRequest: Bool = false
    
    func checkMarkButtonAction() {
        //                            withAnimation (.easeInOut) {
        //                                if isEdited {
        //#warning("unable to set value for custom object inside binding")
        //                                    // TODO: implement viewModel
        //                                    self.selectedChangeRequest = MasjidChangeRequest(name: name, email: email, address: address, phoneNumber: phoneNumber, website: website, prayerTimes: prayerTimes, yesVotes: 1, noVotes: 0, votesToPass: 2)
        //                                    if let _ = selectedMasjid.changeRequest {
        //                                        dismiss()
        //                                    }
        //                                } else {
        //                                    showNotEditedAlert = true
        //                                }
        //                            }
    }
    
    func getChangeRequest(for locationManager: LocationManager) {
        if let changeRequest = locationManager.selectedMasjid?.changeRequest {
            CloudKitManager.shared.read(recordType: .changeRequest, predicate: NSPredicate(format: "recordID = %@", changeRequest.recordID) , resultsLimit: 1) { [self] (changeReq: [MasjidChangeRequest]) in
                DispatchQueue.main.async {
                    if changeReq.count == 1 {
                        // populate from change request
                        self.isFromChangeRequest = true
                        let changeRequest = changeReq[0]
                        self.selectedChangeRequest = changeRequest
                        self.name = changeRequest.name
                        self.address = changeRequest.address
                        self.email = changeRequest.email ?? ""
                        self.phoneNumber = changeRequest.phoneNumber ?? ""
                        self.website = changeRequest.website ?? ""
                        CloudKitManager.shared.read(recordType: .prayerTimes, predicate: NSPredicate(format: "recordID = %@", changeRequest.prayerTimes.recordID) , resultsLimit: 1) { (prayerTimes: [PrayerTimes]) in
                            DispatchQueue.main.async {
                                self.prayerTimes = prayerTimes[0]
                            }
                        }
                    } else {
                        // populate from masjid
                        self.isFromChangeRequest = false
                        if let masjid = locationManager.selectedMasjid {
                            self.name = masjid.name
                            self.address = masjid.address
                            self.email = masjid.email ?? ""
                            self.phoneNumber = masjid.phoneNumber ?? ""
                            self.website = masjid.website ?? ""
                            CloudKitManager.shared.read(recordType: .prayerTimes, predicate: NSPredicate(format: "recordID = %@", masjid.prayerTimes.recordID) , resultsLimit: 1) { (prayerTimes: [PrayerTimes]) in
                                DispatchQueue.main.async {
                                    self.prayerTimes = prayerTimes[0]
                                }
                            }
                        }
                        
                        
                    }
                }
            }
            
        }
    }
    
    
}
