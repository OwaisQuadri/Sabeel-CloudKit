//
//  SabeelProfile.swift
//  Sabeel
//
//  Created by Owais on 2023-08-09.
//

import CloudKit

struct SabeelProfile {
    // create constants for cloudkit keys
    static let kName            = "name"
    static let kUsername        = "username"
    static let kPrayerStats     = "prayerStats"
    static let kIsPremium       = "isPremium"
    static let kHomeAddress     = "homeAddress"
    static let kHomeLocation    = "homeLocation"
    // editable to change schema^
        
    // structure
    let record          : CKRecord
    var name            : String
    var username        : String
    var homeAddress     : String!
    var homeLocation    : CLLocation!
    var isPremium       : Bool
    var prayerStats     : CKRecord.Reference!
    // editable to change schema^
}

extension SabeelProfile: CKObject {
    // create init befcause we want to create it using a record
    init(record: CKRecord) {
        self.record     = record
        name            = record[SabeelProfile.kName]           as? String ?? "N/A"
        homeAddress     = record[SabeelProfile.kHomeAddress]    as? String
        homeLocation    = record[SabeelProfile.kHomeLocation]   as? CLLocation
        username        = record[SabeelProfile.kUsername]       as? String ??  "N/A"
        isPremium       = record[SabeelProfile.kIsPremium]      as? Bool ?? false
        prayerStats     = record[SabeelProfile.kPrayerStats]    as? CKRecord.Reference
        // editable to change schema^
    }
    init?(
        name            : String,
        username        : String,
        homeAddress     : String?,
        homeLocation    : CLLocation?,
        isPremium       : Bool,
        prayerStats     : PrayerStats = PrayerStats() // empty if not init'ed
        // editable to change schema^
    ) {
        let record = CKRecord(.profile)
        
        record[SabeelProfile.kName]         = name
        record[SabeelProfile.kUsername]     = username
        record[SabeelProfile.kHomeAddress]  = homeAddress
        record[SabeelProfile.kHomeLocation] = homeLocation
        record[SabeelProfile.kIsPremium]    = isPremium
        
        CloudKitManager.shared.create(prayerStats) { _ in
        }
        record[SabeelProfile.kPrayerStats]  = prayerStats.record.reference(.deleteSelf)
        // editable to change schema^
        
        self.init(record: record)
    }
}

