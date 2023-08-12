//
//  CKRecord+Ext.swift
//  Sabeel
//
//  Created by Owais on 2023-08-09.
//

import CloudKit

extension CKRecord {
    convenience init(_ recordType: SabeelRecordType) {
        self.init(recordType: recordType.rawValue)
    }
    
    func convertToMasjid() -> Masjid { Masjid(record: self) }
    func convertToUserProfile() -> SabeelProfile { SabeelProfile(record: self) }
    func convertToPrayerTimes() -> PrayerTimes { PrayerTimes(record: self) }
    
    func reference(_ action: CKRecord.ReferenceAction = .none) -> CKRecord.Reference {
        return CKRecord.Reference( record: self, action: action )
    }
}

extension CKRecord.Reference {
    func convertToChangeRequest(completion: @escaping (MasjidChangeRequest?,PrayerTimes?) -> Void ) {
        var cROutput: MasjidChangeRequest? = nil
        var pTOutput: PrayerTimes? = nil
        let changeRequestID = self.recordID
        CloudKitManager.shared.read(recordType: .changeRequest, predicate: .equalToRecordId(of: changeRequestID), resultsLimit: 1) { (changeRequests: [MasjidChangeRequest]) in
            if changeRequests.count != 1 {
                // something went terribly wrong
                return
            }
            // populate using changeRequest
            cROutput = changeRequests[0]
            
            // get prayertimes from changereq
            guard let cROutput = cROutput else { return }
            cROutput.prayerTimes.convertToPrayerTimes { pT in
                pTOutput = pT
            }
        }
        completion (cROutput, pTOutput)
    }
    
    func convertToPrayerTimes(completion: @escaping (PrayerTimes?) -> Void ) {
        var pTOutput: PrayerTimes? = nil
        let prayerTimes = self.recordID
        
            CloudKitManager.shared.read(recordType: .prayerTimes, predicate: .equalToRecordId(of: prayerTimes)) { (prayerTimess: [PrayerTimes]) in
                guard prayerTimess.count > 0 else {
                    // something went terribly wrong
                    return
                }
                pTOutput = prayerTimess[0]
            
        }
        completion (pTOutput)
    }
}
