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
