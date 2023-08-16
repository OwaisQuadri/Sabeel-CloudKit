//
//  Masjid.swift
//  Sabeel
//
//  Created by Owais on 2023-08-07.
//

import CloudKit

struct Masjid {
    // create constants for cloudkit keys
    static let kName            = "name"
    static let kEmail           = "email"
    static let kAddress         = "address"
    static let kPhoneNumber     = "phoneNumber"
    static let kWebsite         = "website"
    static let kPrayerTimes     = "prayerTimings"
    static let kChangeRequest   = "changeRequest"
    static let kLocation        = "location"
    static let kIsConfirmed     = "isConfirmed"
    
    // structure
    var record          : CKRecord // must have
    var name            : String
    var email           : String!
    var address         : String
    var phoneNumber     : String!
    var website         : String!
    var prayerTimes     : CKRecord.Reference!
    var changeRequest   : CKRecord.Reference? = nil
    var location        : CLLocation!
    var isConfirmed     : Bool
}

extension Masjid: CKObject {
    // create init befcause we want to create it using a record
    init(record: CKRecord) { // failable add ? after init
        self.record     =   record
        name            =   record          [Masjid.kName] as? String ?? "Un-Named Mosque"
        email           =   record         [Masjid.kEmail] as? String
        address         =   record       [Masjid.kAddress] as? String ?? "Nowhere to be found"
        phoneNumber     =   record   [Masjid.kPhoneNumber] as? String
        website         =   record       [Masjid.kWebsite] as? String
        prayerTimes     =   record   [Masjid.kPrayerTimes] as? CKRecord.Reference
        location        =   record      [Masjid.kLocation] as? CLLocation
        changeRequest   =   record [Masjid.kChangeRequest] as? CKRecord.Reference
        isConfirmed     =   record   [Masjid.kIsConfirmed] as? Bool ?? false
    }
    
    // create memberwise init by creating record and passing it through our other init
    init(
        name            : String,
        email           : String?,
        address         : String,
        phoneNumber     : String?,
        website         : String?,
        prayerTimes     : PrayerTimes,
        location        : CLLocation,
        changeRequest   : MasjidChangeRequest? = nil,
        isConfirmed     : Bool = false
    ) {
        let record = CKRecord(.masjid)
        
        record[Masjid.kName]            = name
        record[Masjid.kEmail]           = email
        record[Masjid.kAddress]         = address
        record[Masjid.kPhoneNumber]     = phoneNumber
        record[Masjid.kWebsite]         = website
        record[Masjid.kPrayerTimes]     = prayerTimes.record.reference()
        record[Masjid.kChangeRequest]   = changeRequest?.record.reference()
        record[Masjid.kLocation]        = location
        record[Masjid.kIsConfirmed]     = isConfirmed
        
        self.init(record: record)
    }
}
extension Masjid: Equatable {
    static func == (lhs: Masjid, rhs: Masjid) -> Bool {
        lhs.name == rhs.name && lhs.email == rhs.email && lhs.address == rhs.address && lhs.phoneNumber == rhs.phoneNumber && lhs.website == rhs.website && lhs.prayerTimes == rhs.prayerTimes
    }
}
extension Masjid: Identifiable {
    var id: CKRecord.ID {
        record.recordID
    }
}
